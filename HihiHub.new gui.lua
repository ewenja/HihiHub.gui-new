repeat
    task.wait()
 until game:IsLoaded()
 
 if not isfile("HihiHub") then
    makefolder("HihiHub")
 end
 
 ---// Variables
 local RunService = game:GetService("RunService")
 local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
 local InputService = game:GetService("UserInputService")
 local TweenService = game:GetService("TweenService")
 
 --// LPH
 if not LPH_OBFUSCATED then
    LPH_JIT = function(...) return ... end
    LPH_JIT_MAX = function(...) return ... end
    LPH_JIT_ULTRA = function(...) return ... end
    LPH_NO_VIRTUALIZE = function(...) return ... end
    LPH_NO_UPVALUES = function(f) return(function(...) return f(...) end) end
    LPH_ENCSTR = function(...) return ... end
    LPH_STRENC = function(...) return ... end
    LPH_HOOK_FIX = function(...) return ... end
    LPH_CRASH = function() return print(debug.traceback()) end
 end
 
 -- Menu/UI Creation
 local menu = game:GetObjects("rbxassetid://17090554797")[1] 
 local tabholder = menu.bg.bg.bg.bg.bg.bg.main.group
 local tabviewer = menu.bg.bg.bg.bg.bg.bg.tabbuttons
 
 local library = {
    Title = 'anti.font color="rgb(245, 66, 230)">solutions</font> | <font color="rgb(245, 66, 230)">Pre-Build</font>',
    Build = 'build: <font color="rgb(245, 66, 230)"> Unknown </font>',
    AnimatedText = false,
    keybind = Enum.KeyCode.End,
    Colors = {
        libColor = Color3.new(0.952941, 0.356863, 0.874510),
        riskyColor = Color3.fromRGB(255, 0, 0),
        FontColor = Color3.fromRGB(255, 255, 255),
        MainColor = Color3.fromRGB(14, 14, 14),
        AccentColor = Color3.new(0.952941, 0.356863, 0.874510),
        OutlineColor = Color3.fromRGB(15, 15, 15),
    },
    Enabled = true,
    colorpicking = false,
    scrolling = true,
    multiZindex = 200,
    blacklisted = {
 Enum.KeyCode.W,
 Enum.KeyCode.A,
 Enum.KeyCode.S,
 Enum.KeyCode.D,
 Enum.UserInputType.MouseMovement
    },
    tabbuttons = {},
    tabs = {},
    options = {},
    flags = {},
    toInvis = {},
    Registry = {},
    RegistryMap = {},
    HudRegistry = {}
 }
 
 local keynames = {
    [Enum.KeyCode.LeftAlt] = 'LALT',
    [Enum.KeyCode.RightAlt] = 'RALT',
    [Enum.KeyCode.LeftControl] = 'LCTRL',
    [Enum.KeyCode.RightControl] = 'RCTRL',
    [Enum.KeyCode.LeftShift] = 'LSHIFT',
    [Enum.KeyCode.RightShift] = 'RSHIFT',
    [Enum.KeyCode.Underscore] = '_',
    [Enum.KeyCode.Minus] = '-',
    [Enum.KeyCode.Plus] = '+',
    [Enum.KeyCode.Period] = '.',
    [Enum.KeyCode.Slash] = '/',
    [Enum.KeyCode.BackSlash] = '\\',
    [Enum.KeyCode.Question] = '?',
    [Enum.UserInputType.MouseButton1] = '[MB1]',
    [Enum.UserInputType.MouseButton2] = '[MB2]',
    [Enum.UserInputType.MouseButton3] = '[MB3]'
 }
 local ProtectGui = protectgui or (syn and syn.protect_gui) or (function() end)
 local ScreenGui = Instance.new('ScreenGui')
 ProtectGui(ScreenGui)
 ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
 ScreenGui.Parent = game.CoreGui
 ScreenGui.Name = "huh_menu"
 menu.bg.pre.Text = ""


 task.spawn(function()
    local textList = {
        -- Bozos
        'G', 'Ga', 'Gay',
        'Ga', 'G',
        -- Ak 47
        'A', 'Ak', 'Ak-', 'Ak-4', 'Ak-47',
        'Ak-4', 'Ak-', 'Ak', 'A',
        -- Credits
        'M', 'Ma', 'Mad', 'Made', 'Made B', 'Made By', 'Made By:', 'Made By: l', 'Made By: lk', 'Made By: lks',
        'Made By: lksi', 'Made By: lksiw', 'Made By: lksiwj', 'Made By: lksiwja', 'Made by: lksiwjas', 'Made By: lksiwjas.',
        'Made By: lksiwjas', 'Made By: lksiwja', 'Made By: lksiwj', 'Made By: lksiw', 'Made By: lksi', 'Made By: lks', 'Made By: lk',
        'Made By: l', 'Made By:', 'Made By', 'Made B', 'Made', 'Mad', 'Ma', 'M'
    }
    while wait(0.2) do
        for _, obj in pairs(menu:GetDescendants()) do
            if obj.Name:lower():find('buildlabel') then
                obj.Text = library.Build
            end
         end
        if library.AnimatedText then
            for i = 1, #textList do
                menu.bg.pre.Text = textList[i]
                wait(0.2)
            end 
        else
            menu.bg.pre.Text = library.Title
        end
    end
 end) 
 
 if menu and menu:FindFirstChild("bg") and menu.bg.Size then
     menu.bg.Position = UDim2.new(0.5, -menu.bg.Size.X.Offset / 2, 0.5, -menu.bg.Size.Y.Offset / 2)
 end
 menu.Parent = game:GetService("CoreGui")
 
 LPH_NO_VIRTUALIZE(function()
 function library:AddToRegistry(Instance, Properties, IsHud)
    local Idx = #library.Registry + 3
    local Data = {Instance = Instance;Properties = Properties;Idx = Idx}
    table.insert(library.Registry, Data);
    library.RegistryMap[Instance] = Data;
    if IsHud then table.insert(library.HudRegistry, Data) end;
    end;
    function library:CreateLabel(Properties, IsHud)
 local _Instance = library:Create('TextLabel', {BackgroundTransparency = 1;Font = Enum.Font.Code;TextColor3 = library.Colors.FontColor;TextSize = 16;TextStrokeTransparency = 0});
 library:AddToRegistry(_Instance, {TextColor3 = 'FontColor'}, IsHud);
 return library:Create(_Instance, Properties);
 end;
 function library:GetTextBounds(Text, Font, Size, Resolution)
    local Bounds = game:GetService('TextService'):GetTextSize(Text, Size, Font, Resolution or Vector2.new(1920, 1080))
    return Bounds.X, Bounds.Y
    end;
    function library:Create(Class, Properties)
 if library.Enabled == false then return end;
 local _Instance = Class;
 if type(Class) == 'string' then _Instance = Instance.new(Class); end;
 for Property, Value in next, Properties do _Instance[Property] = Value; end;
 return _Instance;
 end;
 library.NotificationArea = library:Create('Frame', {BackgroundTransparency = 1;Position = UDim2.new(0.003, 0, 0, 40);Size = UDim2.new(0, 300, 0, 200);ZIndex = 100;Parent = ScreenGui});
 library:Create('UIListLayout', {Padding = UDim.new(0, 4);FillDirection = Enum.FillDirection.Vertical;SortOrder = Enum.SortOrder.LayoutOrder;Parent = library.NotificationArea});
 function library:Notify(Text, Time)
    local XSize, YSize = library:GetTextBounds(Text, Enum.Font.Code, 14);YSize = YSize + 7
    local NotifyOuter = library:Create('Frame', {BorderColor3 = Color3.new(189, 172, 255);Position = UDim2.new(0, 100, 0, 10);Size = UDim2.new(0, 0, 0, YSize);ClipsDescendants = true;Transparency = 0,ZIndex = 100;Parent = library.NotificationArea});
    library:Create('UIGradient', {Color = ColorSequence.new{ColorSequenceKeypoint.new(0, library.Colors.MainColor), ColorSequenceKeypoint.new(0.1, library.Colors.MainColor), ColorSequenceKeypoint.new(0.6, library.Colors.MainColor), ColorSequenceKeypoint.new(1, library.Colors.MainColor)},Rotation = -120;Parent = NotifyOuter});
    local NotifyInner = library:Create('Frame', {BackgroundColor3 = library.Colors.MainColor;BorderColor3 = library.Colors.OutlineColor;BorderMode = Enum.BorderMode.Inset;Size = UDim2.new(1, 0, 1, 0);ZIndex = 101;Parent = NotifyOuter});
    local InnerFrame = library:Create('Frame', {BackgroundColor3 = Color3.new(1, 1, 1);BorderSizePixel = 0;Position = UDim2.new(0, 1, 0, 1);Size = UDim2.new(1, -2, 1, -2);ZIndex = 102;Parent = NotifyInner;});
    local Line = library:Create('Frame', {BackgroundColor3 = library.Colors.AccentColor;BorderSizePixel = 0;Position = UDim2.new(1, 0, 0.97, 0);Size = UDim2.new(-0.999, -0.5, 0, 1.9);ZIndex = 102;Parent = NotifyInner;});
    local LeftColor = library:Create('Frame', {BackgroundColor3 = library.Colors.AccentColor;BorderSizePixel = 0;Position = UDim2.new(0, -1, 0, 22);Size = UDim2.new(0, 2, -1.2, 0);ZIndex = 104;Parent = NotifyOuter;});
    local Gradient = library:Create('UIGradient', {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, library.Colors.MainColor),ColorSequenceKeypoint.new(1, library.Colors.MainColor)});Rotation = -90;Parent = InnerFrame});
    library:AddToRegistry(NotifyInner, {BackgroundColor3 = 'MainColor';BorderColor3 = 'OutlineColor';}, true);
    library:AddToRegistry(Gradient, {Color = function() return ColorSequence.new({ColorSequenceKeypoint.new(0, library.Colors.MainColor),ColorSequenceKeypoint.new(1, library.Colors.MainColor)}); end});
    library:CreateLabel({Position = UDim2.new(0, 6, 0, 0);Size = UDim2.new(1, -4, 1, 0);Text = Text;TextXAlignment = Enum.TextXAlignment.Left;TextSize = 14;ZIndex = 103;Parent = InnerFrame});
    pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, XSize + 8 + 4, 0, YSize), 'Out', 'Quad', 0.6, true);
    pcall(LeftColor.TweenSize, LeftColor, UDim2.new(0, 2, 0, 0), 'Out', 'Linear', 1, true);
    wait(0.9)
    pcall(Line.TweenSize, Line, UDim2.new(0, 0, 0, 2), 'Out', 'Linear', Time, true);
    task.spawn(function()
    wait(Time or 5);
    pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, 0, 0, YSize), 'Out', 'Quad', 0.4, true);
    wait(0.4);
    NotifyOuter:Destroy();
    end);
    end;
 
    function draggable(a)local b=game:GetService("UserInputService")local c;local d;local e;local f;local g=0.25;local h=TweenInfo.new(g,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)local function i(j)if not library.colorpicking then local k=j.Position-e;local l=UDim2.new(f.X.Scale,f.X.Offset+k.X,f.Y.Scale,f.Y.Offset+k.Y)local m=TweenService:Create(a,h,{Position=l})m:Play()end end;a.InputBegan:Connect(function(j)if j.UserInputType==Enum.UserInputType.MouseButton1 or j.UserInputType==Enum.UserInputType.Touch then c=true;e=j.Position;f=a.Position;j.Changed:Connect(function()if j.UserInputState==Enum.UserInputState.End then c=false end end)end end)a.InputChanged:Connect(function(j)if j.UserInputType==Enum.UserInputType.MouseMovement or j.UserInputType==Enum.UserInputType.Touch then d=j end end)b.InputChanged:Connect(function(j)if j==d and c then i(j)end end)end draggable(menu.bg)
 InputService.MouseIconEnabled = false
 local Cursor = Drawing.new('Triangle');Cursor.Thickness = 1;Cursor.Filled = true;Cursor.Visible = true;Cursor.ZIndex = math.huge;local CursorOutline = Drawing.new('Triangle');CursorOutline.Thickness = 1;CursorOutline.Filled = false;CursorOutline.Color = Color3.new(255, 255, 255);CursorOutline.Visible = true;CursorOutline.ZIndex = math.huge
 function cursorupdate()
    local mPos = InputService:GetMouseLocation();
    Cursor.Color = library.Colors.libColor;Cursor.PointA = Vector2.new(mPos.X, mPos.Y);Cursor.PointB = Vector2.new(mPos.X + 16, mPos.Y + 6);Cursor.PointC = Vector2.new(mPos.X + 6, mPos.Y + 16) CursorOutline.PointA = Cursor.PointA;CursorOutline.PointB = Cursor.PointB;CursorOutline.PointC = Cursor.PointC;RunService.RenderStepped:Wait() end task.spawn(function() while true do cursorupdate() end
end)
 
    InputService.InputEnded:Connect(function(key)
    if key.KeyCode == library.keybind then menu.Enabled = not menu.Enabled;library.scrolling = false;library.colorpicking = false;Cursor.Visible = not Cursor.Visible;InputService.MouseIconEnabled = not InputService.MouseIconEnabled;CursorOutline.Visible = not CursorOutline.Visible; for i,v in next, library.toInvis do v.Visible = false end end
    end)
 
    function library:Tween(...) TweenService:Create(...):Play() end
 function library:addTab(name,image)
