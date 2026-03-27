# MentalityUI Rewrite

Modern Roblox UI library (Luau) with sidebar tabs, dashboard page, blur, themes, configs, and a built-in settings tab.  
Creator: **samet** — [Discord](https://discord.gg/VhvTd5HV8d)

---

## Preview

<img width="1365" height="782" alt="Preview" src="https://github.com/user-attachments/assets/37af0c29-7f6d-43b0-b509-f98531f94d96" />
<img width="364" height="605" alt="Preview" src="https://github.com/user-attachments/assets/ddf62c2b-75b9-4837-9861-273e56ffd2fd" />
<img width="421" height="255" alt="Preview" src="https://github.com/user-attachments/assets/47bff499-7fe8-4ea0-8212-a8d3458c6403" />
<img width="400" height="196" alt="Preview" src="https://github.com/user-attachments/assets/d03796b8-88b8-4e2a-bbd4-8499e77c98c2" />
<img width="247" height="315" alt="Preview" src="https://github.com/user-attachments/assets/823075ed-25a9-4c82-96dc-4964b7045545" />
<img width="709" height="707" alt="Preview" src="https://github.com/user-attachments/assets/e8ae94ca-e40c-498b-96e0-c3555153d8d5" />

---

## Features

| Area | Description |
|------|-------------|
| **Window** | Left sidebar, two-column sections, resize, minimize, floating logo toggle |
| **Dashboard** | Welcome block, stats, Discord/links, quick-access cards |
| **Elements** | Toggle, Slider (editable value), Dropdown (optional **search**), Button, Label, Colorpicker, Keybind, Textbox, Divider |
| **Theme** | `Library.Theme`, accent gradient, `ThemeManager` presets + save custom JSON |
| **Configs** | Save/load/delete configs when `writefile` / `readfile` exist |
| **Settings UI** | Accent, transparency, DPI, floating button, custom cursor, keybind list, menu key |

Raw API mirror: see [`Documentation.lua`](Documentation.lua) (comment block).

---

## Installation

Use your executor’s HTTP loader (replace `main` if you use another branch):

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/samuraa1/MentalityUI/main/Library.lua"
))()
```

Optional modules (same repository):

```lua
local SaveManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/samuraa1/MentalityUI/main/SaveManager.lua"
))()

local ThemeManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/samuraa1/MentalityUI/main/ThemeManager.lua"
))()
```

---

## Quick start

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/samuraa1/MentalityUI/main/Library.lua"))()

local Window = Library:CreateWindow({
    Title    = "My Hub",
    SubTitle = "Game name",
    Logo     = "1234567890", -- rbxassetid number only
})

Window:Category("Main")
local Main = Window:Page({ Name = "Main", Icon = "gamepad-2" })

local Left = Main:Section({ Name = "Features", Icon = "zap", Side = 1 })

Left:Toggle({
    Name     = "Example",
    Flag     = "ExampleToggle",
    Default  = false,
    Callback = function(v) end,
})

local KeybindList = Library:CreateKeybindList() -- optional
Library:CreateSettingsPage(Window, KeybindList)

Window:Init()
```

---

## Window API

### `Library:CreateWindow(options)`

| Field | Type | Description |
|--------|------|-------------|
| `Title` | string | Title in the header |
| `SubTitle` | string? | Subtitle under the title |
| `Logo` | string? | Image asset id (digits only, no `rbxassetid://`) |
| `MenuKey` | Enum.KeyCode? | Key to toggle UI (overridable in settings) |

### Methods

| Method | Description |
|--------|-------------|
| `Window:Page({ Name, Icon })` | Normal tab page (`Icon`: Lucide name or asset id) |
| `Window:DashboardPage({ ... })` | Full dashboard tab |
| `Window:Category(name)` | Sidebar category label |
| `Window:TabDivider()` | Horizontal divider in the tab list |
| `Window:SetOpen(bool)` | Show / hide the main frame |
| `Window:Toggle()` | Toggle open state |
| `Window:Init()` | **Call after** building pages (activates first tab, tweens) |

