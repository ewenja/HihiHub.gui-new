-- PlayerESP.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local PlayerESP = {}
local ESPEnabled = false
local Connections = {}
local Toggles = nil

local function createESP(player, char)
	local head = char:FindFirstChild("Head")
	if not head or head:FindFirstChild("ESP") then return end

	local gui = Instance.new("BillboardGui")
	gui.Name = "ESP"
	gui.AlwaysOnTop = true
	gui.Size = UDim2.new(0, 200, 0, 50)
	gui.StudsOffset = Vector3.new(0, 3, 0)
	gui.Adornee = head
	gui.Parent = head

	local bg = Instance.new("Frame", gui)
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	bg.BackgroundTransparency = 0.3
	bg.BorderSizePixel = 0

	local name = Instance.new("TextLabel", bg)
	name.Size = UDim2.new(1, 0, 1, 0)
	name.Position = UDim2.new(0, 0, 0, 0)
	name.Text = player.Name
	name.TextColor3 = Color3.fromRGB(255, 255, 255)
	name.BackgroundTransparency = 1
	name.TextScaled = true
	name.Font = Enum.Font.GothamBold
end

local function hookPlayer(player)
	if player == localPlayer then return end

	if player.Character then
		createESP(player, player.Character)
	end

	local charCon = player.CharacterAdded:Connect(function(char)
		task.wait(1)
		if ESPEnabled then
			createESP(player, char)
		end
	end)

	table.insert(Connections, charCon)
end

function PlayerESP:Init(externalToggles)
	if self._connected then return end
	self._connected = true
	Toggles = externalToggles

	for _, player in ipairs(Players:GetPlayers()) do
		hookPlayer(player)
	end

	local con = Players.PlayerAdded:Connect(function(player)
		hookPlayer(player)
	end)
	table.insert(Connections, con)

	RunService.RenderStepped:Connect(function()
		if Toggles and Toggles.PlayerESPEnabled then
			local state = Toggles.PlayerESPEnabled.Value
			if state ~= ESPEnabled then
				ESPEnabled = state

				if not ESPEnabled then
					for _, player in pairs(Players:GetPlayers()) do
						if player ~= localPlayer and player.Character then
							local head = player.Character:FindFirstChild("Head")
							if head and head:FindFirstChild("ESP") then
								head.ESP:Destroy()
							end
						end
					end
				else
					for _, player in pairs(Players:GetPlayers()) do
						if player ~= localPlayer and player.Character then
							createESP(player, player.Character)
						end
					end
				end
			end
		end
	end)
end

return PlayerESP