local newTab = tabholder.tab:Clone()
local newButton = tabviewer.button:Clone()
 
table.insert(library.tabs,newTab)
newTab.Parent = tabholder
newTab.Visible = false
 
table.insert(library.tabbuttons,newButton)
newButton.Parent = tabviewer
newButton.Modal = true
newButton.Visible = true
newButton.Image = image
newButton.text.Text = name
newButton.MouseButton1Click:Connect(function()
for i,v in next, library.tabs do v.Visible = v == newTab end
for i,v in next, library.toInvis do v.Visible = false end
for i,v in next, library.tabbuttons do
   local state = v == newButton
   local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
   local imageTweenStart = TweenService:Create(v, tweenInfo, {ImageColor3 = Color3.fromRGB(245, 66, 230)})
   local textTweenStart = TweenService:Create(v.text, tweenInfo, {TextColor3 = Color3.fromRGB(245, 66, 230)})
   local imageTweenEnd = TweenService:Create(v, tweenInfo, {ImageColor3 = Color3.fromRGB(0,0,0)})
   local textTweenEnd = TweenService:Create(v.text, tweenInfo, {TextColor3 = Color3.fromRGB(125, 125, 125)})
   if state then
imageTweenStart:Play()
textTweenStart:Play()
   else
imageTweenEnd:Play()
textTweenEnd:Play()
   end
end
end)
 
local tab = {}
local groupCount = 0
local jigCount = 0
local topStuff = 2000
 
function tab:createGroup(__p, __gName)
    local _a1 = Instance.new("Frame")
    local _a2 = Instance.new("Frame")
    local _a3 = Instance.new("UIListLayout")
    local _a4 = Instance.new("UIPadding")
    local _a5 = Instance.new("Frame")
    local _a6 = Instance.new("TextLabel")

    groupCount -= 1

    _a1.Name = "grp_" .. tostring(math.random(1,99999))
    _a1.Parent = newTab[__p]
    _a1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    _a1.BorderSizePixel = 0
    _a1.Size = UDim2.new(0, 211, 0, 8)
    _a1.ZIndex = groupCount

    _a2.Name = "_grp_in"
    _a2.Parent = _a1
    _a2.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
    _a2.BorderSizePixel = 0
    _a2.Size = UDim2.new(1, 0, 1, 0)

    _a3.Parent = _a2
    _a3.HorizontalAlignment = Enum.HorizontalAlignment.Center
    _a3.SortOrder = Enum.SortOrder.LayoutOrder

    _a4.Parent = _a2
    _a4.PaddingTop = UDim.new(0, 7)
    _a4.PaddingBottom = UDim.new(0, 4)

    _a6.Name = "grp_title"
    _a6.Parent = _a1
    _a6.BackgroundTransparency = 1
    _a6.Position = UDim2.new(0, 17, 0, 0)
    _a6.ZIndex = 2
    _a6.Font = Enum.Font.Code
    _a6.Text = __gName or ""
    _a6.TextColor3 = Color3.fromRGB(255, 255, 255)
    _a6.TextSize = 13
    _a6.TextStrokeTransparency = 0
    _a6.TextXAlignment = Enum.TextXAlignment.Left
   local group = {}
   function group:addToggle(args)
if not args.flag and args.text then args.flag = args.text end
if not args.flag then return warn("⚠️ incorrect arguments ⚠️ - toggle flag missing") end

local __random = {}
function __random._1(v) args.risky = v end
groupbox.Size += UDim2.new(0, 0, 0, 20)

local z1 = Instance.new("Frame")
local z2 = Instance.new("Frame")
local z3 = Instance.new("Frame")
local z4 = Instance.new("Frame")
local z5 = Instance.new("TextLabel")
local z6 = Instance.new("TextButton")

jigCount -= 1
library.multiZindex -= 1

z1.Name = tostring(math.random(1e5, 1e6))
z1.Parent = grouper
z1.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
z1.BackgroundTransparency = 1.000
z1.BorderSizePixel = 0
z1.Size = UDim2.new(1, 0, 0, 20)
z1.ZIndex = library.multiZindex

z2.Name = "b" .. math.random(1, 9)
z2.Parent = z1
z2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
z2.BorderColor3 = Color3.fromRGB(0, 0, 0)
z2.BorderSizePixel = 3
z2.Position = UDim2.new(0.0209, 0, 0.242, 0)
z2.Size = UDim2.new(0, 11, 0, 11)

z3.Name = "c" .. math.random(1, 999)
z3.Parent = z2
z3.BackgroundColor3 = Color3.fromRGB(245, 66, 230)
z3.BorderColor3 = Color3.fromRGB(20, 20, 20)
z3.BorderSizePixel = 2
z3.Size = UDim2.new(0, 12, 0, 12)

z4.Name = "d" .. tostring(math.random())
z4.Parent = z3
z4.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
z4.BorderColor3 = Color3.fromRGB(0, 0, 0)
z4.Size = UDim2.new(0, 12, 0, 12)

local z4grad = Instance.new("UIGradient", z4)
z4grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(75, 75, 75)),
	ColorSequenceKeypoint.new(0.32, Color3.fromRGB(100, 100, 100)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
}
z4grad.Rotation = 45

