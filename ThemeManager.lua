local ThemeManager = {}
ThemeManager.__index = ThemeManager

local HttpService = game:GetService("HttpService")
local Library

local NOTIF_ICON = "97594400820219"

local function A(r, g, b, r2, g2, b2)
    return {
        Accent = Color3.fromRGB(r, g, b),
        AccentGradient = Color3.fromRGB(r2, g2, b2),
    }
end

local DEFAULT_THEMES = {
    Default = A(100, 149, 255, 70, 110, 200),
    Blue = A(100, 149, 255, 70, 110, 200),
    Dark = A(130, 130, 145, 80, 80, 95),
    Purple = A(160, 100, 255, 120, 70, 200),
    Cyan = A(60, 200, 230, 40, 160, 190),
    Green = A(80, 200, 120, 60, 160, 90),
    Red = A(220, 80, 80, 180, 50, 50),
    Orange = A(255, 160, 50, 220, 120, 30),
    Pink = A(255, 100, 180, 200, 60, 140),
    Flame = A(255, 90, 40, 255, 200, 60),
    Ice = A(180, 230, 255, 100, 180, 255),
    Gold = A(255, 215, 100, 200, 150, 50),
    Rose = A(255, 120, 150, 200, 60, 120),
    Mint = A(100, 220, 190, 50, 160, 140),
    Lavender = A(190, 160, 255, 130, 100, 220),
    Ocean = A(40, 140, 220, 20, 80, 160),
    Crimson = A(190, 40, 70, 120, 16, 36),
    Amber = A(255, 176, 40, 210, 120, 20),
    Lime = A(170, 230, 60, 90, 170, 30),
    Magenta = A(230, 70, 180, 150, 30, 120),
    Teal = A(40, 190, 170, 20, 120, 110),
    Indigo = A(90, 90, 220, 50, 50, 150),
    Sunset = A(255, 110, 70, 180, 60, 140),
    Emerald = A(40, 190, 110, 16, 120, 70),
    Sakura = A(255, 160, 190, 220, 90, 140),
    Midnight = A(120, 140, 255, 40, 50, 90),
    Toxic = A(180, 255, 60, 80, 180, 20),
    Coral = A(255, 120, 100, 200, 70, 70),
    Violet = A(140, 80, 255, 80, 40, 180),
    Arctic = A(200, 245, 255, 80, 170, 210),
    Cherry = A(220, 50, 90, 140, 20, 50),
    Neon = A(80, 255, 200, 40, 140, 255),
    Copper = A(210, 130, 70, 140, 70, 30),
    Peach = A(255, 180, 140, 230, 120, 90),
    Sky = A(120, 190, 255, 60, 130, 220),
    Wine = A(160, 50, 80, 90, 20, 40),
    Aqua = A(70, 230, 220, 30, 150, 170),
    Grape = A(150, 80, 200, 90, 40, 140),
    Halloween = {
        Full = true,
        Effect = "Halloween",
        ["Background"] = Color3.fromRGB(22, 12, 8),
        ["Background 2"] = Color3.fromRGB(14, 8, 5),
        ["Text"] = Color3.fromRGB(255, 236, 220),
        ["Outline"] = Color3.fromRGB(78, 40, 18),
        ["Section Top"] = Color3.fromRGB(62, 30, 12),
        ["Section Background"] = Color3.fromRGB(28, 14, 8),
        ["Section Background 2"] = Color3.fromRGB(38, 18, 10),
        ["Accent"] = Color3.fromRGB(255, 132, 36),
        ["AccentGradient"] = Color3.fromRGB(186, 62, 14),
        ["Element"] = Color3.fromRGB(46, 24, 12),
    },
}

