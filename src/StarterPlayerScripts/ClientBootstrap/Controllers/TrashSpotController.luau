-- Client-local randomized trash spot rendering and miss cooldown feedback.
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local TrashSpotConfig = require(ReplicatedStorage.Shared.Config.TrashSpotConfig)
local MutationConfig = require(ReplicatedStorage.Shared.Config.MutationConfig)
local UIAssetConfig = require(ReplicatedStorage.Shared.Config.UIAssetConfig)
local RewardBanner = require(script.Parent.Parent.UI.RewardBanner)

local TrashSpotController = {}

local REJECT_COLOR = Color3.fromRGB(200, 80, 80)

local spotLookup = {}
local activeCountdownTokens = {}
local localFolder
local interactRemote

local function round(guiObject, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = guiObject
end

local function stroke(guiObject, color, thickness)
	local outline = Instance.new("UIStroke")
	outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	outline.Color = color
	outline.Thickness = thickness
	outline.LineJoinMode = Enum.LineJoinMode.Round
	outline.Parent = guiObject
end

local function createStatusBillboard(part)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "StatusBillboard"
	billboard.Size = UDim2.fromOffset(220, 60)
	billboard.StudsOffset = Vector3.new(0, 2.7, 0)
	billboard.AlwaysOnTop = true
	billboard.LightInfluence = 0
	billboard.Enabled = false
	billboard.Parent = part

	local statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "StatusLabel"
	statusLabel.Size = UDim2.new(1, -8, 1, -8)
	statusLabel.Position = UDim2.fromOffset(4, 4)
	statusLabel.BackgroundColor3 = Color3.fromRGB(12, 27, 52)
	statusLabel.BorderSizePixel = 0
	statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	statusLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	statusLabel.TextStrokeTransparency = 0.55
	statusLabel.Font = Enum.Font.GothamBlack
	statusLabel.TextSize = 17
	statusLabel.TextXAlignment = Enum.TextXAlignment.Right
	statusLabel.RichText = true
	statusLabel.Text = ""
	statusLabel.Parent = billboard
	round(statusLabel, 14)
	stroke(statusLabel, Color3.fromRGB(242, 75, 85), 2)

	local padding = Instance.new("UIPadding")
	padding.PaddingRight = UDim.new(0, 13)
	padding.Parent = statusLabel

	local icon = Instance.new("ImageLabel")
	icon.Name = "TrashIcon"
	icon.Size = UDim2.fromOffset(48, 48)
	icon.Position = UDim2.fromOffset(8, 6)
	icon.BackgroundTransparency = 1
	icon.Image = UIAssetConfig.Get("TrashCollect")
	icon.ScaleType = Enum.ScaleType.Fit
	icon.ZIndex = 2
	icon.Parent = billboard

	return billboard, statusLabel
end

local function applyMutationVisuals(adornee, part, prompt, mutationId)
	local mutation = MutationConfig.Get(mutationId)
	part:SetAttribute("MutationId", mutation.Id)
	part:SetAttribute("MutationDisplayName", mutation.DisplayName)
	part:SetAttribute("MutationMultiplier", mutation.Multiplier)
	prompt.ObjectText = mutation.Id == MutationConfig.NoneId
		and prompt.ObjectText
		or MutationConfig.ApplyToName(mutation.Id, prompt.ObjectText)

	if mutation.Id == MutationConfig.NoneId then
		return
	end

	local highlight = Instance.new("Highlight")
	highlight.Name = "MutationHighlight"
	highlight.Adornee = adornee
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.FillColor = mutation.Color
	highlight.FillTransparency = 0.62
	highlight.OutlineColor = mutation.SecondaryColor or mutation.Color
	highlight.OutlineTransparency = 0.05
	highlight.Parent = part

	local attachment = Instance.new("Attachment")
	attachment.Name = "MutationAura"
	attachment.Parent = part

	local particles = Instance.new("ParticleEmitter")
	particles.Name = "AuraParticles"
	particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	particles.Color = ColorSequence.new(mutation.Color, mutation.SecondaryColor or mutation.Color)
	particles.LightEmission = 0.8
	particles.Rate = mutation.ParticleRate or 10
	particles.Lifetime = NumberRange.new(0.9, 1.5)
	particles.Speed = NumberRange.new(0.45, 1.2)
	particles.SpreadAngle = Vector2.new(180, 180)
	particles.Rotation = NumberRange.new(0, 360)
	particles.RotSpeed = NumberRange.new(-70, 70)
	particles.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.22),
		NumberSequenceKeypoint.new(0.45, 0.48),
		NumberSequenceKeypoint.new(1, 0),
	})
	particles.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.15),
		NumberSequenceKeypoint.new(0.75, 0.35),
		NumberSequenceKeypoint.new(1, 1),
	})
	particles.Parent = attachment

	local light = Instance.new("PointLight")
	light.Name = "AuraLight"
	light.Color = mutation.Color
	light.Brightness = mutation.Id == "Cosmic" and 2.2 or 1.4
	light.Range = mutation.Id == "Cosmic" and 12 or 8
	light.Shadows = false
	light.Parent = attachment