z5.Name = "t" .. math.random(1000, 9000)
z5.Parent = z1
z5.BackgroundTransparency = 1.0
z5.Position = UDim2.new(0, 22, 0, 0)
z5.Size = UDim2.new(0, 0, 1, 2)
z5.Font = Enum.Font.Code
z5.Text = args.text or args.flag
z5.TextColor3 = Color3.fromRGB(155, 155, 155)
z5.TextSize = 13.0
z5.TextStrokeTransparency = 0.0
z5.TextXAlignment = Enum.TextXAlignment.Left

z6.Name = "btn" .. math.random()
z6.Parent = z1
z6.BackgroundTransparency = 1.000
z6.Size = UDim2.new(0, 101, 1, 0)
z6.Font = Enum.Font.SourceSans
z6.Text = ""
z6.TextSize = 14.0

local _state = args.default or false
if args.risky then z5.TextColor3 = _state and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(139, 0, 0) end
if _state then
	z4.Name = "accent"
	library.flags[args.flag] = _state
	z3.BorderColor3 = Color3.fromRGB(20, 20, 20)
	z4.BackgroundColor3 = library.Colors.libColor
	z5.TextColor3 = args.risky and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(244, 244, 244)
	if args.callback then args.callback(_state) end
else
	z5.TextColor3 = args.risky and Color3.fromRGB(139, 0, 0) or Color3.fromRGB(144, 144, 144)
end

function __random._2(v)
	_state = v
	library.flags[args.flag] = v
	z4.BackgroundColor3 = v and library.Colors.libColor or Color3.fromRGB(25, 25, 25)
	z5.TextColor3 = args.risky and (v and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(139, 0, 0)) or (v and Color3.fromRGB(244, 244, 244) or Color3.fromRGB(144, 144, 144))
	if args.callback then args.callback(v) end
end

z6.MouseButton1Click:Connect(function()
	_state = not _state
	z4.Name = _state and "accent" or "back"
	library.flags[args.flag] = _state
	z3.BorderColor3 = Color3.fromRGB(20, 20, 20)
	z4.BackgroundColor3 = _state and library.Colors.libColor or Color3.fromRGB(25, 25, 25)
	z5.TextColor3 = args.risky and (_state and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(139, 0, 0)) or (_state and Color3.fromRGB(244, 244, 244) or Color3.fromRGB(144, 144, 144))
	if args.callback then args.callback(_state) end
end)

z6.MouseEnter:Connect(function()
	z3.BorderColor3 = library.Colors.libColor
end)

z6.MouseLeave:Connect(function()
	z3.BorderColor3 = Color3.fromRGB(20, 20, 20)
end)

library.flags[args.flag] = false
library.options[args.flag] = {
	type = "toggle",
	changeState = __random._2,
	skipflag = args.skipflag,
	oldargs = args,
	toggle = _state,
	risky = args.risky or false,
	riskcfg = __random._1
}

local toggle = {}
function toggle:addKeybind(args)
if not args.flag then return warn("⚠️ bad args ⚠️ - toggle:keybind") end

local _waitkey, _kb, _btn = false, Instance.new("Frame"), Instance.new("TextButton")

_kb.Parent = toggleframe
_kb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
_kb.BackgroundTransparency = 1
_kb.Position = UDim2.new(0.73, 4, 0.272, 0)
_kb.Size = UDim2.new(0, 51, 0, 10)

_btn.Parent = _kb
_btn.BackgroundTransparency = 1
_btn.Position = UDim2.new(-0.27, 0, 0, 0)
_btn.Size = UDim2.new(1.27, 0, 1, 0)
_btn.Font = Enum.Font.Code
_btn.Text = ""
_btn.TextColor3 = Color3.fromRGB(155, 155, 155)
_btn.TextSize = 13
_btn.TextStrokeTransparency = 0
_btn.TextXAlignment = Enum.TextXAlignment.Right

local _state = false
local function _update(v)
	if library.colorpicking then return end
	library.flags[args.flag] = v
	_btn.Text = (v.Name == "Unknown" or v.Name == "[Unknown]") and "[None]" or (keynames[v] or "["..v.Name.."]")
end

InputService.InputBegan:Connect(function(inp)
	local k = inp.KeyCode == Enum.KeyCode.Unknown and inp.UserInputType or inp.KeyCode
	if _waitkey then
		if not table.find(library.blacklisted, k) then
			_waitkey = false
			library.flags[args.flag] = k
			_btn.Text = (k.Name == "Unknown" or k.Name == "[Unknown]") and "[None]" or (keynames[k] or "["..k.Name.."]")
			_btn.TextColor3 = Color3.fromRGB(155, 155, 155)
		end
	elseif k == library.flags[args.flag] and args.callback then
		_state = not _state
		args.callback(k, _state)
	end
end)

_btn.MouseButton1Click:Connect(function()
	if library.colorpicking then return end
	library.flags[args.flag] = Enum.KeyCode.Unknown
	_btn.Text = "--"
	_btn.TextColor3 = library.Colors.libColor
	_waitkey = true
end)

library.flags[args.flag] = Enum.KeyCode.Unknown
library.options[args.flag] = {
	type = "keybind",
	changeState = _update,
	skipflag = args.skipflag,
	oldargs = args
}

_update(args.key or Enum.KeyCode.Unknown)
end
function toggle:addColorpicker(args)
   if not args.flag and args.text then args.flag = args.text end
if not args.flag then return warn("⚠️ Args Error ⚠️") end

local _cp, _m, _f, _b, _cf, _cf2, _hf, _m1, _hue, _pf, _m2, _pk, _clr, _ccf, _txt = 
	Instance.new("Frame"), Instance.new("Frame"), Instance.new("Frame"), Instance.new("TextButton"),
	Instance.new("Frame"), Instance.new("Frame"), Instance.new("Frame"), Instance.new("Frame"),
	Instance.new("ImageLabel"), Instance.new("Frame"), Instance.new("Frame"), Instance.new("ImageLabel"),
	Instance.new("Frame"), Instance.new("Frame"), Instance.new("TextLabel")

library.multiZindex -= 1; jigCount -= 1; topStuff -= 1

_cp.Parent = toggleframe
_cp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
_cp.BorderColor3 = Color3.fromRGB(0, 0, 0)
_cp.BorderSizePixel = 3
_cp.Position = args.second and UDim2.new(0.72, 4, 0.272, 0) or UDim2.new(0.86, 4, 0.272, 0)
_cp.Size = UDim2.new(0, 20, 0, 10)

_m.Name = "mid"; _m.Parent = _cp
_m.BackgroundColor3 = Color3.fromRGB(245, 66, 230)
_m.BorderColor3 = Color3.fromRGB(25, 25, 25)
_m.BorderSizePixel = 2; _m.Size = UDim2.new(1, 0, 1, 0)

_f.Name = "front"; _f.Parent = _m
_f.BackgroundColor3 = library.Colors.libColor
_f.BorderColor3 = Color3.fromRGB(0, 0, 0)
_f.Size = UDim2.new(1, 0, 1, 0)

local _grad = Instance.new("UIGradient", _f)
_grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(75, 75, 75)),
	ColorSequenceKeypoint.new(0.32, Color3.fromRGB(100, 100, 100)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
}
_grad.Rotation = 270

_b.Name = "trigger"
_b.Parent = _f
_b.BackgroundTransparency = 1
_b.Size = UDim2.new(1, 0, 1, 0)
_b.Font = Enum.Font.SourceSans
_b.Text = ""; _b.TextSize = 14

_cf.Name = "container"
_cf.Parent = toggleframe
_cf.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
_cf.BorderColor3 = Color3.fromRGB(0, 0, 0)
_cf.BorderSizePixel = 2
_cf.Position = UDim2.new(0.1011, 0, 0.75, 0)
_cf.Size = UDim2.new(0, 187, 0, 178)

_cf2.Name = "wrap"; _cf2.Parent = _cf
_cf2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
_cf2.BorderColor3 = Color3.fromRGB(30, 30, 30)
_cf2.Size = UDim2.new(1, 0, 1, 0)

_hf.Name = "hueframe"; _hf.Parent = _cf2
_hf.BackgroundColor3 = Color3.fromRGB(15,15,15)
_hf.BorderColor3 = Color3.fromRGB(30, 30, 30)
_hf.BorderSizePixel = 2
_hf.Position = UDim2.new(-0.083, 18, -0.056, 13)
_hf.Size = UDim2.new(0.25, 110, 0.25, 110)

_m1.Name = "main"; _m1.Parent = _hf
_m1.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
_m1.Size = UDim2.new(1, 0, 1, 0); _m1.ZIndex = 6

_pk.Name = "picker"; _pk.Parent = _m1
_pk.BackgroundColor3 = Color3.fromRGB(232, 0, 255)
_pk.Size = UDim2.new(1, 0, 1, 0)
_pk.ZIndex = 104
_pk.Image = "rbxassetid://2615689005"

_pf.Name = "pickerframe"; _pf.Parent = _cf
_pf.Position = UDim2.new(0.801, 14, -0.056, 13)
_pf.BorderColor3 = Color3.fromRGB(30, 30, 30)
_pf.Size = UDim2.new(0, 20, 0.25, 110)

_m2.Name = "main2"; _m2.Parent = _pf
_m2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
_m2.Size = UDim2.new(0, 20, 1, 0); _m2.ZIndex = 6

_hue.Name = "hue"; _hue.Parent = _m2
_hue.Image = "rbxassetid://2615692420"
_hue.Size = UDim2.new(0, 20, 1, 0)
_hue.ZIndex = 104

