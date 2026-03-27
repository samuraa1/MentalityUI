if game.PlaceId ~= 76137189788863 then
    game.Players.LocalPlayer:Kick("Game Not Supported. Only Raft Tycoon Is Supported")
    return
end

local Players         = game:GetService("Players")
local Workspace       = game:GetService("Workspace")
local HttpService     = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService  = game:GetService("UserInputService")
local RunService      = game:GetService("RunService")
local Lighting        = game:GetService("Lighting")
local TweenService    = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Stats           = game:GetService("Stats")
local VirtualUser     = game:GetService("VirtualUser")

local plr              = Players.LocalPlayer
local playerName       = plr.Name
local Character        = plr.Character or plr.CharacterAdded:Wait()
local humanoid         = Character:WaitForChild("Humanoid")
local humanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local camera           = Workspace.CurrentCamera
local PlaceId          = game.PlaceId

local DISCORD_LINK     = "https://discord.gg/DPCKQRJmdF"
local DISCORD_JOIN_URL = "https://pastebin.com/raw/iYvRJrSf"
local CHANGELOGS_URL   = "https://raw.githubusercontent.com/samuraa1/Samuraa1-Hub/refs/heads/main/RT-Changelogs.lua"
local BOOSTFPS_URL     = "https://raw.githubusercontent.com/samuraa1/Samuraa1-Hub/refs/heads/main/BoostFPS.lua"
local FEEDBACK_WEBHOOK = "https://discord.com/api/webhooks/1451962459043922143/baFCwLi2Gj2T-4X06Utpu8WM_qYkvKBDrwNvGP9nF3Z1BKUmbgYzNS3-IMWABY90LLL1"

local execCount = 1
pcall(function()
    local folder, file = "Samuraa1Hub", "Samuraa1Hub/execs.txt"
    if not isfolder(folder) then makefolder(folder) end
    if isfile(file) then execCount = (tonumber(readfile(file)) or 0) + 1 end
    writefile(file, tostring(execCount))
end)
shared._execs = execCount

local function SendFeedback(message)
    local data = HttpService:JSONEncode({
        embeds = {{
            title       = "Samuraa1 Hub Feedback",
            description = message,
            color       = 5814783,
            fields      = {{name = "User", value = playerName, inline = true}},
            footer      = {text = "Samuraa1 Hub · Feedback System"}
        }},
        username = "Samuraa1 Hub Feedback"
    })
    local ok = pcall(function()
        if syn and syn.request then
            syn.request({Url=FEEDBACK_WEBHOOK, Method="POST", Headers={["Content-Type"]="application/json"}, Body=data})
        elseif request then
            request({Url=FEEDBACK_WEBHOOK, Method="POST", Headers={["Content-Type"]="application/json"}, Body=data})
        elseif http_post then
            http_post(FEEDBACK_WEBHOOK, data, "application/json")
        else
            HttpService:PostAsync(FEEDBACK_WEBHOOK, data, Enum.HttpContentType.ApplicationJson)
        end
    end)
    return ok
end

local function GetTycoon()
    for _, v in next, Workspace.Tycoons:GetChildren() do
        if v:GetAttribute("Owner") == plr.Name then return v end
    end
end

local function parse_money(text)
    if not text then return nil end
    text = text:upper():gsub("%s",""):gsub("%$",""):gsub(",","")
    local mult = 1
    if     text:find("K") then mult=1e3;  text=text:gsub("K","")
    elseif text:find("M") then mult=1e6;  text=text:gsub("M","")
    elseif text:find("B") then mult=1e9;  text=text:gsub("B","")
    elseif text:find("T") then mult=1e12; text=text:gsub("T","")
    end
    local n = tonumber(text)
    return n and n * mult or nil
end

local function get_money()
    local ok, label = pcall(function()
        return plr.PlayerGui.other["HUD Elements"].Left.CashBase.Cash.Amount
    end)
    return ok and (parse_money(label.Text) or 0) or 0
end

local function get_touch_part(model)
    return model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/samuraa1/MentalityUI/main/Library.lua"))()

local Window = Library:Window({
    Name    = "Samuraa1 Hub",
    SubName = "Raft Tycoon",
    Logo    = "97594400820219"
})

local KeybindList = Library:KeybindList("Keybinds")

Library:Notification({
    Title       = "Info",
    Description = "Script has an Execution Logger. Only nickname, game and executor are logged.",
    Duration    = 8,
    Icon        = "97594400820219"
})

local ToggleRefs = {}

Window:Category("Overview")