end

local function playCollectBurst(entry)
	local origin = entry.Part.Position
	local color = entry.Part.Color:Lerp(Color3.new(1, 1, 1), 0.3)

	local pulse = Instance.new("Part")
	pulse.Name = "LocalCollectPulse"
	pulse.Shape = Enum.PartType.Ball
	pulse.Anchored = true
	pulse.CanCollide = false
	pulse.CanTouch = false
	pulse.CanQuery = false
	pulse.CastShadow = false
	pulse.Material = Enum.Material.Neon
	pulse.Color = color
	pulse.Transparency = 0.2
	pulse.Size = Vector3.new(0.5, 0.5, 0.5)
	pulse.Position = origin
	pulse.Parent = Workspace
	Debris:AddItem(pulse, 0.6)

	TweenService:Create(
		pulse,
		TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ Size = Vector3.new(6, 6, 6), Transparency = 1 }
	):Play()

	for _ = 1, 9 do
		local spark = Instance.new("Part")
		spark.Name = "LocalCollectSpark"
		spark.Anchored = true
		spark.CanCollide = false
		spark.CanTouch = false
		spark.CanQuery = false
		spark.CastShadow = false
		spark.Material = Enum.Material.Neon
		spark.Color = color
		spark.Size = Vector3.new(0.18, 0.18, 0.18) * math.random(1, 3)
		spark.Position = origin + Vector3.new(0, 0.5, 0)
		spark.Parent = Workspace
		Debris:AddItem(spark, 0.8)

		local direction = Vector3.new(
			math.random(-100, 100) / 55,
			math.random(55, 135) / 55,
			math.random(-100, 100) / 55
		)
		TweenService:Create(
			spark,
			TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Position = spark.Position + direction, Transparency = 1 }
		):Play()
	end
end

local function createGroundDressingPart(model, name, size, cframe, color, material, shape, transparency)
	local terrainPart = Instance.new("Part")
	terrainPart.Name = "GroundDressing_" .. name
	terrainPart.Anchored = true
	terrainPart.CanCollide = false
	terrainPart.CanTouch = false
	terrainPart.CanQuery = false
	terrainPart.CastShadow = false
	terrainPart.Size = size
	terrainPart.CFrame = cframe
	terrainPart.Color = color
	terrainPart.Material = material
	terrainPart.Transparency = transparency or 0
	if shape then
		terrainPart.Shape = shape
	end
	terrainPart.Parent = model
	return terrainPart
end

