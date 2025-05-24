-- SpiderManModule.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local SpiderMan = {}
local Toggles = nil
local UI = {}

-- 參數
local CLIMB_SPEED = 10
local MAX_TIME = 1

local LocalPlayer = Players.LocalPlayer

-- UI 初始化
function UI:Init()
    local gui = Instance.new("ScreenGui")
    gui.Name = "SpiderManUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = game:FindFirstChild("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local bar = Instance.new("Frame", gui)
    bar.AnchorPoint = Vector2.new(0.5, 0)
    bar.Position = UDim2.new(0.5, 0, 0.5, 270)
    bar.Size = UDim2.new(0, 200, 0, 10)
    bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    bar.Visible = false

    local fill = Instance.new("Frame", bar)
    fill.BackgroundColor3 = Color3.fromRGB(20, 230, 20)
    fill.Size = UDim2.new(1, 0, 1, 0)

    self.Gui = gui
    self.Bar = bar
    self.Fill = fill
end

-- 主邏輯
function SpiderMan:Start()
    UI:Init()

    local flyStartTime = nil

    RunService.Heartbeat:Connect(function()
        if not Toggles or not Toggles.SpiderMan or not Toggles.SpiderMan.Value then
            UI.Bar.Visible = false
            return
        end

        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("LeftFoot") or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Humanoid") then
            return
        end

        local root = character.HumanoidRootPart
        local foot = character.LeftFoot
        local humanoid = character.Humanoid

        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {character}
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist

        local ray = Workspace:Raycast(foot.Position, root.CFrame.LookVector * 2.5, rayParams)

        if ray then
            if not flyStartTime then
                flyStartTime = tick()
            end

            local elapsed = tick() - flyStartTime
            if elapsed >= MAX_TIME then
                flyStartTime = nil
                UI.Bar.Visible = false
                return
            end

            -- UI 更新
            UI.Bar.Visible = true
            local progress = 1 - (elapsed / MAX_TIME)
            UI.Fill.Size = UDim2.new(progress, 0, 1, 0)
            UI.Fill.BackgroundColor3 = Color3.fromRGB(230, 20, 20):Lerp(Color3.fromRGB(20, 230, 20), progress)

            root.Velocity = Vector3.new(root.Velocity.X, CLIMB_SPEED, root.Velocity.Z)

            if humanoid:GetState() ~= Enum.HumanoidStateType.Climbing then
                humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
            end
        else
            flyStartTime = nil
            UI.Bar.Visible = false
        end
    end)
end

function SpiderMan:Init(injectedToggles)
    Toggles = injectedToggles
    self:Start()
end

return SpiderMan
