-- PlayerESP.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

local PlayerESP = {}
local Toggles = nil
local ESPEnabled = false
local ESPObjects = {}
local Connections = {}

-- 建立 ESP UI
local function createESP(player, character)
	if not character then return end
	local head = character:FindFirstChild("Head")
	local humanoid = character:FindFirstChild("Humanoid")
	if not head or not humanoid then return end

	if head:FindFirstChild("ESP") then
		head.ESP:Destroy()
	end

	local esp = Instance.new("BillboardGui")
	esp.Name = "ESP"
	esp.AlwaysOnTop = true
	esp.Size = UDim2.new(0, 180, 0, 50)
	esp.StudsOffset = Vector3.new(0, 3, 0)
	esp.Adornee = head
	esp.Parent = head

	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	bg.BackgroundTransparency = 0.4
	bg.BorderSizePixel = 0
	bg.Parent = esp

	local uicorner = Instance.new("UICorner", bg)
	uicorner.CornerRadius = UDim.new(0, 6)

	local avatar = Instance.new("ImageLabel")
	avatar.Size = UDim2.new(0, 38, 0, 38)
	avatar.Position = UDim2.new(0, 6, 0.5, -19)
	avatar.BackgroundTransparency = 1
	avatar.Image = "rbxassetid://0"
	avatar.ClipsDescendants = true
	avatar.Parent = bg

	local corner = Instance.new("UICorner", avatar)
	corner.CornerRadius = UDim.new(1, 0)

	task.spawn(function()
		local thumb = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
		if avatar then avatar.Image = thumb end
	end)

	local name = Instance.new("TextLabel")
	name.Text = player.DisplayName or player.Name
	name.Size = UDim2.new(0, 120, 0, 20)
	name.Position = UDim2.new(0, 50, 0, 6)
	name.TextColor3 = Color3.fromRGB(255, 255, 255)
	name.TextStrokeTransparency = 0.6
	name.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	name.BackgroundTransparency = 1
	name.TextXAlignment = Enum.TextXAlignment.Left
	name.Font = Enum.Font.GothamBold
	name.TextSize = 16
	name.Parent = bg

	local hpBG = Instance.new("Frame")
	hpBG.Position = UDim2.new(0, 50, 0, 28)
	hpBG.Size = UDim2.new(0, 120, 0, 8)
	hpBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	hpBG.BorderSizePixel = 0
	hpBG.Parent = bg

	local hpCorner = Instance.new("UICorner", hpBG)
	hpCorner.CornerRadius = UDim.new(0, 4)

	local hpBar = Instance.new("Frame")
	hpBar.Name = "HP"
	hpBar.Size = UDim2.new(1, 0, 1, 0)
	hpBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	hpBar.BorderSizePixel = 0
	hpBar.Parent = hpBG

	local hpBarCorner = Instance.new("UICorner", hpBar)
	hpBarCorner.CornerRadius = UDim.new(0, 4)

	local updateConn = RunService.RenderStepped:Connect(function()
		if humanoid and humanoid.Health > 0 then
			local ratio = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
			hpBar.Size = UDim2.new(ratio, 0, 1, 0)

			if ratio > 0.5 then
				hpBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
			elseif ratio > 0.25 then
				hpBar.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
			else
				hpBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			end
		end
	end)

	ESPObjects[player] = {
		gui = esp,
		connection = updateConn,
	}
end

-- 為玩家建立 ESP 並監聽角色變化
local function hookPlayer(player)
	if player == localPlayer then return end

	if player.Character then
		createESP(player, player.Character)
	end

	local con = player.CharacterAdded:Connect(function(char)
		if ESPEnabled then
			task.wait(1)
			createESP(player, char)
		end
	end)
	table.insert(Connections, con)
end

-- 移除所有 ESP
local function clearAllESP()
	for player, data in pairs(ESPObjects) do
		if data.gui then data.gui:Destroy() end
		if data.connection then data.connection:Disconnect() end
	end
	ESPObjects = {}
end

-- 初始化模組
function PlayerESP:Init(externalToggles)
	if self._connected then return end
	self._connected = true
	Toggles = externalToggles

	-- 玩家加入事件
	local con = Players.PlayerAdded:Connect(function(player)
		if ESPEnabled then
			hookPlayer(player)
		end
	end)
	table.insert(Connections, con)

	-- 監聽開關
	RunService.RenderStepped:Connect(function()
		if Toggles and Toggles.PlayerESPEnabled then
			local state = Toggles.PlayerESPEnabled.Value
			if state ~= ESPEnabled then
				ESPEnabled = state

				if ESPEnabled then
					for _, player in ipairs(Players:GetPlayers()) do
						hookPlayer(player)
					end
				else
					clearAllESP()
				end
			end
		end
	end)
end

return PlayerESP