local function addZoneGroundDressing(model, zoneName, yawSeed)
	local boundsCF, boundsSize = model:GetBoundingBox()
	local bottomY = boundsCF.Position.Y - boundsSize.Y * 0.5
	local center = Vector3.new(boundsCF.Position.X, bottomY, boundsCF.Position.Z)
	local width = math.clamp(boundsSize.X + 1.1, 4.5, 10)
	local depth = math.clamp(boundsSize.Z + 1.1, 4.5, 10)
	local rotation = math.rad(yawSeed % 360)

	if zoneName == "Downtown" then
		createGroundDressingPart(
			model,
			"Pavement",
			Vector3.new(width, 0.08, depth),
			CFrame.new(center + Vector3.new(0, 0.04, 0)) * CFrame.Angles(0, rotation, 0),
			Color3.fromRGB(72, 76, 84),
			Enum.Material.Concrete
		)
		createGroundDressingPart(
			model,
			"Crack",
			Vector3.new(width * 0.72, 0.025, 0.09),
			CFrame.new(center + Vector3.new(0, 0.095, 0)) * CFrame.Angles(0, rotation + math.rad(27), 0),
			Color3.fromRGB(27, 30, 36),
			Enum.Material.Slate,
			nil,
			0.12
		)
		createGroundDressingPart(
			model,
			"RoadMark",
			Vector3.new(width * 0.4, 0.025, 0.18),
			CFrame.new(center + Vector3.new(0, 0.1, depth * 0.34)) * CFrame.Angles(0, rotation - math.rad(8), 0),
			Color3.fromRGB(231, 181, 45),
			Enum.Material.SmoothPlastic,
			nil,
			0.35
		)
	elseif zoneName == "Beach" then
		createGroundDressingPart(
			model,
			"SandMound",
			Vector3.new(width + 0.8, 0.18, depth + 0.8),
			CFrame.new(center + Vector3.new(0, 0.03, 0)) * CFrame.Angles(0, rotation, 0),
			Color3.fromRGB(225, 195, 126),
			Enum.Material.Sand,
			Enum.PartType.Ball
		)
		createGroundDressingPart(
			model,
			"WetSand",
			Vector3.new(width * 0.72, 0.07, depth * 0.58),
			CFrame.new(center + Vector3.new(width * 0.13, 0.07, -depth * 0.12)),
			Color3.fromRGB(172, 143, 93),
			Enum.Material.Sand,
			Enum.PartType.Ball,
			0.12
		)
		createGroundDressingPart(
			model,
			"Shell",
			Vector3.new(0.38, 0.12, 0.28),
			CFrame.new(center + Vector3.new(-width * 0.4, 0.12, depth * 0.28))
				* CFrame.Angles(0, rotation + math.rad(35), math.rad(12)),
			Color3.fromRGB(255, 220, 178),
			Enum.Material.SmoothPlastic,
			Enum.PartType.Ball
		)
	elseif zoneName == "Factory" then
		createGroundDressingPart(
			model,
			"StainedConcrete",
			Vector3.new(width, 0.08, depth),
			CFrame.new(center + Vector3.new(0, 0.04, 0)) * CFrame.Angles(0, rotation, 0),
			Color3.fromRGB(82, 84, 80),
			Enum.Material.Concrete
		)
		createGroundDressingPart(
			model,
			"OilSpill",
			Vector3.new(width * 0.68, 0.045, depth * 0.6),
			CFrame.new(center + Vector3.new(width * 0.12, 0.085, -depth * 0.08)),
			Color3.fromRGB(17, 20, 19),
			Enum.Material.SmoothPlastic,
			Enum.PartType.Ball,
			0.08
		)
		createGroundDressingPart(
			model,
			"RustStain",
			Vector3.new(width * 0.4, 0.035, depth * 0.32),
			CFrame.new(center + Vector3.new(-width * 0.23, 0.092, depth * 0.23)),
			Color3.fromRGB(145, 72, 39),
			Enum.Material.SmoothPlastic,
			Enum.PartType.Ball,
			0.18
		)
	elseif zoneName == "Junkyard" then
		createGroundDressingPart(
			model,
			"JunkyardDirt",
			Vector3.new(width, 0.09, depth),
			CFrame.new(center + Vector3.new(0, 0.045, 0)) * CFrame.Angles(0, rotation, 0),
			Color3.fromRGB(94, 73, 54),
			Enum.Material.Ground
		)
		createGroundDressingPart(
			model,
			"JunkyardOil",
			Vector3.new(width * 0.62, 0.045, depth * 0.48),
			CFrame.new(center + Vector3.new(width * 0.13, 0.096, -depth * 0.1)),
			Color3.fromRGB(19, 20, 22),
			Enum.Material.SmoothPlastic,
			Enum.PartType.Ball,
			0.08
		)
		createGroundDressingPart(
			model,
			"JunkyardRust",
			Vector3.new(width * 0.45, 0.04, depth * 0.35),
			CFrame.new(center + Vector3.new(-width * 0.2, 0.101, depth * 0.2)),
			Color3.fromRGB(158, 68, 34),
			Enum.Material.SmoothPlastic,
			Enum.PartType.Ball,
			0.15
		)
	elseif zoneName == "Sewers" then
		createGroundDressingPart(
			model,
			"WetSewerStone",
			Vector3.new(width, 0.09, depth),
			CFrame.new(center + Vector3.new(0, 0.045, 0)) * CFrame.Angles(0, rotation, 0),
			Color3.fromRGB(58, 69, 64),
			Enum.Material.Slate
		)
		createGroundDressingPart(
			model,
			"SewerWater",
			Vector3.new(width * 0.72, 0.05, depth * 0.55),
			CFrame.new(center + Vector3.new(width * 0.08, 0.098, -depth * 0.05)),
			Color3.fromRGB(56, 112, 72),
			Enum.Material.Glass,
			Enum.PartType.Ball,
			0.22
		)
		createGroundDressingPart(
			model,
			"ToxicSlime",
			Vector3.new(width * 0.38, 0.045, depth * 0.3),
			CFrame.new(center + Vector3.new(-width * 0.24, 0.105, depth * 0.2)),
			Color3.fromRGB(75, 255, 72),
			Enum.Material.Neon,
			Enum.PartType.Ball,
			0.18
		)
	elseif zoneName == "FrostbiteHarbor" then
		createGroundDressingPart(
			model,
			"PackedSnow",
			Vector3.new(width + 0.6, 0.14, depth + 0.6),
			CFrame.new(center + Vector3.new(0, 0.035, 0)) * CFrame.Angles(0, rotation, 0),
			Color3.fromRGB(224, 241, 247),
			Enum.Material.Snow,
			Enum.PartType.Ball
		)
		createGroundDressingPart(
			model,
			"ClearIce",
			Vector3.new(width * 0.74, 0.055, depth * 0.58),
			CFrame.new(center + Vector3.new(width * 0.08, 0.105, -depth * 0.08)),
			Color3.fromRGB(133, 216, 239),
			Enum.Material.Ice,
			Enum.PartType.Ball,
			0.16
		)
		createGroundDressingPart(
			model,
			"IceCrack",
			Vector3.new(width * 0.56, 0.026, 0.085),
			CFrame.new(center + Vector3.new(-width * 0.08, 0.142, depth * 0.08)) * CFrame.Angles(0, rotation + math.rad(38), 0),
			Color3.fromRGB(52, 113, 145),
			Enum.Material.Neon,
			nil,
			0.22
		)
	elseif zoneName == "HauntedCarnival" then
		createGroundDressingPart(
			model,
			"MidwayDirt",
			Vector3.new(width + 0.5, 0.1, depth + 0.5),
			CFrame.new(center + Vector3.new(0, 0.03, 0)) * CFrame.Angles(0, rotation, 0),
			Color3.fromRGB(54, 39, 62),
			Enum.Material.Ground,
			Enum.PartType.Ball
		)
		createGroundDressingPart(
			model,
			"DiscardedTickets",
			Vector3.new(width * 0.72, 0.035, depth * 0.42),
			CFrame.new(center + Vector3.new(width * 0.1, 0.09, -depth * 0.12)) * CFrame.Angles(0, rotation + math.rad(24), 0),
			Color3.fromRGB(244, 184, 54),
			Enum.Material.SmoothPlastic,
			Enum.PartType.Ball,
			0.12
		)
		createGroundDressingPart(
			model,
			"Ectoplasm",
			Vector3.new(width * 0.38, 0.045, depth * 0.3),
			CFrame.new(center + Vector3.new(-width * 0.24, 0.105, depth * 0.2)),
			Color3.fromRGB(112, 255, 70),
			Enum.Material.Neon,
			Enum.PartType.Ball,
			0.18
		)
	elseif zoneName == "ToxicSwamp" then
		createGroundDressingPart(
			model,
			"SwampMud",
			Vector3.new(width + 0.8, 0.14, depth + 0.8),
			CFrame.new(center + Vector3.new(0, 0.035, 0)) * CFrame.Angles(0, rotation, 0),
			Color3.fromRGB(67, 58, 40),
			Enum.Material.Mud,
			Enum.PartType.Ball
		)
		createGroundDressingPart(
			model,
			"BogWater",
			Vector3.new(width * 0.76, 0.055, depth * 0.58),
			CFrame.new(center + Vector3.new(width * 0.08, 0.105, -depth * 0.08)),
			Color3.fromRGB(49, 93, 59),
			Enum.Material.Glass,
			Enum.PartType.Ball,
			0.24
		)
		createGroundDressingPart(
			model,
			"ToxicSpill",
			Vector3.new(width * 0.4, 0.045, depth * 0.31),
			CFrame.new(center + Vector3.new(-width * 0.25, 0.11, depth * 0.2)),
			Color3.fromRGB(119, 255, 65),
			Enum.Material.Neon,
			Enum.PartType.Ball,
			0.14
		)
	elseif zoneName == "NuclearWasteland" then
		createGroundDressingPart(
			model,
			"BlastAsh",
			Vector3.new(width + 0.9, 0.15, depth + 0.9),
			CFrame.new(center + Vector3.new(0, 0.04, 0)) * CFrame.Angles(0, rotation, 0),
			Color3.fromRGB(62, 64, 57),
			Enum.Material.Slate,
			Enum.PartType.Ball
		)
		createGroundDressingPart(
			model,
			"CrackedConcrete",
			Vector3.new(width * 0.78, 0.06, depth * 0.61),
			CFrame.new(center + Vector3.new(width * 0.07, 0.11, -depth * 0.08)) * CFrame.Angles(0, rotation + math.rad(11), 0),
			Color3.fromRGB(91, 94, 84),
			Enum.Material.Concrete,
			Enum.PartType.Ball
		)
		createGroundDressingPart(
			model,
			"RadioactiveLeak",
			Vector3.new(width * 0.42, 0.05, depth * 0.32),
			CFrame.new(center + Vector3.new(-width * 0.25, 0.12, depth * 0.2)),
			Color3.fromRGB(205, 255, 54),
			Enum.Material.Neon,
			Enum.PartType.Ball,
			0.12
		)
	elseif zoneName == "WorldsEndLandfill" then
		createGroundDressingPart(
			model,
			"LandfillDirt",
			Vector3.new(width + 1.1, 0.16, depth + 1.1),
			CFrame.new(center + Vector3.new(0, 0.04, 0)) * CFrame.Angles(0, rotation, 0),
			Color3.fromRGB(82, 69, 53),
			Enum.Material.Ground,
			Enum.PartType.Ball
		)
		createGroundDressingPart(
			model,
			"CompressedScrap",
			Vector3.new(width * 0.72, 0.08, depth * 0.55),
			CFrame.new(center + Vector3.new(width * 0.13, 0.12, -depth * 0.12)) * CFrame.Angles(0, rotation + math.rad(17), 0),
			Color3.fromRGB(91, 86, 76),
			Enum.Material.CorrodedMetal,
			Enum.PartType.Ball
		)
		createGroundDressingPart(
			model,
			"MethaneSlime",
			Vector3.new(width * 0.38, 0.045, depth * 0.29),
			CFrame.new(center + Vector3.new(-width * 0.27, 0.13, depth * 0.21)),
			Color3.fromRGB(151, 255, 72),
			Enum.Material.Neon,
			Enum.PartType.Ball,
			0.12
		)
	end