local DashPage = Window:DashboardPage({
    Name        = "Dashboard",
    Icon        = "layout-dashboard",
    WelcomeText = "WELCOME TO",
    HubName     = "SAMURAA1 HUB",
    StatusText  = "free forever — for everyone",
    Badge       = "PLAYER",
    Links = {
        {Icon = "copy",      Tooltip = "Copy Discord Link",  Callback = function()
            pcall(function() setclipboard(DISCORD_LINK) end)
            Library:Notification({Title="Copied", Description="Discord link copied.", Duration=2, Icon="97594400820219"})
        end},
        {Icon = "users",     Tooltip = "Join Discord Server", Callback = function()
            pcall(function() loadstring(game:HttpGet(DISCORD_JOIN_URL))() end)
        end},
        {Icon = "file-text", Tooltip = "View Changelogs",   Callback = function()
            pcall(function() loadstring(game:HttpGet(CHANGELOGS_URL))() end)
        end},
        {Icon = "zap",       Tooltip = "Boost FPS",          Callback = function()
            pcall(function() loadstring(game:HttpGet(BOOSTFPS_URL))() end)
        end},
    },
    GameName        = "RAFT TYCOON",
    GameDescription = "Welcome to one of the best Raft Tycoon scripts!\nEnjoy tons of features waiting for you.",
    Stats = {
        {Name="UPTIME", Icon="clock", GetValue=function()
            local ok, t = pcall(function() return math.floor(Workspace.DistributedGameTime) end)
            if not ok or not t then return "—" end
            local h = math.floor(t/3600); local m = math.floor((t%3600)/60); local s = t%60
            return h>0 and ("%dh %dm"):format(h,m) or ("%dm %ds"):format(m,s)
        end},
        {Name="PING",   Icon="wifi",     GetValue=function()
            local ok, v = pcall(function() return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
            return ok and (v.." ms") or "—"
        end},
        {Name="EXECS",  Icon="terminal", GetValue=function() return tostring(shared._execs or 1) end},
    },
    Credits = {
        {Name="Samuraa1", Role="Script Creator"},
        {Name="samet",    Role="UI Library Creator"},
    },
    QuickAccess = {}
})

Window:Category("Main")
local MainPage = Window:Page({Name="Main",        Icon="gamepad-2"})

Window:Category("Local Player")
local LocalPage = Window:Page({Name="Local Player", Icon="user"})

Window:Category("Visuals")
local VisualsPage = Window:Page({Name="Visuals",    Icon="eye"})

Window:Category("Server")
local ServerPage = Window:Page({Name="Server",      Icon="server"})

DashPage:AddCard({Name="MAIN",         Description="Automation & tycoon helpers.", Icon="gamepad-2",   Tab=MainPage})
DashPage:AddCard({Name="LOCAL PLAYER", Description="Speed, fly, noclip & more.",   Icon="user",        Tab=LocalPage})
DashPage:AddCard({Name="SERVER",       Description="Server hop & info tools.",      Icon="server",      Tab=ServerPage})

local AutoGroup     = MainPage:Section({Name="Automation",   Icon="zap",           Side=1})
local CodesGroup    = MainPage:Section({Name="Codes",        Icon="tag",           Side=1})
local MiscGroup     = MainPage:Section({Name="Miscellaneous",Icon="wrench",        Side=2})
local TeleportGroup = MainPage:Section({Name="Teleports",    Icon="map-pin",       Side=2})

local originalPositions = {}
local collectParts      = {}
local toggleState       = false
local collectOffset     = Vector3.new(0, -2, 0)

local function SetupCollectParts()
    local tycoon = GetTycoon()
    if not tycoon then return end
    table.clear(originalPositions); table.clear(collectParts)
    for _, obj in next, tycoon:GetDescendants() do
        if obj:IsA("Part") and obj.Name == "CollectPart" then
            collectParts[#collectParts+1] = obj
            originalPositions[obj] = obj.CFrame
        end
    end
end

ToggleRefs.CollectMoney = AutoGroup:Toggle({
    Name     = "Auto Collect Money",
    Flag     = "CollectMoney",
    Default  = false,
    Tooltip  = "Moves collect parts to your character repeatedly to collect money faster.",
    Callback = function(v)
        getgenv().CollectMoney = v
        if v then
            SetupCollectParts()
            task.spawn(function()
                toggleState = true
                while getgenv().CollectMoney do
                    local char = plr.Character
                    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp and #collectParts > 0 then
                        local hrpCF = hrp.CFrame
                        for _, part in ipairs(collectParts) do
                            if part and part.Parent then
                                part.CFrame = toggleState and (hrpCF + collectOffset) or originalPositions[part]
                            end
                        end
                        toggleState = not toggleState
                    end
                    task.wait(0.3)
                end
            end)
        else
            for part, pos in next, originalPositions do
                if part and part.Parent then part.CFrame = pos end
            end
            table.clear(originalPositions); table.clear(collectParts)
        end
    end
})

AutoGroup:Divider()

local BUY_FOLDERS = {"Base","Dropper1","Dropper2","Dropper3","Dropper4",
                     "Farm","Hotel","Military Island","Tropical Island","Underwater"}

local function auto_buy()
    local tycoon = GetTycoon()
    local char   = plr.Character
    local hrp    = char and char:FindFirstChild("HumanoidRootPart")
    if not tycoon or not hrp then return end

    local money = get_money()

    for _, fname in next, BUY_FOLDERS do
        local folder = tycoon:FindFirstChild(fname)
        if not folder then continue end
        for _, btn in next, folder:GetDescendants() do
            if not getgenv().AutoBuy then return end
            if not (btn:IsA("Model") and btn.Name:lower():find("btn")) then continue end
            local ui         = btn:FindFirstChild("Btn")
            local main       = ui and ui:FindFirstChild("Main")
            local cost_label = main and main:FindFirstChild("Cost")
            if not cost_label then continue end
            local text = cost_label.Text
            if not text or text == "" then continue end
            text = text:lower()
            if text:find("robux") or text:find("") then continue end
            local is_free = text:find("free")
            local cost    = is_free and 0 or parse_money(text)
            if not is_free and (not cost or money < cost) then continue end
            local part = get_touch_part(btn)
            if not part then continue end
            pcall(firetouchinterest, hrp, part, 0)
            task.wait(0.05)
            pcall(firetouchinterest, hrp, part, 1)
            task.wait(0.08)
        end
    end
end

ToggleRefs.AutoBuy = AutoGroup:Toggle({
    Name     = "Auto Buy",
    Flag     = "AutoBuy",
    Default  = false,
    Tooltip  = "Automatically purchases tycoon upgrades when you have enough money.",
    Callback = function(v)
        getgenv().AutoBuy = v
        while v and getgenv().AutoBuy do
            auto_buy()
            task.wait(0.4)
        end
    end
})

AutoGroup:Divider()

ToggleRefs.Rebirth = AutoGroup:Toggle({
    Name     = "Auto Rebirth",
    Flag     = "Rebirth",
    Default  = false,
    Tooltip  = "Automatically triggers rebirth when available.",
    Callback = function(v)
        getgenv().Rebirth = v
        while v and getgenv().Rebirth do
            ReplicatedStorage.r.CALL_SERVER:FireServer("REBIRTH")
            task.wait(2)
        end
    end
})

ToggleRefs.DailyReward = AutoGroup:Toggle({
    Name     = "Auto Claim Daily Reward",
    Flag     = "DailyReward",
    Default  = false,
    Tooltip  = "Automatically claims your daily reward every 3 seconds.",
    Callback = function(v)
        getgenv().DailyReward = v
        while v and getgenv().DailyReward do
            ReplicatedStorage.r.INVOKE_SERVER:InvokeServer("DAILY_REWARD")
            task.wait(3)
        end
    end
})

AutoGroup:Divider()

local function AutoCollectLootboxes()
    local tycoon = GetTycoon()
    local char   = plr.Character
    local hrp    = char and char:FindFirstChild("HumanoidRootPart")
    if not tycoon or not hrp then return end
    local lootboxes = tycoon:FindFirstChild("Base")
        and tycoon.Base:FindFirstChild("Auto")
        and tycoon.Base.Auto:FindFirstChild("bui")
        and tycoon.Base.Auto.bui:FindFirstChild("LootboxSpawns")
        and tycoon.Base.Auto.bui.LootboxSpawns:FindFirstChild("Lootboxes")
    if not lootboxes then return end
    for _, model in next, lootboxes:GetChildren() do
        if not getgenv().AutoCollectLootboxes then break end
        for _, obj in next, model:GetDescendants() do
            if obj:IsA("ProximityPrompt") and obj.Parent:IsA("BasePart") then
                pcall(function()
                    local part = obj.Parent
                    pcall(firetouchinterest, hrp, part, 0)
                    task.wait(0.05)
                    pcall(fireproximityprompt, obj)
                    task.wait(0.05)
                    pcall(firetouchinterest, hrp, part, 1)
                    task.wait(0.05)
                end)
            end
        end
    end
end

ToggleRefs.AutoCollectLootboxes = AutoGroup:Toggle({
    Name     = "Auto Collect Lootboxes",
    Flag     = "AutoCollect",
    Default  = false,
    Tooltip  = "Automatically collects lootboxes in your tycoon using touch events.",
    Callback = function(v)
        getgenv().AutoCollectLootboxes = v
        while v and getgenv().AutoCollectLootboxes do
            AutoCollectLootboxes()
            task.wait(0.6)
        end
    end
})

local Codes = {"Winter","Shark","Freemoney","2025","Volcano"}
CodesGroup:Button({
    Name     = "Redeem All Valid Codes",
    Icon     = "tag",
    Tooltip  = "Attempts to redeem all known codes via the game remote.",
    Callback = function()
        local Remote = ReplicatedStorage.r.INVOKE_SERVER
        for _, code in ipairs(Codes) do
            pcall(function() Remote:InvokeServer("CODE", code) end)
            task.wait(2.5)
        end
        Library:Notification({Title="Done", Description="All codes redeemed.", Duration=3, Icon="97594400820219"})
    end
})
CodesGroup:Label("Note: Shark and 2025 may not redeem via remote — use in-game settings.")

ToggleRefs.DeleteSharks = MiscGroup:Toggle({
    Name     = "Auto Delete All Sharks",
    Flag     = "DeleteSharks",
    Default  = false,
    Tooltip  = "Removes sharks and the shark spawner from your tycoon every 5 seconds.",
    Callback = function(v)
        getgenv().AutoDeleteSharks = v
        while getgenv().AutoDeleteSharks do
            task.wait(5)
            local tycoon = GetTycoon()
            if tycoon then
                local base = tycoon:FindFirstChild("Base")
                local autoF = base and base:FindFirstChild("Auto")
                local bui   = autoF and autoF:FindFirstChild("bui")
                local spawner = bui and bui:FindFirstChild("SharkSpawner")
                if spawner then spawner:Destroy() end
            end
            for _, obj in next, Workspace:GetDescendants() do
                if obj.Name == "SharkModel" then obj:Destroy() end
            end
        end
    end
})

MiscGroup:Divider()

local OceanParts          = {}
local WalkOnWaterLoopRunning = false
local function SetWalkOnWater(state)
    if not state then
        for part, old in pairs(OceanParts) do
            if part.Parent then part.CanCollide = old end
        end
        table.clear(OceanParts)
        WalkOnWaterLoopRunning = false
        return
    end
    if WalkOnWaterLoopRunning then return end
    WalkOnWaterLoopRunning = true
    task.spawn(function()
        while WalkOnWaterLoopRunning and Library.Flags.WalkOnWater do
            local ocean = Workspace.Assets and Workspace.Assets.Ocean and Workspace.Assets.Ocean:FindFirstChild("Ocean")
            if ocean then
                for _, obj in ocean:GetDescendants() do
                    if (obj:IsA("PartOperation") or obj:IsA("BasePart")) and not OceanParts[obj] then
                        OceanParts[obj] = obj.CanCollide
                        obj.CanCollide  = true
                    end
                end
            end
            task.wait(2)
        end
        WalkOnWaterLoopRunning = false
    end)
end
ToggleRefs.WalkOnWater = MiscGroup:Toggle({
    Name="Walk On Water", Flag="WalkOnWater", Default=false,
    Tooltip="Makes ocean parts collidable so you can walk on water.",
    Callback=SetWalkOnWater
})

MiscGroup:Divider()

local tsunamiConn, tornadoConn
ToggleRefs.AntiTsunami = MiscGroup:Toggle({
    Name="Anti Tsunami", Flag="AntiTsunami", Default=false,
    Tooltip="Destroys tsunami models as soon as they spawn.",
    Callback=function(v)
        getgenv().AntiTsunami = v
        if not v then if tsunamiConn then tsunamiConn:Disconnect(); tsunamiConn=nil end; return end
        local function clean()
            local wm = ReplicatedStorage:FindFirstChild("WeatherModules"); if wm then wm:Destroy() end
            for _, c in next, Workspace:GetChildren() do if c.Name=="TsunamiModel" then c:Destroy() end end
        end
        clean()
        tsunamiConn = Workspace.ChildAdded:Connect(function(obj)
            if getgenv().AntiTsunami and obj.Name=="TsunamiModel" then task.wait(); obj:Destroy() end
        end)
    end
})

ToggleRefs.AntiTornado = MiscGroup:Toggle({
    Name="Anti Tornado", Flag="AntiTornado", Default=false,
    Tooltip="Destroys tornado holders as soon as they spawn.",
    Callback=function(v)
        getgenv().AntiTornado = v
        if not v then if tornadoConn then tornadoConn:Disconnect(); tornadoConn=nil end; return end
        for _, c in next, Workspace:GetChildren() do if c.Name=="TornadoHolder" then c:Destroy() end end
        tornadoConn = Workspace.ChildAdded:Connect(function(obj)
            if getgenv().AntiTornado and obj.Name=="TornadoHolder" then task.wait(); obj:Destroy() end
        end)
    end
})

MiscGroup:Divider()

MiscGroup:Button({
    Name="Auto Complete Parkour", Icon="flag",
    Tooltip="Teleports your character smoothly to the parkour finish.",
    Callback=function()
        local char = plr.Character or plr.CharacterAdded:Wait()
        local hrp  = char:WaitForChild("HumanoidRootPart")
        local target = Vector3.new(-75606.00, 96.01, 50212.85)
        local t = TweenService:Create(hrp, TweenInfo.new((hrp.Position - target).Magnitude / 150, Enum.EasingStyle.Linear), {CFrame = CFrame.new(target)})
        t:Play()
    end
})

local function tp(pos) humanoidRootPart.CFrame = CFrame.new(pos) end
TeleportGroup:Button({Name="Teleport to Spawn",       Icon="map-pin", Tooltip="Teleports to the spawn area.", Callback=function() tp(Vector3.new(-75425.99,6.15,50269.23)) end})
TeleportGroup:Button({Name="Teleport to Leaderboards",Icon="map-pin", Tooltip="Teleports to the leaderboard area.", Callback=function() tp(Vector3.new(-75419.92,10.02,50328.85)) end})
TeleportGroup:Button({Name="Teleport to Parkour",     Icon="map-pin", Tooltip="Teleports to the parkour start.", Callback=function() tp(Vector3.new(-75527.73,9.89,50250.46)) end})
TeleportGroup:Button({Name="Teleport to PVP + Mob",   Icon="map-pin", Tooltip="Teleports to the PVP & mob arena.", Callback=function() tp(Vector3.new(-75517.45,9.97,50283.27)) end})

local GeneralGroup  = LocalPage:Section({Name="General",  Icon="shield",  Side=1})
local CameraGroup   = LocalPage:Section({Name="Camera",   Icon="camera",  Side=1})
local MovementGroup = LocalPage:Section({Name="Movement", Icon="activity",Side=2})

local idleConnection
ToggleRefs.AntiAFK = GeneralGroup:Toggle({
    Name    = "Anti AFK",
    Flag    = "AntiAFK",
    Default = true,
    Tooltip = "Prevents the game from detecting you as AFK.",
    Callback= function(v)
        if v then
            idleConnection = plr.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                task.wait(3)
            end)
        elseif idleConnection then
            idleConnection:Disconnect(); idleConnection = nil
        end
    end
})

GeneralGroup:Divider()

local infiniteJumpEnabled = false
ToggleRefs.InfiniteJump = GeneralGroup:Toggle({
    Name    = "Infinite Jump",
    Flag    = "InfiniteJump",
    Default = false,
    Tooltip = "Allows you to jump infinitely without touching the ground.",
    Callback= function(v) infiniteJumpEnabled = v end
})
GeneralGroup:Keybind({
    Name    = "Inf Jump Keybind",
    Flag    = "InfJumpKey",
    Default = Enum.KeyCode.V,
    Tooltip = "Keybind to toggle Infinite Jump on/off.",
    Callback= function()
        if ToggleRefs.InfiniteJump then
            ToggleRefs.InfiniteJump:Set(not Library.Flags.InfiniteJump)
        end
    end
})

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

GeneralGroup:Divider()

local flying = false
local flySpeed = 100
local flyHumanoid, flyRootPart
local flyInput = {W=false,A=false,S=false,D=false,Up=false,Down=false}
local flyBodyGyro, flyBodyVelocity, flyConn

local function onFlyCharacterAdded(char)
    flyHumanoid  = char:WaitForChild("Humanoid", 8)
    flyRootPart  = char:WaitForChild("HumanoidRootPart", 8)
    if flying then flying = false; if ToggleRefs.Fly then ToggleRefs.Fly:Set(false) end end
end
if plr.Character then onFlyCharacterAdded(plr.Character) end
plr.CharacterAdded:Connect(onFlyCharacterAdded)

UserInputService.InputBegan:Connect(function(in_, gp)
    if gp then return end
    local k = in_.KeyCode
    if k==Enum.KeyCode.W then flyInput.W=true elseif k==Enum.KeyCode.A then flyInput.A=true
    elseif k==Enum.KeyCode.S then flyInput.S=true elseif k==Enum.KeyCode.D then flyInput.D=true
    elseif k==Enum.KeyCode.Space then flyInput.Up=true elseif k==Enum.KeyCode.LeftControl then flyInput.Down=true end
end)
UserInputService.InputEnded:Connect(function(in_)
    local k = in_.KeyCode
    if k==Enum.KeyCode.W then flyInput.W=false elseif k==Enum.KeyCode.A then flyInput.A=false
    elseif k==Enum.KeyCode.S then flyInput.S=false elseif k==Enum.KeyCode.D then flyInput.D=false
    elseif k==Enum.KeyCode.Space then flyInput.Up=false elseif k==Enum.KeyCode.LeftControl then flyInput.Down=false end
end)

local function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn=nil end
    if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro=nil end
    if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity=nil end
    if flyHumanoid then
        flyHumanoid.PlatformStand = false
        flyHumanoid.AutoRotate    = true
        flyHumanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        flyHumanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
end

local function startFly()
    if not flyHumanoid or not flyRootPart then return end
    stopFly()
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.P = 9e4; flyBodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
    flyBodyGyro.CFrame = flyRootPart.CFrame; flyBodyGyro.Parent = flyRootPart
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.Velocity = Vector3.zero; flyBodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)
    flyBodyVelocity.Parent = flyRootPart
    flyHumanoid.PlatformStand = true; flyHumanoid.AutoRotate = true
    flyConn = RunService.RenderStepped:Connect(function()
        if not flying or not flyHumanoid or not flyRootPart or flyHumanoid.Health<=0 then return end
        local cam  = Workspace.CurrentCamera; if not cam then return end
        local wish = Vector3.zero
        if flyInput.W then wish += cam.CFrame.LookVector end
        if flyInput.S then wish -= cam.CFrame.LookVector end
        if flyInput.D then wish += cam.CFrame.RightVector end
        if flyInput.A then wish -= cam.CFrame.RightVector end
        local mob = flyHumanoid.MoveDirection
        if mob.Magnitude > 0 then wish += mob end
        if flyInput.Up   then wish += Vector3.yAxis end
        if flyInput.Down then wish -= Vector3.yAxis end
        if wish.Magnitude > 0 then wish = wish.Unit end
        flyBodyVelocity.Velocity = wish * flySpeed
        flyBodyGyro.CFrame = cam.CFrame
    end)
