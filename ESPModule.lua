local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local ESPModule = {}

-- 初始化
local camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local DrawingESP = {}
local ESPConnections = {}
local TrackedPlayers = {}

ESPModule.AllVars = {
	espbool = false,
	box = false,
	skeleton = false,
	health = false,
	espbots = false
}

ESPModule.BoxColor = Color3.fromRGB(0, 255, 100)
ESPModule.SkeletonColor = Color3.fromRGB(0, 255, 255)

-- 工具
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

	local char
	if typeof(plr) == "table" and plr.IsAI then
		isAI = true
		char = plr.Character
	else
		char = plr.Character
	end

	if not (char and char:IsA("Model")) then return end

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
		local hum = char:FindFirstChildOfClass("Humanoid")
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not (hum and hrp and hum.Health > 0) then
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

		local head = parts.Head
		local foot = parts.RightFoot or parts.LeftFoot or parts.LowerTorso or hrp
		if head and foot then
			local headV2, headVisible = getV2(head)
			local footV2, footVisible = getV2(foot)
			if headVisible and footVisible then
				local topY = math.min(headV2.Y, footV2.Y)
				local botY = math.max(headV2.Y, footV2.Y)
				local height = botY - topY
				local width = height / 1.6
				local cx = (headV2.X + footV2.X) / 2
				local cy = (topY + botY) / 2

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
			end
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
	if not ai:IsA("Model") then return end

	task.spawn(function()
		for i = 1, 30 do
			local hum = ai:FindFirstChildOfClass("Humanoid")
			local hrp = ai:FindFirstChild("HumanoidRootPart")
			if hum and hrp then
				print("[ESP] AI Loaded:", ai.Name)
				trackPlayer({
					Name = ai.Name,
					Character = ai,
					IsAI = true
				}, true)
				return
			end
			task.wait(0.2)
		end
		warn("[ESP] 無法追蹤 AI: ", ai.Name)
	end)
end

function ESPModule:Enable()
	clearAllESP()

	-- 玩家追蹤初始化
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			trackPlayer(p, false)
		end
	end

	-- 新增玩家追蹤
	Players.PlayerAdded:Connect(function(p)
		p.CharacterAdded:Connect(function()
			task.wait(0.5)
			trackPlayer(p, false)
		end)
	end)

	-- AI/NPC 初始化 + 持續監聽
	if self.AllVars.espbots then
		local aiZones = Workspace:FindFirstChild("AiZones")
		if aiZones then
			-- 初始化所有 AI 區域裡的 NPC
			for _, zone in pairs(aiZones:GetChildren()) do
				for _, ai in pairs(zone:GetChildren()) do
					trackAIModel(ai)
				end
				zone.ChildAdded:Connect(trackAIModel)
			end

			-- 新增 AI 區域的處理
			aiZones.ChildAdded:Connect(function(newZone)
				if newZone:IsA("Folder") then
					newZone.ChildAdded:Connect(trackAIModel)
				end
			end)
		else
			warn("[ESPModule] Workspace 中找不到 'AiZones'，請確認資料夾名稱正確。")
		end
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