end

local function getTrashTemplate(zoneName, typeConfig)
	local modelsFolder = ReplicatedStorage:FindFirstChild("TrashModels")
	local modelSize = typeConfig.ModelSize
	if not modelsFolder or type(modelSize) ~= "string" then
		return nil
	end
	return modelsFolder:FindFirstChild(zoneName .. "_" .. modelSize)
end

local function createLocalSpot(spotData)
	local typeConfig = TrashSpotConfig.Types[spotData.Type]
	if not typeConfig then
		warn("Unknown client trash type: " .. tostring(spotData.Type))
		return nil
	end

	local template = getTrashTemplate(spotData.Zone, typeConfig)
	if not template or not template:IsA("Model") then
		warn(("Missing trash model %s_%s"):format(
			tostring(spotData.Zone),
			tostring(typeConfig.ModelSize)
		))
		return nil
	end

	local model = template:Clone()
	model.Name = spotData.Zone .. "_" .. typeConfig.ModelSize .. "_" .. spotData.Id
	local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
	if not part then
		model:Destroy()
		warn("Trash model has no BasePart: " .. template:GetFullName())
		return nil
	end
	model.PrimaryPart = part

	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Anchored = true
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = true
		end
	end

	local groundPosition = spotData.Position - Vector3.new(0, typeConfig.Size.Y * 0.5, 0)
	local yawSeed = 0
	for index = 1, #spotData.Id do
		yawSeed = (yawSeed * 33 + string.byte(spotData.Id, index)) % 360
	end
	yawSeed = (yawSeed + math.floor(math.abs(spotData.Position.X * 13 + spotData.Position.Z * 7))) % 360

	model:PivotTo(
		CFrame.new(groundPosition)
			* CFrame.Angles(0, math.rad(yawSeed), 0)
			* model:GetPivot()
	)
	addZoneGroundDressing(model, spotData.Zone, yawSeed)
	model:SetAttribute("SpotId", spotData.Id)
	model:SetAttribute("ZoneName", spotData.Zone)
	model:SetAttribute("TrashSize", typeConfig.ModelSize)
	part:SetAttribute("SpotId", spotData.Id)
	part:SetAttribute("ZoneName", spotData.Zone)
	model.Parent = localFolder

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "SearchPrompt"
	prompt.ActionText = "Collect"
	prompt.ObjectText = typeConfig.DisplayName
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 8
	prompt.RequiresLineOfSight = false
	prompt.Parent = part

	local billboard, statusLabel = createStatusBillboard(part)
	local boundsCF, boundsSize = model:GetBoundingBox()
	billboard.StudsOffsetWorldSpace = Vector3.new(
		0,
		boundsCF.Position.Y + boundsSize.Y * 0.5 - part.Position.Y + 1,
		0
	)
	applyMutationVisuals(model, part, prompt, spotData.MutationId)

	local entry = {
		Instance = model,
		Part = part,
		Prompt = prompt,
		Billboard = billboard,
		StatusLabel = statusLabel,
	}

	prompt.Triggered:Connect(function()
		if interactRemote then
			interactRemote:FireServer(spotData.Id)
		end
	end)

	spotLookup[spotData.Id] = entry
	return entry
