local SaveManager = {}
SaveManager.__index = SaveManager

local Library

local NOTIF_ICON = "97594400820219"

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

function SaveManager:SetLibrary(Lib)
    Library = Lib
end

function SaveManager:FolderName()
    return self.Folder or "SaveManager"
end

function SaveManager:EnsureFolder()
    local Folder = self:FolderName()
    if type(isfolder) ~= "function" or type(makefolder) ~= "function" then
        return false, "Filesystem is not available"
    end
    local Ok, Err = pcall(function()
        if not isfolder(Folder) then
            makefolder(Folder)
        end
    end)
    if not Ok then
        return false, tostring(Err)
    end
    return true
end

function SaveManager:SetFolder(FolderName)
    self.Folder = FolderName
    self:EnsureFolder()
end

function SaveManager:GetConfigPath(Name)
    return self:FolderName() .. "/" .. Name .. ".json"
end

function SaveManager:GetAutoloadPath()
    return self:FolderName() .. "/autoload.txt"
end

function SaveManager:ListConfigs()
    local Ready = self:EnsureFolder()
    if not Ready then
        return {}
    end
    local Ok, Files = pcall(listfiles, self:FolderName())
    if not Ok or type(Files) ~= "table" then
        return {}
    end
    local List = {}
    for _, File in ipairs(Files) do
        local Name = File:match("([^/\\]+)%.json$")
        if Name and Name ~= "" then
            table.insert(List, Name)
        end
    end
    table.sort(List)
    return List
end

function SaveManager:Save(Name)
    if not Library or not Library.GetConfig then
        return false, "Library not set"
    end
    Name = CleanName(Name)
    if not Name then
        return false, "Invalid config name"
    end
    local Ready, FolderErr = self:EnsureFolder()
    if not Ready then
        return false, FolderErr
    end
    local Payload = Library:GetConfig()
    if type(Payload) ~= "string" then
        return false, "Could not encode config"
    end
    local Ok, Err = pcall(writefile, self:GetConfigPath(Name), Payload)
    if not Ok then
        return false, tostring(Err)
    end
    return true
end

function SaveManager:Load(Name)
    if not Library or not Library.LoadConfig then
        return false, "Library not set"
    end
    Name = CleanName(Name)
    if not Name then
        return false, "Invalid config name"
    end
    local Path = self:GetConfigPath(Name)
    local Ok, Raw = pcall(function()
        if not isfile(Path) then
            return nil
        end
        return readfile(Path)
    end)
    if not Ok then
        return false, tostring(Raw)
    end
    if type(Raw) ~= "string" then
        return false, "Config not found: " .. Name
    end
    return Library:LoadConfig(Raw)
end

function SaveManager:Delete(Name)
    Name = CleanName(Name)
    if not Name then
        return false
    end
    local Ok, Err = pcall(function()
        local Path = self:GetConfigPath(Name)
        if isfile(Path) then
            delfile(Path)
        end
    end)
    if not Ok then
        return false, tostring(Err)
    end
    if self:GetAutoloadName() == Name then
        pcall(function()
            local AutoPath = self:GetAutoloadPath()
            if isfile(AutoPath) then
                delfile(AutoPath)
            end
        end)
    end
    return true
end

function SaveManager:GetAutoloadName()
    local Ok, Raw = pcall(function()
        local Path = self:GetAutoloadPath()
        if not isfile(Path) then
            return nil
        end
        return readfile(Path)
    end)
    if not Ok then
        return nil
    end
    return CleanName(Raw)
end

function SaveManager:SetAutoload(Name)
    Name = CleanName(Name)
    if not Name then
        return false, "Invalid config name"
    end
    local Ready, FolderErr = self:EnsureFolder()
    if not Ready then
        return false, FolderErr
    end
    local Ok, Err = pcall(writefile, self:GetAutoloadPath(), Name)
    if not Ok then
        return false, tostring(Err)
    end
    return true
end

function SaveManager:LoadAutoload()
    local Name = self:GetAutoloadName()
    if not Name then
        return false
    end
    return self:Load(Name)
