-- ESPModule.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local ESPModule = {}

-- 設定初始參數
local camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local DrawingESP = {}
local ESPConnections = {}
local TrackedPlayers = {}

ESPModule.BoxColor = Color3.fromRGB(0, 255, 100)
ESPModule.SkeletonColor = Color3.fromRGB(0, 255, 255)

ESPModule.AllVars = {
	espbool = false,
	box = false,
	health = false,
	skeleton = false,
	espbots = false,
}

-- 建立繪圖物件
local function NewLine(color)
	local l = Drawing.new("Line")
	l.Visible = false
	l.Thickness = 1
	l.Transparency = 1
	l.Color = color or ESPModule.SkeletonColor
	table.insert(DrawingESP, l)
	return l
end

local function NewBox(color)
	local b = Drawing.new("Quad")
	b.Visible = false
	b.Filled = false
	b.Thickness = 1
	b.Transparency = 1
	b.Color = color or ESPModule.BoxColor
	table.insert(DrawingESP, b)
	return b
end

-- 清除所有繪製的 ESP
local function clearAllESP()
	for _, v in pairs(DrawingESP) do
		if v.Remove then v:Remove() end
	end
	DrawingESP = {}

	for _, conn in pairs(ESPConnections) do
		conn:Disconnect()
	end
	ESPConnections = {}

	table.clear(TrackedPlayers)
end

-- 主追蹤函數
local function trackPlayer(plr, isAI)
	if TrackedPlayers[plr] then return end
	TrackedPlayers[plr] = true

	local char = isAI and plr.Character or plr.Character

	local lines = {
		Box = NewBox(),
		HealthBack = NewLine(Color3.new(0, 0, 0)),
		HealthBar = NewLine(Color3.new(0, 255, 0)),

		-- Skeleton lines
		SpineTop = NewLine(),
		SpineMid = NewLine(),
		LeftArm = NewLine(), LeftForearm = NewLine(), LeftHand = NewLine(),
		RightArm = NewLine(), RightForearm = NewLine(), RightHand = NewLine(),
		LeftLeg = NewLine(), LeftShin = NewLine(), LeftFoot = NewLine(),
		RightLeg = NewLine(), RightShin = NewLine(), RightFoot = NewLine(),
	}

	local function removeLines()
		for _, l in pairs(lines) do
			if l.Remove then l:Remove() else l.Visible = false end
		end
		TrackedPlayers[plr] = nil
	end

	local conn
	conn = RunService.RenderStepped:Connect(function()
		char = isAI and plr.Character or plr.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local hrp = char and char:FindFirstChild("HumanoidRootPart")

		if not (char and hum and hrp and hum.Health > 0) then
			for _, l in pairs(lines) do l.Visible = false end
			return
		end

		local pos = camera:WorldToViewportPoint(hrp.Position)
		if pos.Z <= 0 then
			for _, l in pairs(lines) do l.Visible = false end
			return
		end

		local height, width = 160, 100
		local cx, cy = pos.X, pos.Y

		-- Box ESP
		if ESPModule.AllVars.box then
			lines.Box.Color = isAI and Color3.fromRGB(255, 255, 0) or ESPModule.BoxColor
			lines.Box.Visible = true
			lines.Box.PointA = Vector2.new(cx - width / 2, cy - height / 2)
			lines.Box.PointB = Vector2.new(cx + width / 2, cy - height / 2)
			lines.Box.PointC = Vector2.new(cx + width / 2, cy + height / 2)
			lines.Box.PointD = Vector2.new(cx - width / 2, cy + height / 2)
		else
			lines.Box.Visible = false
		end

		-- Health Bar
		if ESPModule.AllVars.health then
			local r = hum.Health / hum.MaxHealth
			local left = cx - width / 2 - 5
			lines.HealthBack.Visible = true
			lines.HealthBack.From = Vector2.new(left, cy + height / 2)
			lines.HealthBack.To = Vector2.new(left, cy - height / 2)

			lines.HealthBar.Visible = true
			lines.HealthBar.From = Vector2.new(left, cy + height / 2)
			lines.HealthBar.To = Vector2.new(left, cy + height / 2 - height * r)
			lines.HealthBar.Color = Color3.fromRGB(255 * (1 - r), 255 * r, 0)
		else
			lines.HealthBack.Visible = false
			lines.HealthBar.Visible = false
		end

		-- Skeleton
		local function draw(part1, part2, line)
			if part1 and part2 then
				local a, on1 = camera:WorldToViewportPoint(part1.Position)
				local b, on2 = camera:WorldToViewportPoint(part2.Position)
				if on1 and on2 then
					line.Visible = true
					line.From = Vector2.new(a.X, a.Y)
					line.To = Vector2.new(b.X, b.Y)
					line.Color = ESPModule.SkeletonColor
					return
				end
			end
			line.Visible = false
		end

		if ESPModule.AllVars.skeleton then
			local p = {
				Head = char:FindFirstChild("Head"),
				UpperTorso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"),
				LowerTorso = char:FindFirstChild("LowerTorso"),
				LeftUpperArm = char:FindFirstChild("LeftUpperArm"),
				LeftLowerArm = char:FindFirstChild("LeftLowerArm"),
				LeftHand = char:FindFirstChild("LeftHand"),
				RightUpperArm = char:FindFirstChild("RightUpperArm"),
				RightLowerArm = char:FindFirstChild("RightLowerArm"),
				RightHand = char:FindFirstChild("RightHand"),
				LeftUpperLeg = char:FindFirstChild("LeftUpperLeg"),
				LeftLowerLeg = char:FindFirstChild("LeftLowerLeg"),
				LeftFoot = char:FindFirstChild("LeftFoot"),
				RightUpperLeg = char:FindFirstChild("RightUpperLeg"),
				RightLowerLeg = char:FindFirstChild("RightLowerLeg"),
				RightFoot = char:FindFirstChild("RightFoot"),
			}

			draw(p.Head, p.UpperTorso, lines.SpineTop)
			draw(p.UpperTorso, p.LowerTorso, lines.SpineMid)
			draw(p.UpperTorso, p.LeftUpperArm, lines.LeftArm)
			draw(p.LeftUpperArm, p.LeftLowerArm, lines.LeftForearm)
			draw(p.LeftLowerArm, p.LeftHand, lines.LeftHand)
			draw(p.UpperTorso, p.RightUpperArm, lines.RightArm)
			draw(p.RightUpperArm, p.RightLowerArm, lines.RightForearm)
			draw(p.RightLowerArm, p.RightHand, lines.RightHand)
			draw(p.LowerTorso, p.LeftUpperLeg, lines.LeftLeg)
			draw(p.LeftUpperLeg, p.LeftLowerLeg, lines.LeftShin)
			draw(p.LeftLowerLeg, p.LeftFoot, lines.LeftFoot)
			draw(p.LowerTorso, p.RightUpperLeg, lines.RightLeg)
			draw(p.RightUpperLeg, p.RightLowerLeg, lines.RightShin)
			draw(p.RightLowerLeg, p.RightFoot, lines.RightFoot)
		else
			for _, name in pairs({
				"SpineTop", "SpineMid", "LeftArm", "LeftForearm", "LeftHand",
				"RightArm", "RightForearm", "RightHand",
				"LeftLeg", "LeftShin", "LeftFoot",
				"RightLeg", "RightShin", "RightFoot"
			}) do
				lines[name].Visible = false
			end
		end
	end)

	table.insert(ESPConnections, conn)
