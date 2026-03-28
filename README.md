# 🧠 MentalityUI Rewrite

Modern Roblox UI library (**Luau**): sidebar, two-column pages, **dashboard**, blur, **themes**, **configs**, and a built-in **settings** tab.

## ✨ Recent highlights

- **Sidebar** — blur on the tab column was removed to fix a bottom-left seam; tab corner reads cleaner with the main panel blur only.
- **Keybinds** — short debounce on key events + debounced menu toggle; fewer double-fires.
- **Floating button & draggable panels** — drag uses a **grab offset** so the control stays under the cursor; smooth interpolation on the floating toggle.
- **Notifications** — header + wrapped body + **timer bar** under the text (shrinks smoothly).
- **Mobile** — taller sliders with wrapped names; optional **Show keybind rows** in settings (default off on touch).
- **Fonts** — weights include **Thin** and **ExtraLight**; default weight remains **Light**.
- **PinToBottom** — `Library:CreateSettingsPage(Window, list, { PinToBottom = true })` or `Window` field `PinToBottom` to pin **UI Settings** last in the sidebar.

- **Author (library):** samet — [Discord](https://discord.gg/VhvTd5HV8d)
- **Maintained fork / raw files:** [samuraa1/MentalityUI](https://github.com/samuraa1/MentalityUI)

---

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

---

## What you get

| | Feature |
|---|--------|
| **Window** | Sidebar tabs, resize, minimize, floating logo button |
| **Dashboard** | Welcome block, stats, quick links, **AddCard** to jump tabs |
| **Widgets** | Toggle (with optional **Settings** sub-panel), Slider, Dropdown (**search**), Listbox, Button, Label + Colorpicker, Keybind, Textbox, Divider |
| **Theme** | `Library.Theme`, accent + gradient, **ThemeManager** presets & JSON save |
| **Configs** | Built-in list when `writefile` / `readfile` exist |
| **Settings UI** | Accent, font weight, transparency, **DPI**, floating button, custom cursor, keybind list, menu key |

📘 **Full commented script:** [`Example.lua`](Example.lua) — copy/paste reference for almost every API used in production hubs.

---

## Installation

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/samuraa1/MentalityUI/main/Library.lua"
))()
```

Optional modules (same repo):

```lua
local SaveManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/samuraa1/MentalityUI/main/SaveManager.lua"
))()

local ThemeManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/samuraa1/MentalityUI/main/ThemeManager.lua"
))()
```

---

## Quick start (minimal)

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/samuraa1/MentalityUI/main/Library.lua"
))()

local Window = Library:Window({
    Name    = "My Hub",
    SubName = "Game name",
    Logo    = "1234567890", -- rbxasset id, digits only
})

Window:Category("Main")
local Main = Window:Page({ Name = "Main", Icon = "gamepad-2" })

local Section = Main:Section({ Name = "Features", Icon = "zap", Side = 1 })

Section:Toggle({
    Name     = "Example",
    Flag     = "ExampleToggle",
    Default  = false,
    Callback = function(v) print(v) end,
})

local KeybindList = Library:KeybindList("Keybinds") -- optional; pass nil on touch-only UIs if you prefer

Library:CreateSettingsPage(Window, KeybindList, { PinToBottom = true })

Window:Init() -- required when everything is built
```

---

## Window API

### `Library:Window(options)`

| Field | Meaning |
|--------|---------|
| `Name` | Title in the header |
| `SubName` | Subtitle under the title |
| `Logo` | Image **asset id** (numbers only, no `rbxassetid://`) |
| `Size` | Optional `UDim2` (defaults are set for you) |
| `MobileScale` | Optional `UIScale` for touch |

### Methods

| Method | |
|--------|---|
| `Window:Page({ Name, Icon })` | Normal tab (`Icon`: Lucide name **or** rbx asset id string) |
| `Window:DashboardPage({ ... })` | Full dashboard tab |
| `Window:Category(name)` | Sidebar group label |
| `Window:TabDivider()` | Thin divider between sidebar groups |
| `Window:SetOpen(bool)` | Show / hide UI |
| `Window:Toggle()` | Flip open state |
| `Window:Init()` | **Call last** — activates first tab, runs tweens |