local function CleanName(Name)
    Name = tostring(Name or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if Name == "" or Name:find("[/\\]") or Name:find("%.%.") then
        return nil
    end
    return Name
end

local function Notify(Title, Description)
    if Library and Library.Notification then
        Library:Notification({
            Title = Title,
            Description = Description,
            Duration = 2.5,
            Icon = NOTIF_ICON,
        })
    end
end

local function ReadColor(Raw)
    if typeof(Raw) == "Color3" then
        return Raw
    end
    if type(Raw) == "table" and Raw.r and Raw.g and Raw.b then
        return Color3.new(Raw.r, Raw.g, Raw.b)
    end
    return nil
end

function ThemeManager:SetLibrary(Lib)
    Library = Lib
    if Library and Library.Palettes then
        for Name, Data in DEFAULT_THEMES do
            if Library.Palettes[Name] == nil then
                Library.Palettes[Name] = Data
            end
        end
    end
end

function ThemeManager:SetFolder(FolderName)
    self.Folder = FolderName
    pcall(function()
        if not isfolder(FolderName) then
            makefolder(FolderName)
        end
    end)
end

function ThemeManager:GetDefaultThemePath()
    return (self.Folder or "ThemeManager") .. "/default_theme.txt"
end

function ThemeManager:Builtin(Name)
    if Library and Library.Palettes and Library.Palettes[Name] then
        return Library.Palettes[Name]
    end
    return DEFAULT_THEMES[Name]
end

function ThemeManager:SetDefaultThemeName(Name)
    Name = CleanName(Name)
    if not Name then
        return false
    end
    local Folder = self.Folder or "ThemeManager"
    local Ok, Err = pcall(function()
        if not isfolder(Folder) then
            makefolder(Folder)
        end
        writefile(self:GetDefaultThemePath(), Name)
    end)
    return Ok, Err
end

function ThemeManager:GetDefaultThemeName()
    local Path = self:GetDefaultThemePath()
    local Ok, Raw = pcall(function()
        if not isfile(Path) then
            return nil
        end
        return readfile(Path)
    end)
    if not Ok or not Raw then
        return nil
    end
    return CleanName(Raw)
end

local function SeasonalDefaultName()
    local Now = os.date("*t")
    if type(Now) ~= "table" then
        return nil
    end
    local Year, Month, Day = tonumber(Now.year), tonumber(Now.month), tonumber(Now.day)
    if not Year or not Month or not Day then
        return nil
    end
    if Year < 2026 or (Year == 2026 and (Month < 11 or (Month == 11 and Day <= 15))) then
        return "Halloween"
    end
    return nil
end

function ThemeManager:GetStartupThemeName()
    return self:GetDefaultThemeName() or SeasonalDefaultName()
end

function ThemeManager:ApplySavedDefault()
    local Name = self:GetStartupThemeName()
    if not Name then
        return false
    end
    return self:LoadTheme(Name)
end

function ThemeManager:GetThemePath(Name)
    return (self.Folder or "ThemeManager") .. "/" .. Name .. ".json"
end

function ThemeManager:ListThemes()
    local Map = {}
    local Source = (Library and Library.Palettes) or DEFAULT_THEMES
    for Name in Source do
        Map[Name] = true
    end
    for Name in DEFAULT_THEMES do
        Map[Name] = true
    end

    local Folder = self.Folder or "ThemeManager"
    local Ok, Files = pcall(function()
        if isfolder(Folder) then
            return listfiles(Folder)
        end
        return {}
    end)
    if Ok and Files then
        for _, File in ipairs(Files) do
            local Name = File:match("([^/\\]+)%.json$")
            if Name and Name ~= "default_theme" then
                Map[Name] = true
            end
        end
    end

    local List = {}
    for Name in Map do
        table.insert(List, Name)
    end
    table.sort(List)
    for Index, Name in ipairs(List) do
        if Name == "Default" then
            table.remove(List, Index)
            table.insert(List, 1, "Default")
            break
        end
    end
    return List
end

function ThemeManager:ApplyTheme(ThemeData, Name)
    if not Library or type(ThemeData) ~= "table" then
        return
    end
    if Library.ApplyPalette then
        local Palette = {
            Full = ThemeData.Full and true or false,
            Effect = ThemeData.Effect,
        }
        for Key, Value in ThemeData do
            local Color = ReadColor(Value)
            if Color then
                Palette[Key] = Color
            end
        end
        Library:ApplyPalette(Palette, Name)
        return
    end
    if ThemeData.Accent then
        Library.Theme.Accent = ReadColor(ThemeData.Accent) or ThemeData.Accent
        Library:ChangeTheme("Accent", Library.Theme.Accent)
    end
    if ThemeData.AccentGradient then
        Library.Theme.AccentGradient = ReadColor(ThemeData.AccentGradient) or ThemeData.AccentGradient
        Library:ChangeTheme("AccentGradient", Library.Theme.AccentGradient)
    end
end

function ThemeManager:LoadTheme(Name)
    Name = CleanName(Name)
    if not Name then
        return false, "Empty name"
    end

    local Builtin = self:Builtin(Name)
    if Builtin then
        self:ApplyTheme(Builtin, Name)
        return true
    end

    local Path = self:GetThemePath(Name)
    local Ok, Raw = pcall(function()
        if not isfile(Path) then
            return nil
        end
        return readfile(Path)
    end)
    if not Ok or type(Raw) ~= "string" then
        return false, "Theme not found: " .. Name
    end

    local DecodedOk, Data = pcall(function()
        return HttpService:JSONDecode(Raw)
    end)
    if not DecodedOk or type(Data) ~= "table" then
        return false, "Failed to parse theme"
    end

    self:ApplyTheme(Data, Name)
    return true
end

function ThemeManager:SaveTheme(Name)
    if not Library then
        return false, "Library not set"
    end
    Name = CleanName(Name)
    if not Name then
        return false, "Empty name"
    end

    local Data = {
        Full = Library._themeFull and true or false,
        Effect = Library._themeEffect,
    }
    for Key, Color in Library.Theme do
        if typeof(Color) == "Color3" then
            Data[Key] = { r = Color.R, g = Color.G, b = Color.B }
        end
    end

    local Folder = self.Folder or "ThemeManager"
    local Ok, Err = pcall(function()
        if not isfolder(Folder) then
            makefolder(Folder)
        end
        writefile(self:GetThemePath(Name), HttpService:JSONEncode(Data))
    end)
    return Ok, Err
end

function ThemeManager:BuildThemeSection(Tab)
    if not Tab then
        return
    end

    local ThemeSection = Tab:Section({ Name = "Themes", Side = 2, LayoutOrder = -300, Icon = "palette" })
    ThemeSection:Label("Presets and saved themes. Halloween recolors the whole window")

    local SelectedTheme = nil
    local Themes = self:ListThemes()
    local Startup = self:GetStartupThemeName()
    local ThemeList = ThemeSection:Dropdown({
        Name = "Library theme",
        Flag = "_ThemeManagerList",
        Items = Themes,
        Default = Startup or Themes[1],
        Search = true,
        Size = 200,
        OptionHolderSize = 220,
        Callback = function(Value)
            SelectedTheme = Value
        end,
    })

    local function CurrentPick()
        local Pick = SelectedTheme
        if (not Pick or Pick == "") and Library and Library.Flags then
            Pick = Library.Flags._ThemeManagerList
        end
        return CleanName(Pick)
    end

    ThemeSection:Button({
        Name = "Apply theme",
        Callback = function()
            local Pick = CurrentPick()
            if not Pick then
                Notify("Themes", "Select a theme in the list first")
                return
            end
            local Ok, Err = self:LoadTheme(Pick)
            if Ok then
                Notify("Themes", "Applied \"" .. Pick .. "\"")
            else
                Notify("Theme error", tostring(Err))
            end
        end,
    })

    ThemeSection:Button({
        Name = "Set selected as default startup theme",
        Callback = function()
            local Pick = CurrentPick()
            if not Pick then
                Notify("Themes", "Select a theme in the list first")
                return
            end
            local Ok = self:SetDefaultThemeName(Pick)
            if Ok then
                Notify("Themes", "Default startup theme: \"" .. Pick .. "\"")
            else
                Notify("Themes", "Could not save default theme file")
            end
        end,
    })

    ThemeSection:Divider("Custom")
    ThemeSection:Textbox({
        Flag = "_ThemeManagerName",
        Placeholder = "New theme name",
        Finished = false,
        Callback = function() end,
    })

    ThemeSection:Button({
        Name = "Save current as custom theme",
        Callback = function()
            local Raw = Library and Library.Flags and Library.Flags._ThemeManagerName
            Raw = CleanName(Raw)
            if not Raw then
                Notify("Themes", "Type a name in the box first")
                return
            end
            local Ok, Err = self:SaveTheme(Raw)
            if Ok then
                Notify("Themes", "Saved custom theme \"" .. Raw .. "\"")
                if ThemeList and ThemeList.Refresh then
                    ThemeList:Refresh(self:ListThemes())
                end
            else
                Notify("Save failed", tostring(Err))
            end
        end,
    })

    local Saved = self:GetStartupThemeName()
    if Saved then
        self:LoadTheme(Saved)
        if ThemeList and ThemeList.Set then
            pcall(function()
                ThemeList:Set(Saved)
            end)
        end
    end
end

return ThemeManager
