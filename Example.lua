--[[
  ═══════════════════════════════════════════════════════════════════════════
  📘 MentalityUI — Example & API reference (samuraa1/MentalityUI)
  ═══════════════════════════════════════════════════════════════════════════
  This script is a commented walkthrough. You can run it in a supported game
  with an HTTP-enabled executor. Replace Logo asset id with your own.

  Main docs: README.md on GitHub. This file mirrors common API calls inline.
  ═══════════════════════════════════════════════════════════════════════════
]]

-- ───────────────────────────────────────────────────────────────────────────
-- 1) Load the library (raw from GitHub — change branch if you fork)
-- ───────────────────────────────────────────────────────────────────────────
local LIB_URL = "https://raw.githubusercontent.com/samuraa1/MentalityUI/main/Library.lua"
local Library = loadstring(game:HttpGet(LIB_URL))()

-- Optional: same repo helpers (load only if you use them)
-- local SaveManager = loadstring(game:HttpGet(
--     "https://raw.githubusercontent.com/samuraa1/MentalityUI/main/SaveManager.lua"
-- ))()
-- local ThemeManager = loadstring(game:HttpGet(
--     "https://raw.githubusercontent.com/samuraa1/MentalityUI/main/ThemeManager.lua"
-- ))()

-- ───────────────────────────────────────────────────────────────────────────
-- 2) Window — root container (sidebar + pages)
--    Fields: Name, SubName, Logo (rbxasset id digits only), Size?, MobileScale?
-- ───────────────────────────────────────────────────────────────────────────
local Window = Library:Window({
    Name = "Example Hub",
    SubName = "MentalityUI",
    Logo = "97594400820219",
})

-- Floating keybind list (optional). Omit on pure touch if you prefer.
local KeybindList = Library:KeybindList("Keybinds")

-- ───────────────────────────────────────────────────────────────────────────
-- 3) Sidebar: categories + tab divider + normal pages
-- ───────────────────────────────────────────────────────────────────────────
Window:Category("Main")
Window:TabDivider()

local MainPage = Window:Page({ Name = "Main", Icon = "gamepad-2" })
local ExtraPage = Window:Page({ Name = "More", Icon = "layers" })

-- ───────────────────────────────────────────────────────────────────────────
-- 4) Dashboard tab (welcome, stats, link buttons, quick cards)
--    Build BEFORE Window:Init(). AddCard jumps to another Page.
-- ───────────────────────────────────────────────────────────────────────────
local Dash = Window:DashboardPage({
    Name = "Dashboard",
    Icon = "layout-dashboard",
    WelcomeText = "WELCOME TO",
    HubName = "EXAMPLE HUB",
    StatusText = "documentation build",
    Badge = "PLAYER",
    GameName = "YOUR GAME",
    GameDescription = "Short blurb under the game name.",
    Links = {
        {
            Icon = "copy",
            Tooltip = "Copy text to clipboard",
            Callback = function()
                pcall(function()
                    setclipboard("Hello from MentalityUI")
                end)
                Library:Notification({
                    Title = "Copied",
                    Description = "Clipboard updated.",
                    Duration = 2,
                    Icon = "97594400820219",
                })
            end,
        },
    },
    Stats = {
        {
            Name = "TIME",
            Icon = "clock",
            GetValue = function()
                return tostring(math.floor(workspace.DistributedGameTime)) .. "s"
            end,
        },
    },
    Credits = {
        { Name = "samet", Role = "Library" },
    },
    QuickAccess = {},
})

Dash:AddCard({
    Name = "MAIN",
    Description = "Toggles & sliders.",
    Icon = "gamepad-2",
    Tab = MainPage,
})

-- ───────────────────────────────────────────────────────────────────────────
-- 5) Sections — two columns: Side = 1 (left), Side = 2 (right)
-- ───────────────────────────────────────────────────────────────────────────
local Left = MainPage:Section({ Name = "Controls", Icon = "zap", Side = 1 })
local Right = MainPage:Section({ Name = "Inputs", Icon = "sliders-horizontal", Side = 2 })

-- Toggle — Flag must be unique across the whole UI (used for configs)
local MyToggle = Left:Toggle({
    Name = "Example toggle",
    Flag = "ExToggle",
    Default = false,
    Tooltip = "Hover text in UI",
    Callback = function(value)
        print("Toggle:", value)
    end,
})

