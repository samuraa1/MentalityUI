# MentalityUI

UI library for Roblox executor scripts. You get a window with a sidebar, pages, toggles, sliders, a dashboard, themes, and config saving.

Library by [samet](https://discord.gg/VhvTd5HV8d). This copy is maintained at [samuraa1/MentalityUI](https://github.com/samuraa1/MentalityUI).

If you want a full script you can run, open [`Example.lua`](Example.lua). This page is the short version.

## Preview

<p align="center">
  <img width="780" alt="Preview" src="https://github.com/user-attachments/assets/37af0c29-7f6d-43b0-b509-f98531f94d96" />
</p>

<details>
<summary>More screenshots</summary>

<img width="364" alt="Preview" src="https://github.com/user-attachments/assets/ddf62c2b-75b9-4837-9861-273e56ffd2fd" />
<img width="421" alt="Preview" src="https://github.com/user-attachments/assets/47bff499-7fe8-4ea0-8212-a8d3458c6403" />
<img width="400" alt="Preview" src="https://github.com/user-attachments/assets/d03796b8-88b8-4e2a-bbd4-8499e77c98c2" />

</details>

## Load it

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/samuraa1/MentalityUI/main/Library.lua"
))()
```

Themes and configs already exist inside the library. Load these two only if you want the extra sections (preset list, custom theme files, autoload):

```lua
local ThemeManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/samuraa1/MentalityUI/main/ThemeManager.lua"
))()

local SaveManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/samuraa1/MentalityUI/main/SaveManager.lua"
))()
```

## Smallest script

Build the window, add a page, add a section, add a toggle, then call `Init`. `Init` has to be last, after every page is created.

```lua
local Window = Library:Window({
    Name = "My Hub",
    SubName = "Game name",
    Logo = "1234567890", -- asset id, numbers only
})

Window:Category("Main")

local Main = Window:Page({
    Name = "Main",
    Icon = "gamepad-2", -- Lucide icon name, or an asset id
})

local Section = Main:Section({
    Name = "Features",
    Icon = "zap",
    Side = 1, -- 1 is the left column, 2 is the right
})

Section:Toggle({
    Name = "Example",
    Flag = "ExampleToggle", -- unique name, used by configs
    Default = false,
    Callback = function(on)
        print(on)
    end,
})

local KeybindList = Library:KeybindList("Keybinds") -- optional
Library:CreateSettingsPage(Window, KeybindList)

Window:Init()
```

The logo next to the title is your image. Themes do not recolor it.

## Window

```lua
local Window = Library:Window({
    Name = "My Hub",
    SubName = "Subtitle under the title",
    Logo = "1234567890",
    -- Size = UDim2.fromOffset(940, 720),
    -- MobileScale = 0.8,
})
```

| Call | What it does |
|---|---|
| `Window:Category("Main")` | A label in the sidebar |
| `Window:TabDivider()` | A line between sidebar groups |
| `Window:Page({ Name, Icon })` | A normal tab |
| `Window:DashboardPage({ ... })` | The welcome tab |
| `Window:SetOpen(true/false)` | Show or hide the window |
| `Window:Toggle()` | Open if closed, close if open |
| `Window:Init()` | Call this once, at the end |

## Dashboard

A dashboard is just another tab. `AddCard` jumps to a page you already created. Create the pages first, then the cards, then `Init`.

```lua
local Dash = Window:DashboardPage({
    Name = "Dashboard",
    Icon = "layout-dashboard",
    WelcomeText = "WELCOME TO",
    HubName = "MY HUB",
    StatusText = "ready",
    Badge = "PLAYER",
    GameName = "GAME",
    GameDescription = "One line about the game.",
    Links = {
        { Icon = "copy", Tooltip = "Copy", Callback = function() end },
    },
    Stats = {
        { Name = "PING", Icon = "wifi", GetValue = function() return "0 ms" end },
    },
    Credits = {
        { Name = "Author", Role = "Dev" },
    },
})