---

## Dashboard

```lua
local Dash = Window:DashboardPage({
    Name            = "Dashboard",
    Icon            = "layout-dashboard",
    WelcomeText     = "WELCOME TO",
    HubName         = "MY HUB",
    StatusText      = "subtitle line",
    Badge           = "PLAYER",
    GameName        = "GAME",
    GameDescription = "Short description",
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

Dash:AddCard({ Name = "MAIN", Description = "Open main tab", Icon = "gamepad-2", Tab = MainPage })
```

---

## Sections & elements

```lua
local Section = Page:Section({ Name = "Name", Icon = "icon-name", Side = 1 })
-- Side: 1 = left column, 2 = right column
```

### Toggle (+ optional gear panel)

```lua
local T = Section:Toggle({
    Name     = "Feature",
    Flag     = "Feature",
    Default  = false,
    Tooltip  = "Optional",
    Callback = function(on) end,
})

local Sub = T:Settings(260) -- height of sub-panel
Sub:Slider({ Name = "Extra", Flag = "Extra", Min = 0, Max = 10, Default = 5, Callback = function() end })
```

### Slider / Dropdown / Listbox

```lua
Section:Slider({
    Name = "Speed", Flag = "Speed", Min = 0, Max = 100, Default = 16,
    Decimals = 0, Suffix = "", Callback = function(n) end,
})

Section:Dropdown({
    Name = "Mode", Flag = "Mode", Items = { "A", "B" },
    Default = "A", Search = true, Callback = function(v) end,
})

Section:Listbox({
    Flag = "List", Items = { "One", "Two" }, Default = "One",
    Multi = false, Callback = function(v) end,
})
```

### Other

- `Section:Button({ Name, Icon?, Callback })`
- `Section:Label("text")` — optional `:Colorpicker({ ... })`
- `Section:Keybind({ Name, Flag, Default = Enum.KeyCode, Callback })`
- `Section:Textbox({ Flag, Placeholder, Finished, Callback })`
- `Section:Divider()` / `Section:Divider("Label")`

Value labels on sliders can be **clicked** to type a number.

---

## Built-in settings page

```lua
local KeybindList = Library:KeybindList("Keybinds")
Library:CreateSettingsPage(Window, KeybindList, { PinToBottom = true })
```

- **`PinToBottom`** — optional table: `{ PinToBottom = true }` pins **UI Settings** to the **bottom** of the sidebar.

Includes accent + gradient, font weight, background transparency, DPI, floating toggle button, custom cursor, keybind list toggle, menu / UI toggle keybinds, and config list when the file API exists.

---

## ThemeManager

```lua
local TM = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/samuraa1/MentalityUI/main/ThemeManager.lua"
))()
TM:SetLibrary(Library)
TM:SetFolder("MyHubThemes")
TM:BuildThemeSection(SettingsPage)
```

---

## SaveManager (optional)

```lua
local SM = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/samuraa1/MentalityUI/main/SaveManager.lua"
))()
SM:SetLibrary(Library)
SM:SetFolder("MyHubConfigs")
SM:BuildConfigSection(SettingsPage)
```

---

## Notifications

```lua
Library:Notification({
    Title = "Done",
    Description = "Message",
    Duration = 3,
    Icon = "1234567890", -- rbx asset id
})
```

---

## Flags & cleanup

- `Library.Flags` — current values keyed by your `Flag` strings. Use **unique** names so configs do not collide.
- `Library:Unload()` — destroys UI, disconnects hooks, restores default mouse icon.

---

## Repository layout

| File | Role |
|------|------|
| `Library.lua` | Main UI |
| `SaveManager.lua` | Save / load / config list helpers |
| `ThemeManager.lua` | Preset themes + custom JSON |
| `Example.lua` | **Commented reference script** (recommended) |
| `README.md` | This file |

---

## Credits

- **MentalityUI Rewrite** — samet  
- Scripts using this library — their respective authors