-- Sub-panel attached to a toggle (optional)
local Sub = MyToggle:Settings(260)
Sub:Slider({
    Name = "Nested slider",
    Flag = "ExToggleSlider",
    Min = 0,
    Max = 10,
    Default = 5,
    Decimals = 0,
    Callback = function(v)
        print(v)
    end,
})

Left:Slider({
    Name = "Walk speed",
    Flag = "WalkSpeed",
    Min = 16,
    Max = 120,
    Default = 16,
    Decimals = 0,
    Suffix = " studs",
    Callback = function(v)
        local c = game.Players.LocalPlayer.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        if h then
            h.WalkSpeed = v
        end
    end,
})

Left:Dropdown({
    Name = "Mode",
    Flag = "ExMode",
    Items = { "A", "B", "C" },
    Default = "A",
    Search = true,
    Callback = function(v)
        print("Mode:", v)
    end,
})

Left:Button({
    Name = "Ping notification",
    Icon = "bell",
    Callback = function()
        Library:Notification({
            Title = "Hello",
            Description = "This is Library:Notification",
            Duration = 3,
            Icon = "97594400820219",
        })
    end,
})

Left:Divider()
Left:Divider("Optional divider label")

Right:Label("Plain label")
Right:Label("Label + colorpicker"):Colorpicker({
    Name = "Accent preview",
    Flag = "ExLabelColor",
    Default = Color3.fromRGB(100, 149, 255),
    Callback = function(c)
        print("Color", c)
    end,
})

Right:Keybind({
    Name = "Example keybind",
    Flag = "ExKeybind",
    Default = Enum.KeyCode.RightShift,
    Callback = function()
        print("Keybind fired")
    end,
})

Right:Textbox({
    Flag = "ExText",
    Placeholder = "Type here…",
    Finished = true,
    Callback = function(s)
        print("Textbox:", s)
    end,
})

Right:Listbox({
    Flag = "ExList",
    Items = { "One", "Two", "Three" },
    Default = "One",
    Multi = false,
    Callback = function(v)
        print("Listbox:", v)
    end,
})

-- ───────────────────────────────────────────────────────────────────────────
-- 6) Built-in settings page (accent, DPI, transparency, configs, …)
--    Third arg: { PinToBottom = true } keeps the tab last in the sidebar.
-- ───────────────────────────────────────────────────────────────────────────
local SettingsPage = Library:CreateSettingsPage(Window, KeybindList, { PinToBottom = true })

-- Example: ThemeManager section (uncomment if you loaded ThemeManager.lua)
--[[
local TM = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/samuraa1/MentalityUI/main/ThemeManager.lua"
))()
TM:SetLibrary(Library)
TM:SetFolder("MyHubThemes")
TM:BuildThemeSection(SettingsPage)
]]

-- Example: SaveManager config UI (uncomment if you loaded SaveManager.lua)
--[[
local SM = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/samuraa1/MentalityUI/main/SaveManager.lua"
))()
SM:SetLibrary(Library)
SM:SetFolder("MyHubConfigs")
SM:BuildConfigSection(SettingsPage)
]]

-- ───────────────────────────────────────────────────────────────────────────
-- 7) Extra page — placeholder for your game logic
-- ───────────────────────────────────────────────────────────────────────────
do
    local S = ExtraPage:Section({ Name = "Placeholder", Icon = "box", Side = 1 })
    S:Label("Add your game-specific toggles here.")
end

-- ───────────────────────────────────────────────────────────────────────────
-- 8) Flags — current values (for saves / logic)
--    Library.Flags["ExToggle"]  → boolean
--    Library.Flags["WalkSpeed"] → number
-- ───────────────────────────────────────────────────────────────────────────

-- ───────────────────────────────────────────────────────────────────────────
-- 9) Init — REQUIRED after all pages/sections are built
-- ───────────────────────────────────────────────────────────────────────────
Window:Init()

-- ───────────────────────────────────────────────────────────────────────────
-- 10) Cleanup — removes ScreenGuis, blur, cursor override
--     Call when your script unloads.
-- ───────────────────────────────────────────────────────────────────────────
-- Library:Unload()

return nil