Dash:AddCard({
    Name = "MAIN",
    Description = "Open the main tab",
    Icon = "gamepad-2",
    Tab = MainPage,
})
```

## Sections and controls

```lua
local Section = Page:Section({
    Name = "Name",
    Icon = "zap",
    Side = 1,
})
```

Toggle. `Settings` is an optional little panel that opens from the gear.

```lua
local Toggle = Section:Toggle({
    Name = "Feature",
    Flag = "Feature",
    Default = false,
    Tooltip = "Shows on hover",
    Callback = function(on) end,
})

local Sub = Toggle:Settings(260)
Sub:Slider({
    Name = "Extra",
    Flag = "Extra",
    Min = 0,
    Max = 10,
    Default = 5,
    Callback = function(value) end,
})
```

Slider, dropdown, list.

```lua
Section:Slider({
    Name = "Speed",
    Flag = "Speed",
    Min = 0,
    Max = 100,
    Default = 16,
    Decimals = 0,
    Suffix = "",
    Callback = function(value) end,
})

Section:Dropdown({
    Name = "Mode",
    Flag = "Mode",
    Items = { "A", "B" },
    Default = "A",
    Search = true,
    Callback = function(value) end,
})

Section:Listbox({
    Flag = "List",
    Items = { "One", "Two" },
    Default = "One",
    Multi = false,
    Callback = function(value) end,
})
```

The rest:

- `Section:Button({ Name, Icon, Callback })`
- `Section:Label("text")` and then `:Colorpicker({ ... })` on that label
- `Section:Keybind({ Name, Flag, Default = Enum.KeyCode.RightShift, Callback })`
- `Section:Textbox({ Flag, Placeholder, Finished, Callback })`
- `Section:Divider()` or `Section:Divider("Label")`

`Flag` is the save name. Two controls must not share one. You can read the current value any time from `Library.Flags.YourFlag`.

On a slider, click the number if you want to type it.

`Finished = true` on a textbox means the value updates when you press Enter. `Finished = false` updates on every key.

## Settings page

```lua
local KeybindList = Library:KeybindList("Keybinds")
local Settings = Library:CreateSettingsPage(Window, KeybindList)
```

That page has the theme list, accent colors, font, transparency, DPI, the floating button, the custom cursor, the menu key, and a config list (if the executor can read and write files).

Pick **Halloween** in the theme list for the orange window. Pumpkins, ghosts, and a few other icons fall inside the window. Any other theme goes back to the normal dark look and the icons stop.

## Themes and configs

You do not have to load ThemeManager or SaveManager. The settings page already has a theme dropdown and config buttons.

Use ThemeManager when you want a theme section with presets, a default theme on startup, and saving your own colors:

```lua
local TM = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/samuraa1/MentalityUI/main/ThemeManager.lua"
))()

TM:SetLibrary(Library)
TM:SetFolder("MyHubThemes")
TM:BuildThemeSection(Settings)
```

Use SaveManager when you want a second config section, with autoload:

```lua
local SM = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/samuraa1/MentalityUI/main/SaveManager.lua"
))()

SM:SetLibrary(Library)
SM:SetFolder("MyHubConfigs")
SM:BuildConfigSection(Settings)
```

**Set selected as autoload** loads that config the next time the UI starts. Colors, keybinds, and multi-selects are saved with the rest.

## Notifications

```lua
Library:Notification({
    Title = "Done",
    Description = "Message",
    Duration = 3,
    Icon = "1234567890",
})
```

## Closing the UI

`Library:Unload()` removes the windows, disconnects what the library created, and puts the normal mouse cursor back. Call it when your script stops.

## Files

| File | What it is |
|---|---|
| `Library.lua` | The UI |
| `ThemeManager.lua` | Extra theme section |
| `SaveManager.lua` | Extra config section |
| `Example.lua` | A full example |
| `README.md` | This page |

## Credits

- MentalityUI — samet
- Scripts that use this library — their authors