end

local function replaceSpot(data)
	local spotData = data.Spot
	if type(spotData) ~= "table" or type(spotData.Id) ~= "string" then
		return
	end

	local oldEntry = spotLookup[spotData.Id]
	if oldEntry then
		activeCountdownTokens[spotData.Id] = nil
		if data.Action == "Reroll" then
			playCollectBurst(oldEntry)
		end
		(oldEntry.Instance or oldEntry.Part):Destroy()
		spotLookup[spotData.Id] = nil
	end

	createLocalSpot(spotData)
end

local function restoreSpot(entry)
	if not entry.Part.Parent then
		return
	end
	if entry.Prompt then
		entry.Prompt.Enabled = true
	end
	if entry.Billboard then
		entry.Billboard.Enabled = false
	end
end

local function runMissCooldown(spotId, entry, duration)
	local token = {}
	activeCountdownTokens[spotId] = token

	if entry.Prompt then
		entry.Prompt.Enabled = false
	end
	if entry.Billboard and entry.StatusLabel then
		entry.Billboard.Enabled = true
	end

	task.spawn(function()
		local endsAt = os.clock() + duration
		while activeCountdownTokens[spotId] == token do
			local remaining = endsAt - os.clock()
			if remaining <= 0 then
				break
			end
			if entry.StatusLabel then
				entry.StatusLabel.Text = ('<font color="#FF737D">COOLDOWN</font>  <font color="#FFFFFF">%ds</font>'):format(
					math.ceil(remaining)
				)
			end
			task.wait(0.1)
		end

		if activeCountdownTokens[spotId] == token then
			activeCountdownTokens[spotId] = nil
			restoreSpot(entry)
		end
	end)
end

function TrashSpotController.Init(remotes)
	interactRemote = remotes.Trash.Interact

	local oldFolder = Workspace:FindFirstChild("ClientTrashSpots")
	if oldFolder then
		oldFolder:Destroy()
	end
	localFolder = Instance.new("Folder")
	localFolder.Name = "ClientTrashSpots"
	localFolder.Parent = Workspace

	remotes.Trash.Sync.OnClientEvent:Connect(replaceSpot)

	remotes.Trash.Interact.OnClientEvent:Connect(function(data)
		if not data.Success and data.Reason ~= "You're already collecting this" then
			RewardBanner.ShowText(data.Reason or "Can't collect that right now", REJECT_COLOR)
		end
	end)

	remotes.Trash.Cooldown.OnClientEvent:Connect(function(data)
		local entry = spotLookup[data.SpotId]
		if entry then
			runMissCooldown(data.SpotId, entry, data.DurationSeconds or TrashSpotConfig.MissCooldownSeconds)
		end
	end)

	-- The client requests a fresh snapshot after all listeners are connected, so
	-- no initial randomized spots are lost during join/load timing.
	remotes.Trash.RequestSync:FireServer()
end

return TrashSpotController