_clr.Name = "clr"; _clr.Parent = _cf
_clr.BorderColor3 = Color3.fromRGB(60, 60, 60)
_clr.BackgroundTransparency = 1; _clr.Size = UDim2.new(0, 0, 0, 14)

_ccf.Name = "colorShow"; _ccf.Parent = _cf
_ccf.Position = UDim2.new(0.98, 0, 0.915, 0)
_ccf.Size = UDim2.new(-0.965, 0, 0, 12)

_txt.Name = "rgbText"; _txt.Parent = _ccf
_txt.BackgroundTransparency = 1
_txt.Size = UDim2.new(1, 0, 1, 0)
_txt.Text = args.text or args.flag
_txt.Font = Enum.Font.Code
_txt.TextColor3 = library.Colors.libColor
_txt.TextSize = 13; _txt.TextStrokeTransparency = 0

local function updateColor(v, fallback)
	if typeof(v) == "table" then v = fallback end
	library.flags[args.flag] = v
	_f.BackgroundColor3 = v
	local r,g,b = v.r*255,v.g*255,v.b*255
	_txt.Text = ("RGB(%d, %d, %d)"):format(r, g, b)
	_txt.TextColor3 = v
	if args.callback then args.callback(v) end
end

local white, black = Color3.new(1,1,1), Color3.new(0,0,0)
local cols = {Color3.new(1,0,0),Color3.new(1,1,0),Color3.new(0,1,0),Color3.new(0,1,1),Color3.new(0,0,1),Color3.new(1,0,1),Color3.new(1,0,0)}
local pickerX, pickerY, hueY, ox, oy = 0,0,0,0,0

_hue.MouseMoved:Connect(function(_, y) hueY = y end)
_pk.MouseMoved:Connect(function(x, y) pickerX, pickerY = x, y end)

_hue.MouseEnter:Connect(function()
	local con = _hue.InputBegan:Connect(function(k)
		if k.UserInputType == Enum.UserInputType.MouseButton1 then
			while RunService.Heartbeat:Wait() and InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
				library.colorpicking = true
				local p = (hueY - _hue.AbsolutePosition.Y - 36) / _hue.AbsoluteSize.Y
				local num = math.clamp(math.floor(p * 7 + 0.5), 1, 7)
				local start, stop = cols[math.floor(num)], cols[math.ceil(num)]
				local c = white:lerp(_pk.BackgroundColor3, ox):lerp(black, oy)
				_pk.BackgroundColor3 = start:lerp(stop, num - math.floor(num))
				updateColor(c)
			end
			library.colorpicking = false
		end
	end)
	_hue.MouseLeave:Connect(function() con:Disconnect() end)
end)

_pk.MouseEnter:Connect(function()
	local con = _pk.InputBegan:Connect(function(k)
		if k.UserInputType == Enum.UserInputType.MouseButton1 then
			while RunService.Heartbeat:Wait() and InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
				library.colorpicking = true
				local px = (pickerX - _pk.AbsolutePosition.X) / _pk.AbsoluteSize.X
				local py = (pickerY - _pk.AbsolutePosition.Y - 36) / _pk.AbsoluteSize.Y
				local c = white:lerp(_pk.BackgroundColor3, px):lerp(black, py)
				updateColor(c); ox, oy = px, py
			end
			library.colorpicking = false
		end
	end)
	_pk.MouseLeave:Connect(function() con:Disconnect() end)
end)

_b.MouseButton1Click:Connect(function()
	_cf.Visible = not _cf.Visible
end)
_b.MouseEnter:Connect(function() _m.BorderColor3 = library.Colors.libColor end)
_b.MouseLeave:Connect(function() _m.BorderColor3 = Color3.fromRGB(25, 25, 25) end)

table.insert(library.toInvis, _cf)
library.flags[args.flag] = Color3.new(1,1,1)
library.options[args.flag] = {type = "colorpicker", changeState = updateColor, skipflag = args.skipflag, oldargs = args}
updateColor(args.color or Color3.new(1,1,1))
end
return toggle
   end
   function group:addButton(args)
if not args.callback or not args.text then return warn("⚠️ missing args ⚠️") end
groupbox.Size += UDim2.new(0, 0, 0, 20)

local __f = Instance.new("Frame")
local __b = Instance.new("Frame")
local __m = Instance.new("Frame")
local __btn = Instance.new("TextButton")
local __grad = Instance.new("UIGradient")

__f.Name = "bx_"..math.random(10000,99999)
__f.Parent = grouper
__f.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
__f.BackgroundTransparency = 1.000
__f.BorderSizePixel = 0
__f.Size = UDim2.new(1, 0, 0, 21)

__b.Name = "bb_"..math.random(10000,99999)
__b.Parent = __f
__b.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
__b.BorderColor3 = Color3.fromRGB(0, 0, 0)
__b.BorderSizePixel = 2
__b.Position = UDim2.new(0.02, -1, 0.15, 0)
__b.Size = UDim2.new(0, 205, 0, 15)

__m.Name = "container_"..math.random(10000,99999)
__m.Parent = __b
__m.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
__m.BorderColor3 = Color3.fromRGB(39, 39, 39)
__m.Size = UDim2.new(1, 0, 1, 0)

__btn.Name = "click_"..math.random(10000,99999)
__btn.Parent = __m
__btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
__btn.BackgroundTransparency = 1.000
__btn.BorderSizePixel = 0
__btn.Size = UDim2.new(1, 0, 1, 0)
__btn.Font = Enum.Font.Code
__btn.Text = args.text or args.flag
__btn.TextColor3 = Color3.fromRGB(255, 255, 255)
__btn.TextSize = 13.000
__btn.TextStrokeTransparency = 0.000

__grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(59, 59, 59)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(83, 83, 83))
}
__grad.Rotation = 90
__grad.Parent = __m

__btn.MouseButton1Click:Connect(function()
	if not library.colorpicking then
		args.callback()
	end
end)

__btn.MouseEnter:Connect(function()
	__m.BorderColor3 = library.Colors.libColor
end)

__btn.MouseLeave:Connect(function()
	__m.BorderColor3 = Color3.fromRGB(39, 39, 39)
end)
   end
   function group:addSlider(args,sub)
if not args.flag or not args.max then return warn("⚠️ incorrect arguments ⚠️") end
groupbox.Size += UDim2.new(0, 0, 0, 31)
function riskyCfg(state)
	args.risky = state
end

local _sld = Instance.new("Frame")
local _bg = Instance.new("Frame")
local _main = Instance.new("Frame")
local _fill = Instance.new("Frame")
local _btn = Instance.new("TextButton")
local _val = Instance.new("TextLabel")
local _grad = Instance.new("UIGradient")
local _label = Instance.new("TextLabel")
local _plus = Instance.new("TextLabel")
local _minus = Instance.new("TextLabel")

_sld.Name = "slider_" .. math.random(100000, 999999)
_sld.Parent = grouper
_sld.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
_sld.BackgroundTransparency = 1
_sld.BorderSizePixel = 0
_sld.Size = UDim2.new(1, 0, 0, 30)

_bg.Name = "bg_" .. math.random(100000, 999999)
_bg.Parent = _sld
_bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
_bg.BorderColor3 = Color3.fromRGB(1, 1, 1)
_bg.BorderSizePixel = 2
_bg.Position = UDim2.new(0.02, -1, 0, 15)
_bg.Size = UDim2.new(0, 205, 0, 13)

_main.Name = "main_" .. math.random(100000, 999999)
_main.Parent = _bg
_main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
_main.BorderColor3 = Color3.fromRGB(20, 20, 20)
_main.Size = UDim2.new(1, 0, 1, 0)

_fill.Name = "fill_" .. math.random(100000, 999999)
_fill.Parent = _main
_fill.BackgroundColor3 = library.Colors.libColor
_fill.BackgroundTransparency = 0.2
_fill.BorderColor3 = Color3.fromRGB(60, 60, 60)
_fill.BorderSizePixel = 0
_fill.Size = UDim2.new(0.6172, 13, 1, 0)
if args.min < 0 then
	_fill.Position = UDim2.new(0.5, 0, 0, 0)
end

local _g = Instance.new("UIGradient", _fill)
_g.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(0.8, Color3.fromRGB(100, 100, 100)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(75, 75, 75))
}
_g.Rotation = 90

_btn.Name = "btn_" .. math.random(100000, 999999)
_btn.Parent = _main
_btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
_btn.BackgroundTransparency = 1
_btn.Size = UDim2.new(0, 191, 1, 0)
_btn.Font = Enum.Font.SourceSans
_btn.Text = ""
_btn.TextColor3 = Color3.fromRGB(0, 0, 0)
_btn.TextSize = 14

_val.Parent = _main
_val.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
_val.BackgroundTransparency = 1
_val.Position = UDim2.new(0.5, 0, 0.5, 0)
_val.Font = Enum.Font.Code
_val.Text = "1/10"
_val.TextColor3 = Color3.fromRGB(255, 255, 255)
_val.TextSize = 14
_val.TextStrokeTransparency = 0

_grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(105, 105, 105)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(121, 121, 121))
}
_grad.Rotation = 90
_grad.Parent = _main