end

-- AI NPC 支援
local function trackAIModel(ai)
	if TrackedPlayers[ai] then return end
	task.spawn(function()
		for _ = 1, 20 do
			if ai:FindFirstChild("Humanoid") and ai:FindFirstChild("HumanoidRootPart") then
				trackPlayer({ Name = ai.Name, Character = ai, IsAI = true }, true)
				return
			end
			task.wait(0.1)
		end
	end)
end

-- Public
function ESPModule:Enable()
	clearAllESP()

	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			trackPlayer(p, false)
		end
	end

	Players.PlayerAdded:Connect(function(p)
		p.CharacterAdded:Connect(function()
			task.wait(0.5)
			trackPlayer(p, false)
		end)
	end)

	if self.AllVars.espbots then
		for _, zone in pairs(workspace:WaitForChild("AiZones"):GetChildren()) do
			for _, ai in pairs(zone:GetChildren()) do
				trackAIModel(ai)
			end
			zone.ChildAdded:Connect(trackAIModel)
		end
		workspace.AiZones.ChildAdded:Connect(function(newZone)
			if newZone:IsA("Folder") then
				newZone.ChildAdded:Connect(trackAIModel)
			end
		end)
	end
end

function ESPModule:Disable()
	clearAllESP()
end

function ESPModule:SetAllVars(vars)
	self.AllVars = vars
end

function ESPModule:SetBoxColor(color)
	self.BoxColor = color
end

function ESPModule:SetSkeletonColor(color)
	self.SkeletonColor = color
end

return ESPModule
