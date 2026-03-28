local SaveManager = {}
SaveManager.__index = SaveManager

local HttpService = game:GetService("HttpService")

local Library
local Options

function SaveManager:SetLibrary(Lib)
    Library = Lib
    Options = Lib.Flags or {}
end

function SaveManager:SetFolder(FolderName)
    self.Folder = FolderName
    if not isfolder(FolderName) then
        makefolder(FolderName)
    end
end

function SaveManager:GetConfigPath(Name)
    return (self.Folder or "SaveManager") .. "/" .. Name .. ".json"
end

function SaveManager:ListConfigs()
    local folder = self.Folder or "SaveManager"
    if not isfolder(folder) then return {} end
    local list = {}
    for _, f in ipairs(listfiles(folder)) do
        local name = f:match("([^/\\]+)%.json$")
        if name then
            table.insert(list, name)
        end
    end
    table.sort(list)
    return list
end

function SaveManager:Save(Name)
    if not Library then return false, "Library not set" end
    local folder = self.Folder or "SaveManager"
    if not isfolder(folder) then makefolder(folder) end

    local data = {}
    for flag, value in next, Library.Flags do
        if type(value) == "boolean" or type(value) == "number" or type(value) == "string" then
            data[flag] = value
        elseif typeof(value) == "Color3" then
            data[flag] = {r = value.R, g = value.G, b = value.B, _type = "Color3"}
        elseif typeof(value) == "EnumItem" then
            data[flag] = {enum = tostring(value), _type = "EnumItem"}
        elseif type(value) == "table" then
            data[flag] = value
        end
    end

    local ok, err = pcall(function()
        writefile(self:GetConfigPath(Name), HttpService:JSONEncode(data))
    end)
    return ok, err
end

function SaveManager:Load(Name)
    if not Library then return false, "Library not set" end
    local path = self:GetConfigPath(Name)
    if not isfile(path) then return false, "Config not found: " .. Name end

    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile(path))
    end)
    if not ok then return false, "Failed to parse config" end

    for flag, value in next, data do
        if type(value) == "table" and value._type == "Color3" then
            value = Color3.new(value.r, value.g, value.b)
        elseif type(value) == "table" and value._type == "EnumItem" then
            local ok2, ev = pcall(function()
                local parts = value.enum:split(".")
                return Enum[parts[2]][parts[3]]
            end)
            if ok2 then value = ev else continue end
        end
        if Library.SetFlags and Library.SetFlags[flag] then
            Library.SetFlags[flag](value)
        else
            Library.Flags[flag] = value
        end
    end

    return true
end

function SaveManager:Delete(Name)
    local path = self:GetConfigPath(Name)
    if isfile(path) then
        pcall(delfile, path)
    end
end

function SaveManager:BuildConfigSection(Tab)
    if not Tab then return end

    local ConfigSection = Tab:Section({Name = "Configs", Side = 2})

    local configName = ""
    local configSelected = nil

    local ConfigList = ConfigSection:Listbox({
        Flag = "_SaveManagerList",
        Items = self:ListConfigs(),
        Callback = function(v)
            configSelected = v
        end
    })

    ConfigSection:Textbox({
        Flag = "_SaveManagerName",
        Placeholder = "Config name...",
        Finished = true,
        Callback = function(v)
            configName = v
        end
    })

    ConfigSection:Button({
        Name = "Create Config",
        Callback = function()
            if configName and configName ~= "" then
                local ok, err = self:Save(configName)
                if ok then
                    Library:Notification({Title = "SaveManager", Description = "Config '" .. configName .. "' created.", Duration = 3})
                    ConfigList:Refresh(self:ListConfigs())
                else
                    Library:Notification({Title = "Error", Description = tostring(err), Duration = 3})
                end
            end
        end
    })

    ConfigSection:Button({
        Name = "Load Config",
        Callback = function()
            if configSelected then
                local ok, err = self:Load(configSelected)
                if ok then
                    Library:Notification({Title = "SaveManager", Description = "Loaded '" .. configSelected .. "'.", Duration = 3})
                else
                    Library:Notification({Title = "Error", Description = tostring(err), Duration = 3})
                end
            end
        end
    })

    ConfigSection:Button({
        Name = "Save Config",
        Callback = function()
            if configSelected then
                local ok, err = self:Save(configSelected)
                if ok then
                    Library:Notification({Title = "SaveManager", Description = "Saved '" .. configSelected .. "'.", Duration = 3})
                else
                    Library:Notification({Title = "Error", Description = tostring(err), Duration = 3})
                end
            end
        end
    })

    ConfigSection:Button({
        Name = "Delete Config",
        Callback = function()
            if configSelected then
                self:Delete(configSelected)
                configSelected = nil
                ConfigList:Refresh(self:ListConfigs())
                Library:Notification({Title = "SaveManager", Description = "Config deleted.", Duration = 2})
            end
        end
    })

    ConfigSection:Button({
        Name = "Refresh List",
        Callback = function()
            ConfigList:Refresh(self:ListConfigs())
        end
    })
end

return SaveManager