_label.Name = "label_" .. math.random(100000, 999999)
_label.Parent = _sld
_label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
_label.BackgroundTransparency = 1
_label.Position = UDim2.new(0.03, -1, 0, 7)
_label.ZIndex = 2
_label.Font = Enum.Font.Code
_label.Text = args.text or args.flag
_label.TextColor3 = args.risky and library.Colors.riskyColor or Color3.fromRGB(244, 244, 244)
_label.TextSize = 13
_label.TextStrokeTransparency = 0
_label.TextXAlignment = Enum.TextXAlignment.Left

_plus.Name = "add_" .. math.random(100000, 999999)
_plus.Parent = _sld
_plus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
_plus.BackgroundTransparency = 1
_plus.Position = UDim2.new(0.911, -1, 0, 7)
_plus.ZIndex = 2
_plus.Font = Enum.Font.Code
_plus.Text = "+"
_plus.TextColor3 = Color3.fromRGB(244, 244, 244)
_plus.TextSize = 9
_plus.TextStrokeTransparency = 0

_minus.Name = "minus_" .. math.random(100000, 999999)
_minus.Parent = _sld
_minus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
_minus.BackgroundTransparency = 1
_minus.Position = UDim2.new(0.96, -1, 0, 7)
_minus.ZIndex = 2
_minus.Font = Enum.Font.Code
_minus.Text = "-"
_minus.TextColor3 = Color3.fromRGB(244, 244, 244)
_minus.TextSize = 9
_minus.TextStrokeTransparency = 0

local entered = false
local scrolling = false
local function round(v, d)
	local s = 10 ^ d
	return math.floor(v * s + 0.5) / s
end

local function updateValue(val)
	if library.colorpicking then return end
	if args.min < 0 then
		_fill:TweenSize(UDim2.new(val / 2 / args.max, 0, 1, 0), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.01)
	elseif val ~= 0 then
		_fill:TweenSize(UDim2.new(val / args.max, 0, 1, 0), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.01)
	else
		_fill:TweenSize(UDim2.new(0, 1, 1, 0), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.01)
	end
	_val.Text = val .. args.suffix .. "/" .. args.max .. args.suffix
	library.flags[args.flag] = val
	if args.callback then args.callback(val) end
end

local function updateScroll()
	while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and menu.Enabled do
		RunService.RenderStepped:Wait()
		library.scrolling = true
		_val.TextColor3 = Color3.fromRGB(255, 255, 255)
		scrolling = true
		local step = args.float or 0.1
		local range = args.max - args.min
		local px = (Mouse.X - _btn.AbsolutePosition.X) / _btn.AbsoluteSize.X
		local val = args.min + px * range
		val = math.clamp(round(args.min + step * math.floor((val - args.min) / step + 0.5), 2), args.min, args.max)
		updateValue(val)
		_fill.BackgroundColor3 = library.Colors.libColor
	end
	if scrolling and not entered then _val.TextColor3 = Color3.fromRGB(255, 255, 255) end
	if not menu.Enabled then entered = false end
	scrolling = false
	library.scrolling = false
end

_btn.MouseEnter:Connect(function()
	if library.colorpicking or scrolling or entered then return end
	entered = true
	_main.BorderColor3 = library.Colors.libColor
	while entered do task.wait() updateScroll() end
end)

_btn.MouseLeave:Connect(function()
	entered = false
	_main.BorderColor3 = Color3.fromRGB(20, 20, 20)
end)

library.flags[args.flag] = args.value or args.default
library.options[args.flag] = { type = "slider", changeState = updateValue, skipflag = args.skipflag, oldargs = args }
updateValue(args.value or args.default)
if not args.flag then return warn("⚠️ incorrect arguments ⚠️") end
groupbox.Size += UDim2.new(0, 0, 0, 35)

local tbx_ = Instance.new("Frame")
local bg_ = Instance.new("Frame")
local main_ = Instance.new("ScrollingFrame")
local input_ = Instance.new("TextBox")
local grad_ = Instance.new("UIGradient")
local label_ = Instance.new("TextLabel")

input_:GetPropertyChangedSignal("Text"):Connect(function()
    if library.colorpicking then return end
    library.flags[args.flag] = input_.Text
    args.value = input_.Text
    if args.callback then
        args.callback()
    end
end)

tbx_.Name = "textbox_"..math.random(100000,999999)
tbx_.Parent = grouper
tbx_.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tbx_.BackgroundTransparency = 1.000
tbx_.BorderSizePixel = 0
tbx_.Size = UDim2.new(1, 0, 0, 35)
tbx_.ZIndex = 10

bg_.Name = "bg_"..math.random(100000,999999)
bg_.Parent = tbx_
bg_.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
bg_.BorderColor3 = Color3.fromRGB(2, 2, 2)
bg_.BorderSizePixel = 2
bg_.Position = UDim2.new(0.02, -1, 0, 16)
bg_.Size = UDim2.new(0, 205, 0, 15)

main_.Name = "scroll_"..math.random(100000,999999)
main_.Parent = bg_
main_.Active = true
main_.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
main_.BorderColor3 = Color3.fromRGB(12, 12, 12)
main_.Size = UDim2.new(1, 0, 1, 0)
main_.CanvasSize = UDim2.new(0, 0, 0, 0)
main_.ScrollBarThickness = 0

input_.Name = "input_"..math.random(100000,999999)
input_.Parent = main_
input_.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
input_.BackgroundTransparency = 1.000
input_.Selectable = false
input_.Size = UDim2.new(1, 0, 1, 0)
input_.Font = Enum.Font.Code
input_.Text = args.value or ""
input_.TextColor3 = Color3.fromRGB(255, 255, 255)
input_.TextSize = 13.000
input_.TextStrokeTransparency = 0.000
input_.TextXAlignment = Enum.TextXAlignment.Left

grad_.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(59, 59, 59)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(83, 83, 83))
}
grad_.Rotation = 90
grad_.Name = "gradient"
grad_.Parent = main_

label_.Name = "txt_"..math.random(100000,999999)
label_.Parent = tbx_
label_.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
label_.BackgroundTransparency = 1.000
label_.Position = UDim2.new(0.03, -1, 0, 7)
label_.ZIndex = 2
label_.Font = Enum.Font.Code
label_.Text = args.text or args.flag
label_.TextColor3 = Color3.fromRGB(244, 244, 244)
label_.TextSize = 13.000
label_.TextStrokeTransparency = 0.000
label_.TextXAlignment = Enum.TextXAlignment.Left

library.flags[args.flag] = args.value or ""
library.options[args.flag] = {
    type = "textbox",
    changeState = function(v) input_.Text = v end,
    skipflag = args.skipflag,
    oldargs = args
}
if not args.flag or not args.values then return warn("⚠️ incorrect arguments ⚠️") end
groupbox.Size += UDim2.new(0, 0, 0, 34)
library.multiZindex -= 1

-- 🧱 主UI組件
local list = Instance.new("Frame")
local bg = Instance.new("Frame")
local main = Instance.new("ScrollingFrame")
local button = Instance.new("TextButton")
local dumbtriangle = Instance.new("ImageLabel")
local valuetext = Instance.new("TextLabel")
local gradient = Instance.new("UIGradient")
local text = Instance.new("TextLabel")
local frame = Instance.new("Frame")
local holder = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

list.Name = "list_"..math.random(100000,999999)
list.Parent = grouper
list.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
list.BackgroundTransparency = 1.000
list.BorderSizePixel = 0
list.Size = UDim2.new(1, 0, 0, 35)
list.ZIndex = library.multiZindex

bg.Name = "bg_"..math.random(100000,999999)
bg.Parent = list
bg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
bg.BorderSizePixel = 0
bg.Position = UDim2.new(0.02, -1, 0, 16)
bg.Size = UDim2.new(0, 205, 0, 15)

main.Name = "main_"..math.random(100000,999999)
main.Parent = bg
main.Active = true
main.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
main.BorderColor3 = Color3.fromRGB(1, 1, 1)
main.Size = UDim2.new(1, 0, 1, 0)
main.CanvasSize = UDim2.new(0, 0, 0, 0)
main.ScrollBarThickness = 0

button.Name = "button_"..math.random(100000,999999)
button.Parent = main
button.BackgroundTransparency = 1.000
button.Size = UDim2.new(0, 191, 1, 0)
button.Font = Enum.Font.Code
button.Text = ""
button.TextColor3 = Color3.fromRGB(0, 0, 0)
button.TextSize = 14

dumbtriangle.Name = "arrow_"..math.random(100000,999999)
dumbtriangle.Parent = main
dumbtriangle.BackgroundTransparency = 1.000
dumbtriangle.Position = UDim2.new(1, -11, 0.5, -3)
dumbtriangle.Size = UDim2.new(0, 7, 0, 6)
dumbtriangle.ZIndex = 3
dumbtriangle.Image = "rbxassetid://8532000591"

valuetext.Name = "valuetext_"..math.random(100000,999999)
valuetext.Parent = main
valuetext.BackgroundTransparency = 1.000
valuetext.Position = UDim2.new(0.002, 2, 0, 7)
valuetext.ZIndex = 2
valuetext.Font = Enum.Font.Code
valuetext.Text = ""
valuetext.TextColor3 = Color3.fromRGB(244, 244, 244)
valuetext.TextSize = 13
valuetext.TextStrokeTransparency = 0

gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(105, 105, 105)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(121, 121, 121))
}
gradient.Rotation = 90
gradient.Parent = main