end

ToggleRefs.Fly = GeneralGroup:Toggle({
    Name="Fly", Flag="Fly", Default=false,
    Tooltip="Enables fly mode. Use WASD to move and Space/LCtrl to go up/down.",
    Callback=function(v) flying=v; if v then startFly() else stopFly() end end
})
GeneralGroup:Keybind({
    Name="Fly Keybind", Flag="FlyBind", Default=Enum.KeyCode.F,
    Tooltip="Keybind to toggle fly on/off.",
    Callback=function()
        if ToggleRefs.Fly then ToggleRefs.Fly:Set(not Library.Flags.Fly) end
    end
})
GeneralGroup:Slider({
    Name="Fly Speed", Flag="FlySpeed", Min=20, Max=500, Default=100, Suffix="studs/s",
    Tooltip="Controls how fast you fly.",
    Callback=function(v) flySpeed=v end
})

GeneralGroup:Divider()

local noclipEnabled    = false
local originalCollisions = {}
local noclipLoop
ToggleRefs.Noclip = GeneralGroup:Toggle({
    Name="Noclip", Flag="Noclip", Default=false,
    Tooltip="Disables collision on all character parts so you can phase through walls.",
    Callback=function(v)
        noclipEnabled = v
        if not Character then return end
        if v then
            originalCollisions = {}
            for _, part in ipairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then originalCollisions[part] = part.CanCollide end
            end
            noclipLoop = RunService.Stepped:Connect(function()
                if not Character then noclipLoop:Disconnect(); return end
                for _, part in ipairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
        else
            if noclipLoop then noclipLoop:Disconnect(); noclipLoop=nil end
            for part, state in pairs(originalCollisions) do
                if part and part:IsA("BasePart") then part.CanCollide = state end
            end
            originalCollisions = {}
        end
    end
})
GeneralGroup:Keybind({
    Name="Noclip Keybind", Flag="NoclipKey", Default=Enum.KeyCode.N,
    Tooltip="Keybind to toggle noclip on/off.",
    Callback=function()
        if ToggleRefs.Noclip then ToggleRefs.Noclip:Set(not Library.Flags.Noclip) end
    end
})

CameraGroup:Slider({
    Name="Field Of View (FOV)", Flag="FOVValue", Min=50, Max=120, Default=70, Suffix="°",
    Tooltip="Adjusts the camera's field of view.",
    Callback=function(v) if camera then camera.FieldOfView=v end end
})
CameraGroup:Divider()
CameraGroup:Slider({
    Name="Camera Zoom", Flag="CameraZoom", Min=10, Max=9999, Default=40, Suffix=" studs",
    Tooltip="Sets the maximum and minimum camera zoom distance.",
    Callback=function(v)
        if v==0 then plr.CameraMaxZoomDistance=math.huge; plr.CameraMinZoomDistance=0
        else plr.CameraMaxZoomDistance=v; plr.CameraMinZoomDistance=math.min(0.5,v/2) end
    end
})
CameraGroup:Button({
    Name="Reset Camera Zoom", Icon="rotate-ccw",
    Tooltip="Resets camera zoom to default (40 studs).",
    Callback=function()
        plr.CameraMaxZoomDistance=40; plr.CameraMinZoomDistance=0.5; Library.Flags.CameraZoom=40
    end
})

local walkSpeedMethod  = "Normal"
local walkSpeedEnabled = false
local lastWalkSpeed    = 16

ToggleRefs.WalkSpeed = MovementGroup:Toggle({
    Name="Enable WalkSpeed", Flag="WalkSpeedEnabled", Default=false,
    Tooltip="Overrides your character's walk speed with the value below.",
    Callback=function(v)
        walkSpeedEnabled = v
        if not v then
            local hum = plr.Character and plr.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end
})
MovementGroup:Keybind({
    Name="WalkSpeed Toggle", Flag="WalkSpeedKey", Default=Enum.KeyCode.C,
    Tooltip="Keybind to toggle custom walk speed on/off.",
    Callback=function()
        if ToggleRefs.WalkSpeed then ToggleRefs.WalkSpeed:Set(not Library.Flags.WalkSpeedEnabled) end
    end
})
MovementGroup:Dropdown({
    Name="WalkSpeed Method", Flag="WalkSpeedMethod", Default="Normal",
    Items={"Normal","CFrame"},
    Tooltip="Normal uses Humanoid.WalkSpeed; CFrame moves the character directly.",
    Callback=function(v) walkSpeedMethod=v end
})
MovementGroup:Slider({
    Name="WalkSpeed Value", Flag="WalkSpeedValue", Min=16, Max=500, Default=16, Suffix=" studs/s",
    Tooltip="The walk speed value to apply when WalkSpeed is enabled.",
    Callback=function(v) lastWalkSpeed=v end
})

MovementGroup:Divider()

MovementGroup:Slider({
    Name="JumpPower", Flag="JumpPower", Min=0, Max=1000, Default=50, Suffix="",
    Tooltip="Sets your character's jump power.",
    Callback=function(v)
        local hum = plr.Character and plr.Character:FindFirstChild("Humanoid")
        if hum then hum.JumpPower=v; hum.UseJumpPower=true end
    end
})

MovementGroup:Slider({
    Name="Gravity", Flag="GravityValue", Min=0, Max=500, Default=196.2, Suffix=" studs/s²",
    Tooltip="Controls the game's gravity. Lower values make you fall slower.",
    Callback=function(v) Workspace.Gravity=v end
})

RunService.Heartbeat:Connect(function()
    if walkSpeedEnabled then
        local hum = plr.Character and plr.Character:FindFirstChild("Humanoid")
        if not hum then return end
        if walkSpeedMethod == "CFrame" then
            if hum.WalkSpeed ~= 16 then hum.WalkSpeed = 16 end
            local dir = hum.MoveDirection
            if dir.Magnitude > 0 then
                plr.Character:TranslateBy(dir.Unit * (lastWalkSpeed / 100))
            end
        else
            if hum.WalkSpeed ~= lastWalkSpeed then hum.WalkSpeed = lastWalkSpeed end
        end
    end
end)

plr.CharacterAdded:Connect(function()
    Workspace.Gravity = Library.Flags.GravityValue or 196.2
end)

local VisualsMain    = VisualsPage:Section({Name="Main",          Icon="monitor",    Side=1})
local VisualsAmbient = VisualsPage:Section({Name="Ambient",       Icon="sun",        Side=1})
local VisualsESP     = VisualsPage:Section({Name="ESP",           Icon="crosshair",  Side=2})
local VisualsLighting= VisualsPage:Section({Name="Lighting",      Icon="sun",        Side=2})
local VisualsWorld   = VisualsPage:Section({Name="World Effects", Icon="globe",      Side=2})

VisualsMain:Button({
    Name="Infinite Cash (Visual)", Icon="dollar-sign",
    Tooltip="Sets your cash display to maximum. Visual only — does not affect real money.",
    Callback=function()
        pcall(function()
            plr.PlayerGui.other["HUD Elements"].Left.CashBase.Cash.Amount.Text = 10^350-1
        end)
    end
})
VisualsMain:Label("Note: Visual only — not actual money.")

local DefaultLighting = {
    Ambient=Lighting.Ambient, OutdoorAmbient=Lighting.OutdoorAmbient,
    Brightness=Lighting.Brightness, ClockTime=Lighting.ClockTime,
    FogEnd=Lighting.FogEnd, GlobalShadows=Lighting.GlobalShadows,
    ExposureCompensation=Lighting.ExposureCompensation
}

local AmbientToggle = VisualsAmbient:Toggle({
    Name="Enable Ambient", Flag="AmbientToggle", Default=false,
    Tooltip="Overrides ambient lighting with a custom color.",
    Callback=function(v)
        if v then
            Lighting.Ambient = Library.Flags.AmbientColor or Color3.new(1,1,1)
            Lighting.OutdoorAmbient = Library.Flags.AmbientColor or Color3.new(1,1,1)
        else
            Lighting.Ambient = DefaultLighting.Ambient
            Lighting.OutdoorAmbient = DefaultLighting.OutdoorAmbient
        end
    end
})
AmbientToggle:Settings(200):Label("Ambient Color"):Colorpicker({
    Name="Ambient Color", Flag="AmbientColor", Default=Color3.new(1,1,1),
    Callback=function(c)
        if Library.Flags.AmbientToggle then
            Lighting.Ambient=c; Lighting.OutdoorAmbient=c
        end
    end
})

VisualsAmbient:Divider()

VisualsAmbient:Toggle({
    Name="Fullbright", Flag="Fullbright", Default=false,
    Tooltip="Maximizes lighting, removes shadows, fog, blur and atmosphere for best visibility.",
    Callback=function(v)
        if v then
            Lighting.Brightness = 10
            Lighting.ClockTime = 14
            Lighting.FogEnd = 1e9
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.ExposureCompensation = 1
            for _, obj in ipairs(Lighting:GetChildren()) do
                if obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect")
                or obj:IsA("DepthOfFieldEffect") or obj:IsA("SunRaysEffect")
                or obj:IsA("Atmosphere") then
                    obj.Enabled = false
                end
            end
        else
            Lighting.Brightness = DefaultLighting.Brightness
            Lighting.ClockTime = DefaultLighting.ClockTime
            Lighting.FogEnd = DefaultLighting.FogEnd
            Lighting.GlobalShadows = DefaultLighting.GlobalShadows
            Lighting.Ambient = DefaultLighting.Ambient
            Lighting.OutdoorAmbient = DefaultLighting.OutdoorAmbient
            Lighting.ExposureCompensation = DefaultLighting.ExposureCompensation or 0
            for _, obj in ipairs(Lighting:GetChildren()) do
                if obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect")
                or obj:IsA("DepthOfFieldEffect") or obj:IsA("SunRaysEffect")
                or obj:IsA("Atmosphere") then
                    obj.Enabled = true
                end
            end
        end
    end
})

local visuals  = {BoxESP=false,Tracers=false,Names=false,Distance=false}
local drawings = {}
local function clearESP(p)
    if drawings[p] then
        for _, v in pairs(drawings[p]) do pcall(function() v:Remove() end) end
        drawings[p] = nil
    end
end
local function createESP(p)
    if p == Players.LocalPlayer then return end
    local box = Drawing.new("Square"); box.Thickness=1; box.Filled=false
    local tracer = Drawing.new("Line"); tracer.Thickness=1
    local name = Drawing.new("Text"); name.Size=13; name.Center=true; name.Outline=true
    local dist = Drawing.new("Text"); dist.Size=12; dist.Center=true; dist.Outline=true
    drawings[p] = {box, tracer, name, dist}
end
for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(clearESP)

RunService.RenderStepped:Connect(function()
    for p, objs in pairs(drawings) do
        local char = p.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Health>0 then
            local pos, vis = camera:WorldToViewportPoint(hrp.Position)
            if vis then
                local sz = Vector2.new(2000/pos.Z, 3000/pos.Z)
                objs[1].Visible=visuals.BoxESP;   objs[1].Size=sz; objs[1].Position=Vector2.new(pos.X-sz.X/2, pos.Y-sz.Y/2)
                objs[2].Visible=visuals.Tracers;  objs[2].From=Vector2.new(camera.ViewportSize.X/2,camera.ViewportSize.Y); objs[2].To=Vector2.new(pos.X,pos.Y)
                objs[3].Visible=visuals.Names;    objs[3].Text=p.Name;  objs[3].Position=Vector2.new(pos.X,pos.Y-sz.Y/2-14)
                objs[4].Visible=visuals.Distance; objs[4].Text=math.floor((camera.CFrame.Position-hrp.Position).Magnitude).."m"; objs[4].Position=Vector2.new(pos.X,pos.Y+sz.Y/2+2)
            else for _,o in ipairs(objs) do o.Visible=false end end
        else for _,o in ipairs(objs) do o.Visible=false end end
    end
end)

VisualsESP:Toggle({Name="Box ESP",   Flag="BoxESP",   Tooltip="Draws a box around players.", Callback=function(v) visuals.BoxESP=v    end})
VisualsESP:Toggle({Name="Tracers",   Flag="Tracers",  Tooltip="Draws tracer lines from screen center to players.", Callback=function(v) visuals.Tracers=v   end})
VisualsESP:Toggle({Name="Names",     Flag="Names",    Tooltip="Shows player names above their characters.", Callback=function(v) visuals.Names=v     end})
VisualsESP:Toggle({Name="Distance",  Flag="Distance", Tooltip="Shows distance in studs to each player.", Callback=function(v) visuals.Distance=v  end})
VisualsESP:Divider()

local ChamsEnabled, ChamsConns = false, {}
VisualsESP:Toggle({
    Name="Players Chams", Flag="PlayersChams", Default=false,
    Tooltip="Highlights other players with a blue outline visible through walls.",
    Callback=function(v)
        ChamsEnabled = v
        for _, p in ipairs(Players:GetPlayers()) do
            if p == Players.LocalPlayer then continue end
            if p.Character then
                if v then
                    for _, part in ipairs(p.Character:GetDescendants()) do
                        if part:IsA("BasePart") and not part:FindFirstChild("PlayerCham") then
                            local h = Instance.new("Highlight"); h.Name="PlayerCham"
                            h.FillColor=Color3.fromRGB(0,100,255); h.OutlineColor=Color3.fromRGB(0,200,255)
                            h.FillTransparency=0.3; h.OutlineTransparency=0
                            h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; h.Parent=part
                        end
                    end
                else
                    for _, obj in ipairs(p.Character:GetDescendants()) do
                        if obj:IsA("Highlight") and obj.Name=="PlayerCham" then obj:Destroy() end
                    end
                end
            end
            if v then
                ChamsConns[p] = p.CharacterAdded:Connect(function(char)
                    task.wait(0.5)
                    if not ChamsEnabled then return end
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and not part:FindFirstChild("PlayerCham") then
                            local h=Instance.new("Highlight"); h.Name="PlayerCham"
                            h.FillColor=Color3.fromRGB(0,100,255); h.OutlineColor=Color3.fromRGB(0,200,255)
                            h.FillTransparency=0.3; h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; h.Parent=part
                        end
                    end
                end)
            else
                if ChamsConns[p] then ChamsConns[p]:Disconnect(); ChamsConns[p]=nil end
            end
        end
    end
})

VisualsLighting:Toggle({Name="No Shadows", Flag="NoShadows", Tooltip="Disables global shadows for a cleaner look.", Callback=function(v) Lighting.GlobalShadows=not v end})
VisualsWorld:Toggle({
    Name="X-Ray", Flag="XRay",
    Tooltip="Makes all non-character parts semi-transparent so you can see through them.",
    Callback=function(v)
        for _, p in ipairs(Workspace:GetDescendants()) do
            if p:IsA("BasePart") and not p:IsDescendantOf(plr.Character) then
                p.LocalTransparencyModifier = v and 0.7 or 0
            end
        end
    end
})

local ServerMain = ServerPage:Section({Name="Main",        Icon="terminal",    Side=1})
local ServerInfo = ServerPage:Section({Name="Server Info", Icon="bar-chart-2", Side=2})

ServerMain:Button({
    Name="Server Hop", Icon="shuffle",
    Tooltip="Finds and teleports you to a different server with an open slot.",
    Callback=function()
        local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Desc&limit=100"
        local Next
        repeat
            local ok, raw = pcall(game.HttpGet, game, url..((Next and "&cursor="..Next) or ""))
            if not ok then break end
            local data = HttpService:JSONDecode(raw)
            for _, v in next, data.data do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then
                    local s = pcall(TeleportService.TeleportToPlaceInstance, TeleportService, PlaceId, v.id, plr)
                    if s then return end
                end
            end
            Next = data.nextPageCursor
        until not Next
    end
})

ServerMain:Button({
    Name="Join Smallest Server", Icon="users",
    Tooltip="Teleports you to the least populated server.",
    Callback=function()
        local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local ok, raw = pcall(game.HttpGet, game, url)
        if not ok then return end
        local Server = HttpService:JSONDecode(raw).data[1]
        if Server then TeleportService:TeleportToPlaceInstance(PlaceId, Server.id, plr) end
    end
})

ServerMain:Button({
    Name="Rejoin Server", Icon="refresh-cw",
    Tooltip="Rejoins the current server.",
    Callback=function() TeleportService:TeleportToPlaceInstance(PlaceId, game.JobId, plr) end
})

ServerMain:Divider()

local JobIdInput = ServerMain:Textbox({Flag="JobIdInput", Default="", Numeric=false, Placeholder="Enter JobId here...", Finished=false})
ServerMain:Button({
    Name="Join by JobId", Icon="log-in",
    Tooltip="Teleports to a specific server by its JobId.",
    Callback=function()
        local val = Library.Flags.JobIdInput
        if not val or val == "" then Library:Notification({Title="Error", Description="Please enter a JobId.", Duration=3, Icon="97594400820219"}); return end
        if #val ~= 36 or not val:match("^[a-f0-9%-]+$") then Library:Notification({Title="Invalid", Description="Not a valid JobId format.", Duration=3, Icon="97594400820219"}); return end
        TeleportService:TeleportToPlaceInstance(PlaceId, val, plr)
    end
})
ServerMain:Button({
    Name="Copy JobId", Icon="copy",
    Tooltip="Copies the current server's JobId to clipboard.",
    Callback=function()
        pcall(setclipboard, game.JobId)
        Library:Notification({Title="Copied", Description="Current JobId copied.", Duration=2, Icon="97594400820219"})
    end
})

local PlayersLabel = ServerInfo:Label("Players: 0 / 0")
local PlaceIdLabel = ServerInfo:Label("PlaceId: "..game.PlaceId)
local PingLabel    = ServerInfo:Label("Ping: … ms")
local UptimeLabel  = ServerInfo:Label("Session Time: 0s")

local startTime = os.clock()
task.spawn(function()
    while true do
        task.wait(1)
        PlayersLabel:SetText(("Players: %d / %d"):format(#Players:GetPlayers(), Players.MaxPlayers))
        local ping = 0
        pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        PingLabel:SetText("Ping: "..ping.." ms")
        local up = math.floor(os.clock()-startTime)
        local h,m,s = math.floor(up/3600), math.floor((up%3600)/60), up%60
        UptimeLabel:SetText(h>0 and ("Session: %dh %dm %ds"):format(h,m,s) or ("Session: %dm %ds"):format(m,s))
    end
end)

local SettingsPage = Library:CreateSettingsPage(Window, KeybindList)

local queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport
    or (fluxus and fluxus.queue_on_teleport) or (krnl and krnl.queue_on_teleport)
    or (delta and delta.queue_on_teleport)
local autoexec_script = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/samuraa1/Samuraa1-Hub/refs/heads/main/RT.lua'))()]]

local ScriptSection = SettingsPage:Section({Name="Script", Icon="code", Side=1})
ScriptSection:Toggle({
    Name    = "Auto Execute on Teleport",
    Flag    = "AutoExec",
    Default = false,
    Tooltip = "Re-executes the script automatically after server teleport.",
    Callback= function(v)
        if v and queueteleport then queueteleport(autoexec_script) end
    end
})

ScriptSection:Divider()

local FeedbackSection = SettingsPage:Section({Name="Feedback", Icon="message-circle", Side=1})
local FeedbackInput = FeedbackSection:Textbox({
    Flag="FeedbackText", Default="", Numeric=false,
    Placeholder="Type your message here...", Finished=false
})
FeedbackSection:Button({
    Name="Send Feedback", Icon="send",
    Tooltip="Sends your feedback message to the developer webhook.",
    Callback=function()
        local msg = Library.Flags.FeedbackText
        if not msg or #msg == 0 then
            Library:Notification({Title="Error", Description="Please type a message first.", Duration=3, Icon="97594400820219"})
            return
        end
        Library:Notification({Title="Sending…", Description="Sending your feedback…", Duration=2, Icon="97594400820219"})
        local ok = SendFeedback(msg)
        if ok then
            Library:Notification({Title="Thank you!", Description="Feedback sent successfully!", Duration=3, Icon="97594400820219"})
            FeedbackInput:Set("")
        else
            Library:Notification({Title="Failed", Description="Could not send feedback. Check your network.", Duration=4, Icon="97594400820219"})
        end
    end
})

local ActionsSection = SettingsPage:Section({Name="Actions", Icon="settings-2", Side=2})
ActionsSection:Button({
    Name    = "Unload Script",
    Icon    = "x-circle",
    Tooltip = "Unloads the script and closes the UI.",
    Callback= function() Library:Unload() end
})

Window:Init()

pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/samuraa1/Samuraa1-Hub/refs/heads/main/RT-Executions.lua"))()
end)