---

## Dashboard page

```lua
local Dash = Window:DashboardPage({
    Name            = "Dashboard",
    Icon            = "layout-dashboard",
    WelcomeText     = "WELCOME TO",
    HubName         = "MY HUB",
    StatusText      = "subtitle",
    Badge           = "PLAYER",
    GameName        = "GAME",
    GameDescription = "Description text",
    Links = {
        { Icon = "copy", Tooltip = "Copy", Callback = function() end },
    },
    Stats = {
        { Name = "PING", Icon = "wifi", GetValue = function() return "0 ms" end },
    },
    Credits = {
        { Name = "Author", Role = "Dev" },
    },
    QuickAccess = {},
})

Dash:AddCard({ Name = "MAIN", Description = "…", Icon = "gamepad-2", Tab = MainPage })
```

---

## Sections & elements

Create a section from a page:

```lua
local Section = Page:Section({ Name = "Name", Icon = "icon-name", Side = 1 })
-- Side: 1 = left column, 2 = right column
```

### Toggle

```lua
Section:Toggle({
    Name     = "Auto farm",
    Flag     = "AutoFarm",
    Default  = false,
    Tooltip  = "Optional",
    Callback = function(value) end,
})
```

### Slider

```lua
Section:Slider({
    Name     = "Speed",
    Flag     = "Speed",
    Min      = 0,
    Max      = 100,
    Default  = 16,
    Decimals = 0,
    Suffix   = "",
    Callback = function(value) end,
})
```

The value label can be **clicked** to type a number manually.

### Dropdown

```lua
Section:Dropdown({
    Name     = "Mode",
    Flag     = "Mode",
    Items    = { "A", "B", "C" },
    Default  = "A",
    Search   = true,  -- optional search box
    Callback = function(value) end,
})
```

### Other

- `Section:Button({ Name, Icon?, Callback })`
- `Section:Label("text")` — chain `:Colorpicker({ ... })` if needed
- `Section:Keybind({ Name, Flag, Default = Enum.KeyCode, Callback })`
- `Section:Textbox({ Flag, Placeholder, Finished, Callback })`
- `Section:Divider()` / `Section:Divider("Label")`

---

## Built-in settings page

```lua
local KeybindList = Library:CreateKeybindList()
Library:CreateSettingsPage(Window, KeybindList)
```

Includes accent colors, font weight, **background transparency**, **DPI scale**, **show floating toggle button**, **custom cursor**, keybind list visibility, **Toggle UI** keybind, and **configs** (when file API is available).

---

## ThemeManager

```lua
local TM = loadstring(game:HttpGet("https://raw.githubusercontent.com/samuraa1/MentalityUI/main/ThemeManager.lua"))()
TM:SetLibrary(Library)
TM:SetFolder("MyHubConfigs") -- folder for custom saved themes
TM:BuildThemeSection(SettingsPage)
```

Built-in presets live in `ThemeManager.lua`; you can **Save** current accent pair as a named JSON theme.

---

## Flags

- `Library.Flags` — table of current values keyed by `Flag` names.
- Use unique flags per control so configs do not collide.

---

## Cleanup

```lua
Library:Unload()
```

Disconnects connections, destroys UI, restores the default mouse cursor.

---

## Repository layout

| File | Role |
|------|------|
| `Library.lua` | Main UI library |
| `SaveManager.lua` | Optional save helpers |
| `ThemeManager.lua` | Theme list + apply/save |
| `Documentation.lua` | Duplicate API reference (Lua comment block) |

---

## Security note

Do **not** commit GitHub personal access tokens or script sources you intend to keep private. Use env vars or local-only upload scripts.

---

## Credits

- **MentalityUI Rewrite** — samet  
- Community scripts using this library — respective authors