end

function SaveManager:BuildConfigSection(Tab)
    if not Tab then
        return
    end

    local ConfigSection = Tab:Section({ Name = "Configs", Side = 2 })
    local ConfigName = ""
    local ConfigSelected = nil

    local ConfigList = ConfigSection:Listbox({
        Flag = "_SaveManagerList",
        Items = self:ListConfigs(),
        Callback = function(Value)
            ConfigSelected = Value
        end,
    })

    ConfigSection:Textbox({
        Flag = "_SaveManagerName",
        Placeholder = "Config name...",
        Finished = false,
        Callback = function(Value)
            ConfigName = Value
        end,
    })

    local function CurrentName()
        local Raw = Library and Library.Flags and Library.Flags._SaveManagerName
        if not Raw or Raw == "" then
            Raw = ConfigName
        end
        return CleanName(Raw)
    end

    local function CurrentPick()
        local Pick = ConfigSelected
        if (not Pick or Pick == "") and Library and Library.Flags then
            Pick = Library.Flags._SaveManagerList
        end
        if type(Pick) == "table" then
            Pick = Pick[1]
        end
        return CleanName(Pick)
    end

    local function Refresh()
        if ConfigList and ConfigList.Refresh then
            ConfigList:Refresh(self:ListConfigs())
        end
    end

    ConfigSection:Button({
        Name = "Create Config",
        Callback = function()
            local Name = CurrentName()
            if not Name then
                Notify("SaveManager", "Type a config name first")
                return
            end
            local Ok, Err = self:Save(Name)
            if Ok then
                Refresh()
                Notify("SaveManager", "Saved \"" .. Name .. "\"")
            else
                Notify("SaveManager", tostring(Err))
            end
        end,
    })

    ConfigSection:Button({
        Name = "Load Config",
        Callback = function()
            local Name = CurrentPick()
            if not Name then
                Notify("SaveManager", "Select a config first")
                return
            end
            local Ok, Err = self:Load(Name)
            if Ok then
                Notify("SaveManager", "Loaded \"" .. Name .. "\"")
            else
                Notify("SaveManager", tostring(Err))
            end
        end,
    })

    ConfigSection:Button({
        Name = "Save Config",
        Callback = function()
            local Name = CurrentPick() or CurrentName()
            if not Name then
                Notify("SaveManager", "Select a config or type a name")
                return
            end
            local Ok, Err = self:Save(Name)
            if Ok then
                Refresh()
                Notify("SaveManager", "Saved \"" .. Name .. "\"")
            else
                Notify("SaveManager", tostring(Err))
            end
        end,
    })

    ConfigSection:Button({
        Name = "Delete Config",
        Callback = function()
            local Name = CurrentPick()
            if not Name then
                Notify("SaveManager", "Select a config first")
                return
            end
            local Ok, Err = self:Delete(Name)
            ConfigSelected = nil
            Refresh()
            if Ok then
                Notify("SaveManager", "Deleted \"" .. Name .. "\"")
            else
                Notify("SaveManager", tostring(Err))
            end
        end,
    })

    ConfigSection:Button({
        Name = "Set selected as autoload",
        Callback = function()
            local Name = CurrentPick()
            if not Name then
                Notify("SaveManager", "Select a config first")
                return
            end
            local Ok, Err = self:SetAutoload(Name)
            if Ok then
                Notify("SaveManager", "Autoload: \"" .. Name .. "\"")
            else
                Notify("SaveManager", tostring(Err))
            end
        end,
    })

    ConfigSection:Button({
        Name = "Refresh List",
        Callback = function()
            Refresh()
        end,
    })

    task.defer(function()
        local Name = self:GetAutoloadName()
        if not Name then
            return
        end
        local Ok, Err = self:Load(Name)
        if Ok then
            Notify("SaveManager", "Autoloaded \"" .. Name .. "\"")
        else
            Notify("SaveManager", tostring(Err))
        end
    end)
end

return SaveManager
