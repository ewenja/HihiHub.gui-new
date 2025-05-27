-- ESPModule.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local ESPModule = {}

-- 設定初始參數
local camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local DrawingESP = {}
local ESPConnections = {}
local TrackedPlayers = {}

-- 可由外部設置
ESPModule.AllVars = {
	espbool = false,
	box = false,
	skeleton = false,
	health = false,
	espbots = false
}

ESPModule.BoxColor = Color3.fromRGB(0, 255, 100)
ESPModule.SkeletonColor = Color3.fromRGB(0, 255, 255)

-- 建立繪圖元件
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

-- 清除所有 ESP
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

-- 主追蹤邏輯
local function trackPlayer(plr, isAI)
	if TrackedPlayers[plr] then return end
	TrackedPlayers[plr] = true

	local char = isAI and plr.Character or plr.Character
	local lines = {
		Box = NewBox(),
		HealthBack = NewLine(Color3.new(0, 0, 0)),
		HealthBar = NewLine(Color3.fromRGB(0, 255, 0)),

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

	local renderConn
	renderConn = RunService.RenderStepped:Connect(function()
		char = isAI and plr.Character or plr.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local hrp = char and char:FindFirstChild("HumanoidRootPart")

		if not (char and hum and hrp and hum.Health > 0) then
			for _, l in pairs(lines) do l.Visible = false end
			return
		end

		local screenPos = camera:WorldToViewportPoint(hrp.Position)
		if screenPos.Z <= 0 then
			for _, l in pairs(lines) do l.Visible = false end
			return
		end

		local function getV2(part)
			local pos, onscreen = camera:WorldToViewportPoint(part.Position)
			return Vector2.new(pos.X, pos.Y), onscreen
		end

		local parts = {
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
			RightFoot = char:FindFirstChild("RightFoot")
		}

-- 自動化 Box 尺寸（更精確範圍：Head → HumanoidRootPart 下緣）
local headV2, headVisible = getV2(parts.Head or hrp)
local rootV2, rootVisible = getV2(hrp)

if headVisible and rootVisible then
	local distance = (camera.CFrame.Position - hrp.Position).Magnitude
	local scale = 1 / (distance * 0.07) -- 距離縮放因子（可調整）

	local height = 230 * scale -- 調整這個數值可以讓 box 剛好包住整個角色
	local width = height / 1.6
	local cx = rootV2.X
	local cy = (headV2.Y + rootV2.Y) / 2

	-- Box
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
		local ratio = hum.Health / hum.MaxHealth
		local left = cx - width / 2 - 5
		lines.HealthBack.Visible = true
		lines.HealthBack.From = Vector2.new(left, cy + height / 2)
		lines.HealthBack.To = Vector2.new(left, cy - height / 2)

		lines.HealthBar.Visible = true
		lines.HealthBar.From = Vector2.new(left, cy + height / 2)
		lines.HealthBar.To = Vector2.new(left, cy + height / 2 - height * ratio)
		lines.HealthBar.Color = Color3.fromRGB(255 * (1 - ratio), 255 * ratio, 0)
	else
		lines.HealthBack.Visible = false
		lines.HealthBar.Visible = false
	end
else
	lines.Box.Visible = false
	lines.HealthBack.Visible = false
	lines.HealthBar.Visible = false
end

		-- Skeleton
		local function link(from, to, line)
			if from and to then
				local a, ok1 = getV2(from)
				local b, ok2 = getV2(to)
				if ok1 and ok2 then
					line.Visible = true
					line.From = a
					line.To = b
					line.Color = ESPModule.SkeletonColor
					return
				end
			end
			line.Visible = false
		end

		if ESPModule.AllVars.skeleton then
			link(parts.Head, parts.UpperTorso, lines.SpineTop)
			link(parts.UpperTorso, parts.LowerTorso, lines.SpineMid)
			link(parts.UpperTorso, parts.LeftUpperArm, lines.LeftArm)
			link(parts.LeftUpperArm, parts.LeftLowerArm, lines.LeftForearm)
			link(parts.LeftLowerArm, parts.LeftHand, lines.LeftHand)
			link(parts.UpperTorso, parts.RightUpperArm, lines.RightArm)
			link(parts.RightUpperArm, parts.RightLowerArm, lines.RightForearm)
			link(parts.RightLowerArm, parts.RightHand, lines.RightHand)
			link(parts.LowerTorso, parts.LeftUpperLeg, lines.LeftLeg)
			link(parts.LeftUpperLeg, parts.LeftLowerLeg, lines.LeftShin)
			link(parts.LeftLowerLeg, parts.LeftFoot, lines.LeftFoot)
			link(parts.LowerTorso, parts.RightUpperLeg, lines.RightLeg)
			link(parts.RightUpperLeg, parts.RightLowerLeg, lines.RightShin)
			link(parts.RightLowerLeg, parts.RightFoot, lines.RightFoot)
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

	table.insert(ESPConnections, renderConn)
end

-- AI 模型追蹤
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

-- 啟用 ESP
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
		for _, zone in pairs(Workspace:WaitForChild("AiZones"):GetChildren()) do
			for _, ai in pairs(zone:GetChildren()) do
				trackAIModel(ai)
			end
			zone.ChildAdded:Connect(trackAIModel)
		end
		Workspace.AiZones.ChildAdded:Connect(function(newZone)
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