text.Name = "text_"..math.random(100000,999999)
text.Parent = list
text.BackgroundTransparency = 1.000
text.Position = UDim2.new(0.03, -1, 0, 7)
text.ZIndex = 2
text.Font = Enum.Font.Code
text.Text = args.text or args.flag
text.TextColor3 = Color3.fromRGB(244, 244, 244)
text.TextSize = 13
text.TextStrokeTransparency = 0

frame.Name = "frame_"..math.random(100000,999999)
frame.Parent = list
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.Position = UDim2.new(0.03, -1, 0.605, 15)
frame.Size = UDim2.new(0, 203, 0, 0)
frame.Visible = false
frame.ZIndex = library.multiZindex

holder.Name = "holder_"..math.random(100000,999999)
holder.Parent = frame
holder.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
holder.Size = UDim2.new(1, 0, 1, 0)

UIListLayout.Parent = holder
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- 🔁 Value/Callback 處理
local function updateValue(value)
	if value == nil then
		valuetext.Text = "nil"
		return
	end

	if args.multiselect then
		if type(value) == "string" then
			if not table.find(library.options[args.flag].values, value) then return end
			if table.find(library.flags[args.flag], value) then
				for i,v in pairs(library.flags[args.flag]) do
					if v == value then table.remove(library.flags[args.flag], i) end
				end
			else
				table.insert(library.flags[args.flag], value)
			end
		else
			library.flags[args.flag] = value
		end

		local btnText = ""
		for i,v in pairs(library.flags[args.flag]) do
			local comma = i ~= #library.flags[args.flag] and "," or ""
			btnText = btnText..v..comma
		end
		valuetext.Text = (btnText == "") and "..." or btnText

		for _,v in next, holder:GetChildren() do
			if v.ClassName ~= "Frame" then continue end
			v.off.TextColor3 = Color3.fromRGB(155, 155, 155)
			for _,selected in pairs(library.flags[args.flag]) do
				if v.Name == selected then
					v.off.TextColor3 = Color3.new(1,1,1)
				end
			end
		end

		if args.callback then args.callback(library.flags[args.flag]) end
	else
		if not table.find(library.options[args.flag].values, value) then value = library.options[args.flag].values[1] end
		library.flags[args.flag] = value

		for _,v in next, holder:GetChildren() do
			if v.ClassName ~= "Frame" then continue end
			v.off.TextColor3 = Color3.new(0.65,0.65,0.65)
			if v.Name == library.flags[args.flag] then
				v.off.TextColor3 = library.Colors.libColor
			end
		end

		frame.Visible = false
		valuetext.Text = library.flags[args.flag]

		if args.callback then args.callback(library.flags[args.flag]) end
	end
end

-- ♻️ Refresh 選項
local function refresh(tbl)
	for _,v in next, holder:GetChildren() do
		if v.ClassName == "Frame" then v:Destroy() end
	end
	frame.Size = UDim2.new(0, 203, 0, 0)

	for _,v in pairs(tbl) do
		frame.Size += UDim2.new(0, 0, 0, 20)

		local option = Instance.new("Frame")
		option.Name = v
		option.Parent = holder
		option.Size = UDim2.new(1, 0, 0, 20)
		option.BackgroundTransparency = 1

		local button_2 = Instance.new("TextButton")
		button_2.Name = "button"
		button_2.Parent = option
		button_2.Size = UDim2.new(1, 0, 1, 0)
		button_2.BackgroundColor3 = Color3.fromRGB(10,10,10)
		button_2.BackgroundTransparency = 0.85
		button_2.BorderSizePixel = 0
		button_2.Text = ""

		local text_2 = Instance.new("TextLabel")
		text_2.Name = "off"
		text_2.Parent = option
		text_2.Size = UDim2.new(0, 0, 1, 0)
		text_2.Position = UDim2.new(0, 4, 0, 0)
		text_2.BackgroundTransparency = 1
		text_2.Font = Enum.Font.Code
		text_2.Text = v
		text_2.TextColor3 = args.multiselect and Color3.fromRGB(155,155,155) or library.Colors.libColor
		text_2.TextSize = 14
		text_2.TextStrokeTransparency = 0
		text_2.TextXAlignment = Enum.TextXAlignment.Left

		button_2.MouseButton1Click:Connect(function()
			updateValue(v)
		end)
		button_2.MouseEnter:Connect(function()
			button_2.BorderColor3 = library.Colors.libColor
			button_2.BorderSizePixel = 2
			button_2.MouseLeave:Connect(function()
				button_2.BorderColor3 = Color3.fromRGB(1,1,1)
				button_2.BorderSizePixel = 0
			end)
		end)
	end

	library.options[args.flag].values = tbl
	updateValue(table.find(tbl, library.flags[args.flag]) and library.flags[args.flag] or tbl[1])
end

-- 🧠 List邏輯回調處理
button.MouseButton1Click:Connect(function()
	if not library.colorpicking then
		frame.Visible = not frame.Visible
	end
end)

button.MouseEnter:Connect(function()
	main.BorderColor3 = library.Colors.libColor
end)

button.MouseLeave:Connect(function()
	main.BorderColor3 = Color3.fromRGB(1,1,1)
end)

table.insert(library.toInvis, frame)
library.flags[args.flag] = args.multiselect and {} or ""
library.options[args.flag] = {
	type = "list",
	changeState = updateValue,
	values = args.values,
	refresh = refresh,
	skipflag = args.skipflag,
	oldargs = args
}

refresh(args.values)
updateValue(args.value or (not args.multiselect and args.values[1]) or "abcdefghijklmnopqrstuwvxyz")
if not args.flag or not args.values then return warn("⚠️ incorrect arguments ⚠️") end
groupbox.Size += UDim2.new(0, 0, 0, 138)
library.multiZindex -= 1

local _l = Instance.new("Frame")
local _f = Instance.new("Frame")
local _main = Instance.new("Frame")
local _scroll = Instance.new("ScrollingFrame")
local _layout = Instance.new("UIListLayout")
local _down = Instance.new("ImageLabel")
local _up = Instance.new("ImageLabel")

_l.Name = "list_"..math.random(100000,999999)
_l.Parent = grouper
_l.BackgroundColor3 = Color3.new(1,1,1)
_l.BackgroundTransparency = 1
_l.BorderSizePixel = 0
_l.Position = UDim2.new(0, 0, 0.1081, 0)
_l.Size = UDim2.new(1, 0, 0, 138)

_f.Name = "container_"..math.random(100000,999999)
_f.Parent = _l
_f.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
_f.BorderColor3 = Color3.new(0,0,0)
_f.BorderSizePixel = 2
_f.Position = UDim2.new(0.02, -1, 0.044, 0)
_f.Size = UDim2.new(0, 205, 0, 128)

_main.Name = "main_"..math.random(100000,999999)
_main.Parent = _f
_main.BackgroundColor3 = Color3.fromRGB(11, 11, 11)
_main.BorderColor3 = Color3.fromRGB(14, 14, 14)
_main.Size = UDim2.new(1, 0, 1, 0)

_scroll.Name = "scroll_"..math.random(100000,999999)
_scroll.Parent = _main
_scroll.Active = true
_scroll.BackgroundTransparency = 1
_scroll.BorderSizePixel = 0
_scroll.Position = UDim2.new(0, 0, 0.0057, 0)
_scroll.Size = UDim2.new(1, 0, 1, 0)
_scroll.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
_scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
_scroll.ScrollBarThickness = 0
_scroll.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
_scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
_scroll.ScrollingEnabled = true
_scroll.ScrollBarImageTransparency = 0

_layout.Parent = _scroll

_down.Name = "downArrow"
_down.Parent = _f
_down.BackgroundTransparency = 1
_down.Position = UDim2.new(0.93, 4, 1, -9)
_down.Size = UDim2.new(0, 7, 0, 6)
_down.ZIndex = 3
_down.Image = "rbxassetid://8548723563"
_down.Visible = false

_up.Name = "upArrow"
_up.Parent = _f
_up.BackgroundTransparency = 1
_up.Position = UDim2.new(0, 3, 0, 3)
_up.Size = UDim2.new(0, 7, 0, 6)
_up.ZIndex = 3
_up.Image = "rbxassetid://8548757311"
_up.Visible = false

local function setDropdown(val)
	if val == nil then return end
	if not table.find(library.options[args.flag].values, val) then
		val = library.options[args.flag].values[1]
	end
	library.flags[args.flag] = val
	for _, v in next, _scroll:GetChildren() do
		if v.ClassName ~= "Frame" then continue end
		if v.text.Text == val then
			v.text.TextColor3 = library.Colors.libColor
		else
			v.text.TextColor3 = Color3.new(1, 1, 1)
		end
	end
	if args.callback then args.callback(val) end
	_scroll.Visible = true
end

_scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
	_up.Visible = (_scroll.CanvasPosition.Y > 1)
	_down.Visible = (_scroll.CanvasPosition.Y + 1 < (_scroll.AbsoluteCanvasSize.Y - _scroll.AbsoluteSize.Y))
end)

