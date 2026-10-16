local ThemeManager = {}
ThemeManager.__index = ThemeManager

local HttpService = game:GetService("HttpService")
local Library

local NOTIF_ICON = "97594400820219"

local HALLOWEEN = {
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
    if Library and type(Library.Palettes) == "table" and Library.Palettes.Halloween == nil then
        Library.Palettes.Halloween = HALLOWEEN
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
    if Name == "Halloween" then
        return HALLOWEEN
    end
    return nil
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
    local Month, Day = tonumber(Now.month), tonumber(Now.day)
    if not Month or not Day then
        return nil
    end
    if Month == 10 or (Month == 11 and Day <= 15) then
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
    if self._appliedStartup == Name then
        return true
    end
    local Ok, Err = self:LoadTheme(Name)
    if Ok then
        self._appliedStartup = Name
    end
    return Ok, Err
end

function ThemeManager:LoadDefault()
    return self:ApplySavedDefault()
end

function ThemeManager:GetThemePath(Name)
    return (self.Folder or "ThemeManager") .. "/" .. Name .. ".json"
end

function ThemeManager:ListThemes()
    local Map = {}
    local Source = Library and Library.Palettes
    if type(Source) ~= "table" then
        Source = { Halloween = HALLOWEEN }
    end
    for Name in Source do
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

    local Path = self:GetThemePath(Name)
    local Ok, Raw = pcall(function()
        if type(isfile) ~= "function" or not isfile(Path) then
            return nil
        end
        return readfile(Path)
    end)
    if not Ok then
        return false, tostring(Raw)
    end
    if type(Raw) == "string" and Raw ~= "" then
        local DecodedOk, Data = pcall(function()
            return HttpService:JSONDecode(Raw)
        end)
        if not DecodedOk or type(Data) ~= "table" then
            return false, "Failed to parse theme"
        end
        self:ApplyTheme(Data, Name)
        return true
    end

    local Builtin = self:Builtin(Name)
    if Builtin then
        self:ApplyTheme(Builtin, Name)
        return true
    end
    return false, "Theme not found: " .. Name
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
    }
    if type(Library._themeEffect) == "string" and Library._themeEffect ~= "" then
        Data.Effect = Library._themeEffect
    end
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
    ThemeSection:Label("Presets and saved themes. Halloween recolors the whole window.")

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
        local Applied = self:LoadTheme(Saved)
        if Applied then
            self._appliedStartup = Saved
        end
        if ThemeList and ThemeList.Set then
            pcall(function()
                ThemeList:Set(Saved)
            end)
        end
    end
end

return ThemeManager
