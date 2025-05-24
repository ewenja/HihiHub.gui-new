-- EquippedESP.lua（模組）
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local EquippedESP = {}
local Toggles = nil -- 將由 Init 注入

-- 參數
local ESPSize = 50
local ESPColor = Color3.fromRGB(255, 255, 255)

-- 圖示映射
local ItemIconMap = {}
local ItemList = ReplicatedStorage:WaitForChild("ItemsList")
for _, item in ipairs(ItemList:GetChildren()) do
	local props = item:FindFirstChild("ItemProperties")
	local icon = props and props:FindFirstChild("ItemIcon")
	if icon and icon:IsA("ImageLabel") then
		ItemIconMap[item.Name] = icon.Image
	end
end

-- 過濾玩家穿著的衣物（不顯示）
local function GetClothingNames(player)
	local clothingNames = {}
	local playerData = ReplicatedStorage:FindFirstChild("Players")
	if not playerData then return clothingNames end

	local profile = playerData:FindFirstChild(player.Name)
	if not profile then return clothingNames end

	local clothing = profile:FindFirstChild("Clothing")
	if clothing then
		for _, item in pairs(clothing:GetChildren()) do
			clothingNames[item.Name] = true
		end
	end
	return clothingNames
end

-- 建立 ESP GUI
local function createESP(character, itemName)
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end
	if character:FindFirstChild("ItemESP") then
		character.ItemESP:Destroy()
	end

	local imageId = ItemIconMap[itemName]
	if not imageId then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ItemESP"
	billboard.Size = UDim2.new(0, ESPSize, 0, ESPSize)
	billboard.StudsOffset = Vector3.new(0, -5, 0)
	billboard.AlwaysOnTop = true
	billboard.Adornee = rootPart

	local image = Instance.new("ImageLabel")
	image.Size = UDim2.new(1, 0, 1, 0)
	image.BackgroundTransparency = 1
	image.Image = imageId
	image.ImageColor3 = ESPColor
	image.Parent = billboard

	billboard.Parent = character
end

local function removeESP(character)
	local esp = character:FindFirstChild("ItemESP")
	if esp then esp:Destroy() end
end

-- 頻率限制
local lastUpdate = {}
local function canUpdate(player)
	local now = tick()
	if not lastUpdate[player] or now - lastUpdate[player] > 1 then
		lastUpdate[player] = now
		return true
	end
	return false
end

-- 主邏輯
local function updateESPForCharacter(character, player)
	if not Toggles or not Toggles.EquippedESP or not Toggles.EquippedESP.Value then
		removeESP(character)
		return
	end

	if not canUpdate(player) then return end
	local clothingList = GetClothingNames(player)

	for _, child in ipairs(character:GetChildren()) do
		if ItemIconMap[child.Name]
			and not clothingList[child.Name]
			and not string.find(child.Name, "Wasteland") then
			createESP(character, child.Name)
			return
		end
	end

	removeESP(character)
end

local function monitorPlayer(player)
	player.CharacterAdded:Connect(function(character)
		task.wait(1)
		updateESPForCharacter(character, player)

		character.ChildAdded:Connect(function()
			updateESPForCharacter(character, player)
		end)

		character.ChildRemoved:Connect(function()
			updateESPForCharacter(character, player)
		end)
	end)

	if player.Character then
		updateESPForCharacter(player.Character, player)
	end
end

-- 初始化：注入 UI Toggle
function EquippedESP:Init(injectedToggles)
	Toggles = injectedToggles

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			monitorPlayer(player)
		end
	end

	Players.PlayerAdded:Connect(function(player)
		if player ~= LocalPlayer then
			monitorPlayer(player)
		end
	end)

RunService.Stepped:Connect(function()
	if not Toggles or not Toggles.EquippedESP then return end

	if not Toggles.EquippedESP.Value then
		-- ✅ 清除所有玩家的 ESP（當關閉開關時）
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character then
				removeESP(player.Character)
			end
		end
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			updateESPForCharacter(player.Character, player)
		end
	end
end)

return EquippedESP