local function refreshDropdown(tbl)
	for _, v in next, _scroll:GetChildren() do
		if v.ClassName == "Frame" then v:Destroy() end
	end
	for _, v in pairs(tbl) do
		local _item = Instance.new("Frame")
		local _btn = Instance.new("TextButton")
		local _txt = Instance.new("TextLabel")

		_item.Name = "itm_"..tostring(math.random(10000,99999))
		_item.Parent = _scroll
		_item.BackgroundTransparency = 1
		_item.Size = UDim2.new(1, 0, 0, 18)

		_btn.Parent = _item
		_btn.BackgroundTransparency = 1
		_btn.Size = UDim2.new(1, 0, 1, 0)
		_btn.Text = ""

		_txt.Name = "text"
		_txt.Parent = _item
		_txt.BackgroundTransparency = 1
		_txt.Size = UDim2.new(1, 0, 0, 18)
		_txt.Font = Enum.Font.Code
		_txt.Text = v
		_txt.TextColor3 = Color3.new(1, 1, 1)
		_txt.TextSize = 14
		_txt.TextStrokeTransparency = 0

		_btn.MouseButton1Click:Connect(function()
			setDropdown(v)
		end)
	end

	_scroll.Visible = true
	library.options[args.flag].values = tbl
	setDropdown(table.find(tbl, library.flags[args.flag]) and library.flags[args.flag] or tbl[1])
end

library.flags[args.flag] = ""
library.options[args.flag] = {
	type = "cfg",
	changeState = setDropdown,
	values = args.values,
	refresh = refreshDropdown,
	skipflag = args.skipflag,
	oldargs = args
}

refreshDropdown(args.values)
setDropdown(args.value or not args.multiselect and args.values[1] or "abcdefghijklmnopqrstuwvxyz")
end

function group:addColorpicker(args)
if not args.flag then return warn("⚠️ incorrect arguments ⚠️") end
groupbox.Size += UDim2.new(0, 0, 0, 20)
library.multiZindex -= 1
jigCount -= 1
topStuff -= 1

local _cp = Instance.new("Frame")
local _back = Instance.new("Frame")
local _mid = Instance.new("Frame")
local _front = Instance.new("Frame")
local _txt = Instance.new("TextLabel")
local _frame2 = Instance.new("Frame")
local _btn = Instance.new("TextButton")
local _clrFrame = Instance.new("Frame")
local _clrBase = Instance.new("Frame")
local _hueWrap = Instance.new("Frame")
local _main = Instance.new("Frame")
local _hueImg = Instance.new("ImageLabel")
local _pickerWrap = Instance.new("Frame")
local _main2 = Instance.new("Frame")
local _picker = Instance.new("ImageLabel")
local _clr = Instance.new("Frame")
local _copy = Instance.new("TextButton")
local _currFrame = Instance.new("Frame")
local _currText = Instance.new("TextLabel")

_cp.Name = "cp_" .. math.random(100000,999999)
_cp.Parent = grouper
_cp.BackgroundColor3 = Color3.new(1,1,1)
_cp.BackgroundTransparency = 1
_cp.BorderSizePixel = 0
_cp.Size = UDim2.new(1, 0, 0, 20)
_cp.ZIndex = topStuff

_txt.Name = "txt_" .. math.random(100000,999999)
_txt.Parent = _cp
_txt.BackgroundTransparency = 1
_txt.Position = UDim2.new(0.02, -1, 0, 10)
_txt.Font = Enum.Font.Code
_txt.Text = args.text or args.flag
_txt.TextColor3 = Color3.fromRGB(244, 244, 244)
_txt.TextSize = 13
_txt.TextStrokeTransparency = 0
_txt.TextXAlignment = Enum.TextXAlignment.Left

_btn.Name = "btn_" .. math.random(100000,999999)
_btn.Parent = _cp
_btn.BackgroundTransparency = 1
_btn.Size = UDim2.new(0, 202, 0, 22)
_btn.Font = Enum.Font.SourceSans
_btn.Text = ""
_btn.ZIndex = args.ontop and topStuff or jigCount
_btn.TextColor3 = Color3.new(0,0,0)
_btn.TextSize = 14

_frame2.Name = "cpwrap_"..math.random(10000,99999)
_frame2.Parent = _cp
_frame2.BackgroundColor3 = Color3.new(1,1,1)
_frame2.BorderColor3 = Color3.new(0,0,0)
_frame2.BorderSizePixel = 3
_frame2.Position = UDim2.new(0.86, 4, 0.272, 0)
_frame2.Size = UDim2.new(0, 20, 0, 10)

_mid.Name = "mid_"..math.random(999,999999)
_mid.Parent = _frame2
_mid.BackgroundColor3 = Color3.fromRGB(245,66,230)
_mid.BorderColor3 = Color3.fromRGB(25,25,25)
_mid.BorderSizePixel = 2
_mid.Size = UDim2.new(1, 0, 1, 0)

_front.Name = "dontchange"
_front.Parent = _mid
_front.BackgroundColor3 = library.Colors.libColor
_front.BorderColor3 = Color3.new(0,0,0)
_front.Size = UDim2.new(1, 0, 1, 0)

local _gradient = Instance.new("UIGradient", _front)
_gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(75, 75, 75)),
	ColorSequenceKeypoint.new(0.32, Color3.fromRGB(100, 100, 100)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
}
_gradient.Rotation = 270

_clrFrame.Name = "clrMain"
_clrFrame.Parent = _cp
_clrFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
_clrFrame.BorderColor3 = Color3.new(0,0,0)
_clrFrame.BorderSizePixel = 2
_clrFrame.Position = UDim2.new(0.101, 0, 0.75, 0)
_clrFrame.Size = UDim2.new(0, 187, 0, 178)

_clrBase.Name = "clrBase"
_clrBase.Parent = _clrFrame
_clrBase.BackgroundColor3 = Color3.fromRGB(15,15,15)
_clrBase.BorderColor3 = Color3.fromRGB(60, 60, 60)
_clrBase.Size = UDim2.new(1, 0, 1, 0)

_hueWrap.Name = "hueWrap"
_hueWrap.Parent = _clrBase
_hueWrap.BackgroundColor3 = Color3.fromRGB(15,15,15)
_hueWrap.BorderColor3 = Color3.fromRGB(60, 60, 60)
_hueWrap.BorderSizePixel = 2
_hueWrap.Position = UDim2.new(-0.083, 18, -0.056, 13)
_hueWrap.Size = UDim2.new(0.25, 110, 0.25, 110)

_main.Name = "mainHUE"
_main.Parent = _hueWrap
_main.BackgroundColor3 = Color3.fromRGB(15,15,15)
_main.BorderColor3 = Color3.new(0,0,0)
_main.Size = UDim2.new(1, 0, 1, 0)
_main.ZIndex = 6

_picker.Name = "picker_"..math.random(999,999999)
_picker.Parent = _main
_picker.BackgroundColor3 = Color3.fromRGB(232, 0, 255)
_picker.BorderColor3 = Color3.new(0,0,0)
_picker.Size = UDim2.new(1, 0, 1, 0)
_picker.ZIndex = 104
_picker.Image = "rbxassetid://2615689005"

_pickerWrap.Name = "pickerWrap"
_pickerWrap.Parent = _clrFrame
_pickerWrap.BackgroundColor3 = Color3.fromRGB(15,15,15)
_pickerWrap.BorderColor3 = Color3.fromRGB(60,60,60)
_pickerWrap.BorderSizePixel = 2
_pickerWrap.Position = UDim2.new(0.801, 14, -0.056, 13)
_pickerWrap.Size = UDim2.new(0, 20, 0.25, 110)

_currFrame.Name = "currColor"
_currFrame.Parent = _clrFrame
_currFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
_currFrame.BorderColor3 = Color3.fromRGB(15,15,15)
_currFrame.BorderSizePixel = 2
_currFrame.Position = UDim2.new(0.98, 0, 0.915, 0)
_currFrame.Size = UDim2.new(-0.965, 0, 0, 12)

_currText.Name = "currText"
_currText.Parent = _currFrame
_currText.BackgroundTransparency = 1
_currText.Font = Enum.Font.Code
_currText.Text = args.text or args.flag
_currText.TextColor3 = library.Colors.libColor
_currText.TextSize = 13
_currText.TextStrokeTransparency = 0
_currText.Size = UDim2.new(1, 0, 1, 0)

_main2.Name = "mainHueSide"
_main2.Parent = _pickerWrap
_main2.BackgroundColor3 = Color3.fromRGB(15,15,15)
_main2.BorderColor3 = Color3.new(0,0,0)
_main2.Size = UDim2.new(0, 20, 1, 0)
_main2.ZIndex = 6

_hueImg.Name = "hueImg"
_hueImg.Parent = _main2
_hueImg.BackgroundColor3 = Color3.fromRGB(255,0,178)
_hueImg.BorderColor3 = Color3.new(0,0,0)
_hueImg.Size = UDim2.new(0, 20, 1, 0)
_hueImg.ZIndex = 104
_hueImg.Image = "rbxassetid://2615692420"

_clr.Name = "clr"
_clr.Parent = _clrFrame
_clr.BackgroundTransparency = 1
_clr.BorderColor3 = Color3.fromRGB(30,30,30)
_clr.BorderSizePixel = 2
_clr.Position = UDim2.new(0.028, 0, 0, 2)
_clr.Size = UDim2.new(0, 0, 0, 14)
_clr.ZIndex = 5

-- 按鈕觸發顏色盤開關
_btn.MouseButton1Click:Connect(function()
	_clrFrame.Visible = not _clrFrame.Visible
	_mid.BorderColor3 = Color3.fromRGB(25,25,25)
end)

_btn.MouseEnter:Connect(function()
	_mid.BorderColor3 = library.Colors.libColor
end)

_btn.MouseLeave:Connect(function()
	_mid.BorderColor3 = Color3.fromRGB(25,25,25)
end)
local function updateValue(value,fakevalue)
   if typeof(value) == "table" then value = fakevalue end
   library.flags[args.flag] = value
   front.BackgroundColor3 = value
 
   local r, g, b = value.r * 255, value.g * 255, value.b * 255
   CurrentColorFrame_Text.TextColor3 = value
   CurrentColorFrame_Text.Text = "RGB(" .. math.floor(r) .. ", " .. math.floor(g) .. ", " .. math.floor(b) .. ")"
 
   if args.callback then
args.callback(value)
   end
end
 
local white, black = Color3.new(1,1,1), Color3.new(0,0,0)
local colors = {Color3.new(1,0,0),Color3.new(1,1,0),Color3.new(0,1,0),Color3.new(0,1,1),Color3.new(0,0,1),Color3.new(1,0,1),Color3.new(1,0,0)}
local heartbeat = RunService.Heartbeat
local pickerX,pickerY,hueY = 0,0,0
local oldpercentX,oldpercentY = 0,0
 
hue.MouseEnter:Connect(function()
local input = hue.InputBegan:connect(function(key)
if key.UserInputType == Enum.UserInputType.MouseButton1 then
   while heartbeat:wait() and InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
library.colorpicking = true
local percent = (hueY-hue.AbsolutePosition.Y-36)/hue.AbsoluteSize.Y
local num = math.max(1, math.min(7,math.floor(((percent*7+0.5)*100))/100))
local startC = colors[math.floor(num)]
local endC = colors[math.ceil(num)]
local color = white:lerp(picker.BackgroundColor3, oldpercentX):lerp(black, oldpercentY)
picker.BackgroundColor3 = startC:lerp(endC, num-math.floor(num)) or Color3.new(0, 0, 0)
updateValue(color)
   end
   library.colorpicking = false
end
end)
local leave
leave = hue.MouseLeave:connect(function()
input:disconnect()
leave:disconnect()
end)
end)
 
picker.MouseEnter:Connect(function()
local input = picker.InputBegan:connect(function(key)
if key.UserInputType == Enum.UserInputType.MouseButton1 then
   while heartbeat:wait() and InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
library.colorpicking = true
local xPercent = (pickerX-picker.AbsolutePosition.X)/picker.AbsoluteSize.X
local yPercent = (pickerY-picker.AbsolutePosition.Y-36)/picker.AbsoluteSize.Y
local color = white:lerp(picker.BackgroundColor3, xPercent):lerp(black, yPercent)
updateValue(color)
oldpercentX,oldpercentY = xPercent,yPercent
   end
   library.colorpicking = false
end
end)
local leave
leave = picker.MouseLeave:connect(function()
input:disconnect()
leave:disconnect()
end)
end)
 
hue.MouseMoved:connect(function(_, y)
hueY = y
end)
 
picker.MouseMoved:connect(function(x, y)
pickerX,pickerY = x,y
end)
 
table.insert(library.toInvis,colorFrame)
library.flags[args.flag] = Color3.new(1,1,1)
library.options[args.flag] = {type = "colorpicker",changeState = updateValue,skipflag = args.skipflag,oldargs = args}
updateValue(args.color or Color3.new(1,1,1))
   end
   function group:addKeybind(args)
if not args.flag then return warn("⚠️ incorrect arguments ⚠️ - missing args on toggle:keybind") end
groupbox.Size += UDim2.new(0, 0, 0, 20)

local __trigger = false
local __frame = Instance.new("Frame")
local __label = Instance.new("TextLabel")
local __button = Instance.new("TextButton")

__frame.Name = "frm_" .. math.random(100000, 999999)
__frame.Parent = grouper
__frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
__frame.BackgroundTransparency = 1
__frame.BorderSizePixel = 0
__frame.Size = UDim2.new(1, 0, 0, 20)

__label.Name = "lbl_" .. math.random(100000, 999999)
__label.Parent = __frame
__label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
__label.BackgroundTransparency = 1
__label.Position = UDim2.new(0.02, -1, 0, 10)
__label.Font = Enum.Font.Code
__label.Text = args.text or args.flag
__label.TextColor3 = Color3.fromRGB(244, 244, 244)
__label.TextSize = 13
__label.TextStrokeTransparency = 0
__label.TextXAlignment = Enum.TextXAlignment.Left

__button.Name = "btn_" .. math.random(100000, 999999)
__button.Parent = __frame
__button.BackgroundColor3 = Color3.fromRGB(187, 131, 255)
__button.BackgroundTransparency = 1
__button.BorderSizePixel = 0
__button.Position = UDim2.new(7.09711117e-08, 0, 0, 0)
__button.Size = UDim2.new(0.02, 0, 1, 0)
__button.Font = Enum.Font.Code
__button.Text = "--"
__button.TextColor3 = Color3.fromRGB(155, 155, 155)
__button.TextSize = 13
__button.TextStrokeTransparency = 0
__button.TextXAlignment = Enum.TextXAlignment.Right

function updateValue(k)
	if library.colorpicking then return end
	library.flags[args.flag] = k
	__button.Text = keynames[k] or "[" .. k.Name .. "]"
end

InputService.InputBegan:Connect(function(k)
	local key = k.KeyCode == Enum.KeyCode.Unknown and k.UserInputType or k.KeyCode
	if __trigger then
		if not table.find(library.blacklisted, key) then
			__trigger = false
			library.flags[args.flag] = key
			__button.Text = keynames[key] or "[" .. key.Name .. "]"
			__button.TextColor3 = Color3.fromRGB(155, 155, 155)
		end
	end
	if not __trigger and key == library.flags[args.flag] and args.callback then
		args.callback(key)
	end
end)

__button.MouseButton1Click:Connect(function()
	if library.colorpicking then return end
	library.flags[args.flag] = Enum.KeyCode.Unknown
	__button.Text = "..."
	__button.TextColor3 = Color3.new(0.2, 0.2, 0.2)
	__trigger = true
end)

library.flags[args.flag] = Enum.KeyCode.Unknown
library.options[args.flag] = {type = "keybind", changeState = updateValue, skipflag = args.skipflag, oldargs = args}
updateValue(args.key or Enum.KeyCode.Unknown)
   end
   return group, groupbox
end
   return tab
end
 
--// Configs
function contains(list, x)
   for _, v in pairs(list) do
if v == x then return true end
end return false end
function library:createConfig()
   makefolder("HihiHub")
   local name = library.flags["config_name"]
   if contains(library.options["config_box"].values, name) then return library:Notify(name..".cfg already exists!", 5) end
   if name == "" then return library:Notify("You need to put a name in!", 5) end
   local jig = {}
   for i,v in next, library.flags do
if library.options[i].skipflag then continue end
if typeof(v) == "Color3" then jig[i] = {v.R,v.G,v.B}
   elseif typeof(v) == "EnumItem" then jig[i] = {string.split(tostring(v),".")[2],string.split(tostring(v),".")[3]}
   else jig[i] = v
   end
end
writefile("HihiHub/"..name..".cfg",game:GetService("HttpService"):JSONEncode(jig))
library:Notify("Succesfully created config "..name..".cfg!", 5)
library:refreshConfigs()
   end
 
   function library:saveConfig()
makefolder("HihiHub")
local name = library.flags["config_box"]
local jig = {}
for i,v in next, library.flags do
   if library.options[i].skipflag then continue end
   if typeof(v) == "Color3" then jig[i] = {v.R,v.G,v.B}
elseif typeof(v) == "EnumItem" then jig[i] = {string.split(tostring(v),".")[2],string.split(tostring(v),".")[3]}
else jig[i] = v
   end;end
   writefile(name,game:GetService("HttpService"):JSONEncode(jig))
   library:Notify("Succesfully updated config "..name..".cfg!", 5)
   library:refreshConfigs()
end
 
function library:loadConfig()
   local name = library.flags["config_box"]
   if not isfile(name) then
library:Notify("Config file not found!")
return end
local config = game:GetService("HttpService"):JSONDecode(readfile(name))
for i,v in next, library.options do
   spawn(function()pcall(function()
   if config[i] then
if v.type == "colorpicker" then v.changeState(Color3.new(config[i][1],config[i][2],config[i][3]))
   elseif v.type == "keybind" then v.changeState(Enum[config[i][1]][config[i][2]])
   else
if config[i] ~= library.flags[i] then v.changeState(config[i]) end
   end
else
   if v.type == "toggle" then v.changeState(false) v.riskcfg(v.risky)
elseif v.type == "slider" then v.changeState(v.args.value or 0) v.riskcfg(v.risky)
elseif v.type == "textbox" or v.type == "list" or v.type == "cfg" then v.changeState(v.args.value or v.args.text or "")
elseif v.type == "colorpicker" then v.changeState(v.args.color or Color3.new(1,1,1))
elseif v.type == "list" then v.changeState("")
elseif v.type == "keybind" then v.changeState(v.args.key or Enum.KeyCode.Unknown)
end
   end
   end)
   end)
end
library:Notify("Succesfully loaded config "..name..".cfg!", 5)
   end
 
   function library:deleteConfig()
if isfile(library.flags["config_box"]) then delfile(library.flags["config_box"])
library:refreshConfigs()
end;end
 
function library:refreshConfigs()
   local tbl = {}
   for i,v in next, listfiles("HihiHub") do table.insert(tbl,v) end
   library.options["config_box"].refresh(tbl)
end
end)()

return library
