if getgenv().Samuraa1Hub then
	getgenv().Samuraa1Hub:Unload()
end

local Library = {} do
	local Players      = game:GetService("Players")
	local UIS          = game:GetService("UserInputService")
	local RS           = game:GetService("RunService")
	local TS           = game:GetService("TweenService")
	local HTTP         = game:GetService("HttpService")
	local CoreGui      = (cloneref or function(x) return x end)(game:GetService("CoreGui"))
	gethui             = gethui or function() return CoreGui end

	local LP           = Players.LocalPlayer
	local Mouse        = LP:GetMouse()
	local Camera       = workspace.CurrentCamera

	local New          = Instance.new
	local V2           = Vector2.new
	local U2           = UDim2
	local U            = UDim.new
	local RGB          = Color3.fromRGB
	local HSV          = Color3.fromHSV
	local TI           = TweenInfo.new
	local ins          = table.insert
	local rem          = table.remove
	local find         = table.find
	local clone        = table.clone
	local mClamp       = math.clamp
	local mFloor       = math.floor
	local mAbs         = math.abs
	local mSin         = math.sin
	local sFind        = string.find
	local sLower       = string.lower
	local sFormat      = string.format

	local _uid = 0
	local function uid() _uid += 1 return "\0"..tostring(_uid) end

	Library.Version       = "1.0.0"
	Library.Toggles       = {}
	Library.Options       = {}
	Library.Flags         = {}
	Library.SetFlags      = {}
	Library.Connections   = {}
	Library.Threads       = {}
	Library.ThemeItems    = {}
	Library.SearchItems   = {}
	Library.MenuKey       = Enum.KeyCode.RightControl
	Library.Holder        = nil
	Library.UnusedHolder  = nil
	Library.NotifHolder   = nil
	Library.Font          = nil
	Library.IconFont      = nil
	Library._iconQueue    = {}
	Library._iconFontLoading = false

	Library.IconCodepoints = {
		["home"]=0xE88A, ["settings"]=0xE8B8, ["person"]=0xE7FD, ["search"]=0xE8B6,
		["favorite"]=0xE87D, ["star"]=0xE838, ["close"]=0xE5CD, ["menu"]=0xE5D2,
		["add"]=0xE145, ["delete"]=0xE872, ["edit"]=0xE3C9, ["check"]=0xE5CA,
		["info"]=0xE88E, ["warning"]=0xE002, ["done"]=0xE5CA, ["done_all"]=0xE877,
		["visibility"]=0xE8F4, ["visibility_off"]=0xE8F5, ["lock"]=0xE897,
		["lock_open"]=0xE898, ["notifications"]=0xE7F4, ["refresh"]=0xE5D5,
		["play_arrow"]=0xE037, ["pause"]=0xE034, ["stop"]=0xE047,
		["volume_up"]=0xE050, ["volume_off"]=0xE04F, ["wifi"]=0xE63E,
		["bluetooth"]=0xE1A7, ["cloud"]=0xE2BD, ["folder"]=0xE2C7,
		["image"]=0xE3F4, ["camera"]=0xE3AF, ["share"]=0xE80D, ["link"]=0xE157,
		["security"]=0xE32A, ["flag"]=0xE153, ["bookmark"]=0xE866,
		["star_border"]=0xE83A, ["label"]=0xE892, ["clear"]=0xE14C,
		["block"]=0xE14B, ["tune"]=0xE429, ["build"]=0xE869, ["code"]=0xE86F,
		["history"]=0xE889, ["schedule"]=0xE8B5, ["timer"]=0xE425,
		["list"]=0xE896, ["dashboard"]=0xE871, ["apps"]=0xE5C3,
		["whatshot"]=0xE80E, ["eco"]=0xE893, ["nature"]=0xE91A,
		["local_florist"]=0xE553, ["spa"]=0xEB41, ["waves"]=0xE43C,
		["terrain"]=0xE564, ["gps_fixed"]=0xE1B0, ["directions_run"]=0xE566,
		["gamepad"]=0xE30F, ["videogame_asset"]=0xE338, ["sync"]=0xE627,
		["music_note"]=0xE405, ["mic"]=0xE029, ["shield"]=0xE9E0,
		["speed"]=0xE9E4, ["bolt"]=0xEA0B, ["grass"]=0xE9FE,
		["agriculture"]=0xEA79, ["water_drop"]=0xE798, ["sports_esports"]=0xEA23,
		["yard"]=0xF089, ["expand_more"]=0xE5CF, ["expand_less"]=0xE5CE,
		["chevron_right"]=0xE5CC, ["chevron_left"]=0xE5CB,
		["arrow_back"]=0xE5C4, ["arrow_forward"]=0xE5C8,
		["more_vert"]=0xE5D4, ["more_horiz"]=0xE5D3,
	}

	Library.Folders = {
		Main    = "samuraa1hub",
		Configs = "samuraa1hub/configs",
		Assets  = "samuraa1hub/assets",
		Themes  = "samuraa1hub/themes",
	}
	for _, p in Library.Folders do
		if not isfolder(p) then makefolder(p) end
	end

	Library.ThemePresets = {
		Default = {
			Background  = RGB(11, 10, 18),
			Surface     = RGB(17, 16, 27),
			SurfaceAlt  = RGB(24, 23, 38),
			Border      = RGB(44, 42, 70),
			Accent      = RGB(124, 93, 255),
			AccentDim   = RGB(86, 60, 200),
			AccentText  = RGB(255, 255, 255),
			Text        = RGB(232, 229, 255),
			TextMuted   = RGB(120, 118, 158),
			ToggleOff   = RGB(52, 50, 82),
			Shadow      = RGB(0, 0, 0),
			Success     = RGB(52, 211, 153),
			Warning     = RGB(251, 191, 36),
			Error       = RGB(248, 113, 113),
		},
		Nord = {
			Background  = RGB(46, 52, 64),
			Surface     = RGB(59, 66, 82),
			SurfaceAlt  = RGB(67, 76, 94),
			Border      = RGB(76, 86, 106),
			Accent      = RGB(136, 192, 208),
			AccentDim   = RGB(100, 155, 170),
			AccentText  = RGB(46, 52, 64),
			Text        = RGB(236, 239, 244),
			TextMuted   = RGB(180, 187, 200),
			ToggleOff   = RGB(76, 86, 106),
			Shadow      = RGB(0, 0, 0),
			Success     = RGB(163, 190, 140),
			Warning     = RGB(235, 203, 139),
			Error       = RGB(191, 97, 106),
		},
		Catppuccin = {
			Background  = RGB(24, 24, 37),
			Surface     = RGB(30, 30, 46),
			SurfaceAlt  = RGB(36, 36, 54),
			Border      = RGB(49, 50, 68),
			Accent      = RGB(137, 180, 250),
			AccentDim   = RGB(100, 140, 220),
			AccentText  = RGB(24, 24, 37),
			Text        = RGB(205, 214, 244),
			TextMuted   = RGB(147, 153, 178),
			ToggleOff   = RGB(69, 71, 90),
			Shadow      = RGB(0, 0, 0),
			Success     = RGB(166, 227, 161),
			Warning     = RGB(249, 226, 175),
			Error       = RGB(243, 139, 168),
		},
		Gruvbox = {
			Background  = RGB(29, 32, 33),
			Surface     = RGB(40, 40, 40),
			SurfaceAlt  = RGB(50, 48, 47),
			Border      = RGB(80, 73, 69),
			Accent      = RGB(214, 93, 14),
			AccentDim   = RGB(175, 58, 0),
			AccentText  = RGB(251, 241, 199),
			Text        = RGB(235, 219, 178),
			TextMuted   = RGB(168, 153, 132),
			ToggleOff   = RGB(80, 73, 69),
			Shadow      = RGB(0, 0, 0),
			Success     = RGB(184, 187, 38),
			Warning     = RGB(215, 153, 33),
			Error       = RGB(204, 36, 29),
		},
		RosePine = {
			Background  = RGB(25, 23, 36),
			Surface     = RGB(31, 29, 46),
			SurfaceAlt  = RGB(38, 35, 58),
			Border      = RGB(64, 61, 82),
			Accent      = RGB(196, 167, 231),
			AccentDim   = RGB(144, 122, 169),
			AccentText  = RGB(25, 23, 36),
			Text        = RGB(224, 222, 244),
			TextMuted   = RGB(144, 140, 170),
			ToggleOff   = RGB(64, 61, 82),
			Shadow      = RGB(0, 0, 0),
			Success     = RGB(49, 116, 143),
			Warning     = RGB(246, 193, 119),
			Error       = RGB(235, 111, 146),
		},
	}

	Library.Theme = {}
	local function _loadPreset(name)
		local p = Library.ThemePresets[name] or Library.ThemePresets.Default
		for k, v in p do Library.Theme[k] = v end
	end
	_loadPreset("Default")

	local function themed(inst, map)
		local entry = { inst = inst, map = map }
		ins(Library.ThemeItems, entry)
		for prop, key in map do
			if type(key) == "string" then
				local v = Library.Theme[key]
				if v ~= nil then inst[prop] = v end
			elseif type(key) == "function" then
				inst[prop] = key()
			end
		end
		return inst
	end

	Library.ChangeTheme = function(self, name)
		_loadPreset(name)
		for _, e in Library.ThemeItems do
			if not e.inst or not e.inst.Parent then continue end
			for prop, key in e.map do
				if type(key) == "string" then
					local v = Library.Theme[key]
					if v ~= nil then
						TS:Create(e.inst, TI(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {[prop] = v}):Play()
					end
				elseif type(key) == "function" then
					e.inst[prop] = key()
				end
			end
		end
	end

	Library.SetThemeColor = function(self, key, color)
		Library.Theme[key] = color
		for _, e in Library.ThemeItems do
			if not e.inst or not e.inst.Parent then continue end
			for prop, k in e.map do
				if k == key then
					TS:Create(e.inst, TI(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {[prop] = color}):Play()
				end
			end
		end
	end

	local function tw(inst, props, time, style, dir)
		if not inst or not inst.Parent then return end
		time = time or 0.18
		local info = TI(time, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
		local ok, tween = pcall(TS.Create, TS, inst, info, props)
		if ok and tween then tween:Play() end
	end

	local function connect(evt, cb)
		local c = evt:Connect(cb)
		ins(Library.Connections, c)
		return c
	end

	local function make(class, props)
		local i = New(class)
		local parent
		for k, v in props do
			if k == "Parent" then parent = v else i[k] = v end
		end
		if parent then i.Parent = parent end
		return i
	end

	local function pad(parent, t, b, l, r)
		make("UIPadding", {Parent = parent, PaddingTop = U(0, t or 0), PaddingBottom = U(0, b or 0), PaddingLeft = U(0, l or 0), PaddingRight = U(0, r or 0)})
	end

	local function corner(parent, r)
		make("UICorner", {Parent = parent, CornerRadius = U(0, r or 6)})
	end

	local function stroke(parent, color, thickness)
		local s = make("UIStroke", {Parent = parent, Color = color or Library.Theme.Border, Thickness = thickness or 1, LineJoinMode = Enum.LineJoinMode.Miter})
		return s
	end

	local function setupFont()
		local ttfPath  = Library.Folders.Assets .. "/SH_Font.ttf"
		local jsonPath = Library.Folders.Assets .. "/SH_Font.json"
		if isfile(jsonPath) then
			Library.Font = Font.new(getcustomasset(jsonPath))
			return
		end
		if not isfile(ttfPath) then
			local ok, data = pcall(game.HttpGet, game, "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/InterSemibold.ttf")
			if not ok or not data then return end
			writefile(ttfPath, data)
		end
		local fd = { name = "SH_Font", faces = {{ name = "Regular", weight = 400, style = "Regular", assetId = getcustomasset(ttfPath) }} }
		writefile(jsonPath, HTTP:JSONEncode(fd))
		Library.Font = Font.new(getcustomasset(jsonPath))
	end
	local fontOk = pcall(setupFont)
	if not fontOk or not Library.Font then
		Library.Font = Font.fromEnum(Enum.Font.Gotham)
	end

	Library.LoadIconFont = function(self)
		if self.IconFont or self._iconFontLoading then return end
		self._iconFontLoading = true
		task.spawn(function()
			local fp = Library.Folders.Assets .. "/SH_Icons.ttf"
			local jp = Library.Folders.Assets .. "/SH_Icons.json"
			local cp = Library.Folders.Assets .. "/SH_Icons.codepoints"
			if not isfile(fp) then
				local ok, d = pcall(game.HttpGet, game, "https://raw.githubusercontent.com/google/material-design-icons/master/variablefont/MaterialSymbolsOutlined%5BFILL%2CGRAD%2Copsz%2Cwght%5D.ttf")
				if not ok or not d then self._iconFontLoading = false return end
				writefile(fp, d)
			end
			if not isfile(jp) then
				writefile(jp, HTTP:JSONEncode({ name = "SH_Icons", faces = {{ name = "Regular", weight = 400, style = "Regular", assetId = getcustomasset(fp) }} }))
			end
			self.IconFont = Font.new(getcustomasset(jp))
			if not isfile(cp) then
				local ok, d = pcall(game.HttpGet, game, "https://raw.githubusercontent.com/google/material-design-icons/master/variablefont/MaterialSymbolsOutlined%5BFILL%2CGRAD%2Copsz%2Cwght%5D.codepoints")
				if ok and d then
					writefile(cp, d)
					for line in d:gmatch("[^\n\r]+") do
						local n, c = line:match("^(%S+)%s+(%x+)$")
						if n and c and not self.IconCodepoints[n] then self.IconCodepoints[n] = tonumber(c, 16) end
					end
				end
			else
				for line in readfile(cp):gmatch("[^\n\r]+") do
					local n, c = line:match("^(%S+)%s+(%x+)$")
					if n and c and not self.IconCodepoints[n] then self.IconCodepoints[n] = tonumber(c, 16) end
				end
			end
			for _, item in self._iconQueue do
				local icp = self.IconCodepoints[item.Name]
				if icp and item.Inst and item.Inst.Parent then
					item.Inst.FontFace = self.IconFont
					item.Inst.Text = utf8.char(icp)
				end
			end
			self._iconQueue = {}
		end)
	end

	local function resolveIcon(icon)
		if not icon then return nil, false end
		if tostring(icon):match("^%d+$") then return "rbxassetid://" .. tostring(icon), true end
		local cp = Library.IconCodepoints[icon]
		if cp and Library.IconFont then return utf8.char(cp), false end
		return nil, false
	end

	local function makeIconLabel(parent, icon, size, zindex)
		local iconStr, isImg = resolveIcon(icon)
		local lbl
		if isImg then
			lbl = make("ImageLabel", {
				Parent = parent, Name = uid(),
				Size = U2.fromOffset(size, size),
				BackgroundTransparency = 1,
				Image = iconStr,
				ImageColor3 = Library.Theme.TextMuted,
				ZIndex = zindex or 3,
			})
			themed(lbl, { ImageColor3 = "TextMuted" })
		else
			lbl = make("TextLabel", {
				Parent = parent, Name = uid(),
				Size = U2.fromOffset(size, size),
				Text = iconStr or "",
				FontFace = Library.IconFont or Library.Font,
				TextSize = size,
				TextColor3 = Library.Theme.TextMuted,
				BackgroundTransparency = 1,
				ZIndex = zindex or 3,
			})
			themed(lbl, { TextColor3 = "TextMuted" })
			if not iconStr and icon then
				ins(Library._iconQueue, { Inst = lbl, Name = icon })
				Library:LoadIconFont()
			end
		end
		return lbl
	end

	Library.Unload = function(self)
		for _, c in self.Connections do pcall(function() c:Disconnect() end) end
		if self.Holder then pcall(function() self.Holder:Destroy() end) end
		if self.UnusedHolder then pcall(function() self.UnusedHolder:Destroy() end) end
		getgenv().Samuraa1Hub = nil
		UIS.MouseIconEnabled = true
	end

	Library.GetConfig = function(self)
		local cfg = {}
		for flag, val in self.Flags do
			if type(val) == "table" and val.Key then
				cfg[flag] = { Key = tostring(val.Key), Mode = val.Mode }
			elseif type(val) == "table" and val.Color then
				cfg[flag] = { Color = "#" .. val.Color, Alpha = val.Alpha }
			else
				cfg[flag] = val
			end
		end
		return HTTP:JSONEncode(cfg)
	end

	Library.LoadConfig = function(self, json)
		local ok, decoded = pcall(HTTP.JSONDecode, HTTP, json)
		if not ok then return false end
		for flag, val in decoded do
			local fn = self.SetFlags[flag]
			if not fn then continue end
			if type(val) == "table" and val.Key then fn(val)
			elseif type(val) == "table" and val.Color then fn(val.Color, val.Alpha)
			else fn(val) end
		end
		return true
	end

	Library.SaveConfig = function(self, name)
		writefile(self.Folders.Configs .. "/" .. name .. tostring(game.GameId) .. ".json", self:GetConfig())
	end

	Library.DeleteConfig = function(self, name)
		local p = self.Folders.Configs .. "/" .. name
		if isfile(p) then delfile(p) end
	end

	Library.ListConfigs = function(self)
		local list = {}
		local ok, files = pcall(listfiles, self.Folders.Configs)
		if not ok or not files then return list end
		for _, f in files do
			local name = tostring(f):gsub("\\", "/"):match("([^/]+)$") or ""
			if sFind(name, tostring(game.GameId), 1, true) then
				ins(list, name:gsub(tostring(game.GameId) .. "%.json$", ""):gsub("%.json$", ""))
			end
		end
		return list
	end

	Library.Holder = make("ScreenGui", {
		Parent          = gethui(),
		Name            = uid(),
		ZIndexBehavior  = Enum.ZIndexBehavior.Global,
		DisplayOrder    = 999,
		ResetOnSpawn    = false,
		Archivable      = false,
	})

	Library.UnusedHolder = make("ScreenGui", {
		Parent          = gethui(),
		Name            = uid(),
		ZIndexBehavior  = Enum.ZIndexBehavior.Global,
		Enabled         = false,
		ResetOnSpawn    = false,
		Archivable      = false,
	})

	local notifContainer = make("Frame", {
		Parent              = Library.Holder,
		Name                = uid(),
		AnchorPoint         = V2(1, 0),
		Position            = U2.new(1, -16, 0, 16),
		Size                = U2.fromOffset(0, 0),
		BackgroundTransparency = 1,
		AutomaticSize       = Enum.AutomaticSize.X,
	})
	make("UIListLayout", {
		Parent              = notifContainer,
		Padding             = U(0, 8),
		SortOrder           = Enum.SortOrder.LayoutOrder,
		VerticalAlignment   = Enum.VerticalAlignment.Top,
	})
	Library.NotifHolder = notifContainer

	Library.Notify = function(self, data)
		if type(data) == "string" then data = { Title = data, Duration = 3 } end
		local title   = data.Title or "Notification"
		local content = data.Content or data.Description or ""
		local dur     = math.max(data.Duration or 3, 0.2)
		local nType   = data.Type or "info"
		local accentMap = {
			info    = Library.Theme.Accent,
			success = Library.Theme.Success,
			warning = Library.Theme.Warning,
			error   = Library.Theme.Error,
		}
		local accent = accentMap[nType] or Library.Theme.Accent

		local frame = make("Frame", {
			Parent              = notifContainer,
			Name                = uid(),
			Size                = U2.fromOffset(315, 0),
			BackgroundColor3    = Library.Theme.Surface,
			BorderSizePixel     = 0,
			AutomaticSize       = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
		})
		themed(frame, { BackgroundColor3 = "Surface" })
		corner(frame, 8)
		local stk = stroke(frame, Library.Theme.Border, 1)
		themed(stk, { Color = "Border" })

		make("Frame", {
			Parent           = frame, Name = uid(),
			Size             = U2.new(0, 3, 1, 0),
			BackgroundColor3 = accent,
			BorderSizePixel  = 0,
		})
		corner(frame:FindFirstChildWhichIsA("Frame"), 3)

		local titleLbl = make("TextLabel", {
			Parent              = frame, Name = uid(),
			Text                = title,
			FontFace            = Library.Font,
			TextSize            = 13,
			TextColor3          = Library.Theme.Text,
			TextXAlignment      = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			Size                = U2.new(1, -22, 0, 18),
			Position            = U2.fromOffset(12, 9),
			ZIndex              = 2,
		})
		themed(titleLbl, { TextColor3 = "Text" })

		if content ~= "" then
			local contLbl = make("TextLabel", {
				Parent              = frame, Name = uid(),
				Text                = content,
				FontFace            = Library.Font,
				TextSize            = 12,
				TextColor3          = Library.Theme.TextMuted,
				TextXAlignment      = Enum.TextXAlignment.Left,
				TextWrapped         = true,
				BackgroundTransparency = 1,
				Size                = U2.new(1, -22, 0, 0),
				Position            = U2.fromOffset(12, 29),
				AutomaticSize       = Enum.AutomaticSize.Y,
				ZIndex              = 2,
			})
			themed(contLbl, { TextColor3 = "TextMuted" })
		end

		local progBg = make("Frame", {
			Parent           = frame, Name = uid(),
			Size             = U2.new(1, -16, 0, 2),
			Position         = U2.new(0, 8, 1, -8),
			BackgroundColor3 = Library.Theme.Border,
			BorderSizePixel  = 0,
			ZIndex           = 2,
		})
		themed(progBg, { BackgroundColor3 = "Border" })
		corner(progBg, 2)
		local progBar = make("Frame", {
			Parent           = progBg, Name = uid(),
			Size             = U2.fromScale(1, 1),
			BackgroundColor3 = accent,
			BorderSizePixel  = 0,
		})
		corner(progBar, 2)

		tw(frame, { BackgroundTransparency = 0.04 }, 0.3)
		tw(progBar, { Size = U2.new(0, 0, 1, 0) }, dur, Enum.EasingStyle.Linear)

		task.delay(dur, function()
			if frame and frame.Parent then
				tw(frame, { BackgroundTransparency = 1 }, 0.3)
				task.wait(0.32)
				if frame and frame.Parent then frame:Destroy() end
			end
		end)
	end

	-- [WINDOW]

	Library.CreateWindow = function(self, config)
		config = config or {}
		local winTitle    = config.Title    or "samuraa1-hub"
		local winSub      = config.SubTitle  or ""
		local winSize     = config.Size      or U2.fromOffset(590, 470)
		local menuKey     = config.MenuKey   or Enum.KeyCode.RightControl
		local themeName   = config.Theme     or "Default"
		local showIntro   = config.Intro ~= false

		Library.MenuKey = menuKey
		if themeName ~= "Default" then Library:ChangeTheme(themeName) end

		if showIntro then
			local introF = make("Frame", {
				Parent              = Library.Holder,
				Name                = uid(),
				Size                = U2.fromScale(1, 1),
				BackgroundColor3    = Library.Theme.Background,
				ZIndex              = 200,
			})
			themed(introF, { BackgroundColor3 = "Background" })

			local iTitle = make("TextLabel", {
				Parent              = introF, Name = uid(),
				Text                = winTitle,
				FontFace            = Library.Font,
				TextSize            = 24,
				TextColor3          = Library.Theme.Accent,
				AnchorPoint         = V2(0.5, 0.5),
				Position            = U2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
				Size                = U2.fromOffset(0, 32),
				AutomaticSize       = Enum.AutomaticSize.X,
				ZIndex              = 201,
			})
			if winSub ~= "" then
				make("TextLabel", {
					Parent              = introF, Name = uid(),
					Text                = winSub,
					FontFace            = Library.Font,
					TextSize            = 13,
					TextColor3          = Library.Theme.TextMuted,
					AnchorPoint         = V2(0.5, 0),
					Position            = U2.new(0.5, 0, 0.5, 22),
					BackgroundTransparency = 1,
					Size                = U2.fromOffset(0, 20),
					AutomaticSize       = Enum.AutomaticSize.X,
					ZIndex              = 201,
				})
			end
			task.delay(1.5, function()
				tw(introF, { BackgroundTransparency = 1 }, 0.45)
				task.wait(0.5)
				if introF and introF.Parent then introF:Destroy() end
			end)
		end

		local vpSize = Camera.ViewportSize
		local mainFrame = make("Frame", {
			Parent              = Library.Holder,
			Name                = uid(),
			Position            = U2.fromOffset(vpSize.X / 2 - winSize.X.Offset / 2, vpSize.Y / 2 - winSize.Y.Offset / 2),
			Size                = winSize,
			BackgroundColor3    = Library.Theme.Background,
			BorderSizePixel     = 0,
			ClipsDescendants    = true,
			ZIndex              = 2,
		})
		themed(mainFrame, { BackgroundColor3 = "Background" })
		corner(mainFrame, 9)

		make("ImageLabel", {
			Parent              = mainFrame, Name = uid(),
			AnchorPoint         = V2(0.5, 0.5),
			Position            = U2.fromScale(0.5, 0.5),
			Size                = U2.new(1, 70, 1, 70),
			Image               = "rbxassetid://112971167999062",
			ImageColor3         = RGB(0, 0, 0),
			ImageTransparency   = 0.45,
			BackgroundTransparency = 1,
			ScaleType           = Enum.ScaleType.Slice,
			SliceCenter         = Rect.new(V2(112, 112), V2(147, 147)),
			SliceScale          = 0.6,
			ZIndex              = -1,
		})

		local header = make("Frame", {
			Parent           = mainFrame, Name = uid(),
			Size             = U2.new(1, 0, 0, 38),
			BackgroundColor3 = Library.Theme.Surface,
			BorderSizePixel  = 0,
			ZIndex           = 4,
		})
		themed(header, { BackgroundColor3 = "Surface" })
		local hdrBorderLine = make("Frame", {
			Parent           = header, Name = uid(),
			Size             = U2.new(1, 0, 0, 1),
			Position         = U2.new(0, 0, 1, -1),
			BackgroundColor3 = Library.Theme.Border,
			BorderSizePixel  = 0,
			ZIndex           = 5,
		})
		themed(hdrBorderLine, { BackgroundColor3 = "Border" })

		local hdrRow = make("Frame", {
			Parent              = header, Name = uid(),
			BackgroundTransparency = 1,
			AnchorPoint         = V2(0, 0.5),
			Position            = U2.fromOffset(12, 0),
			Size                = U2.new(0.6, 0, 1, 0),
			AutomaticSize       = Enum.AutomaticSize.X,
			ZIndex              = 5,
		})
		make("UIListLayout", {
			Parent            = hdrRow,
			FillDirection     = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding           = U(0, 5),
		})

		local titleLbl = make("TextLabel", {
			Parent              = hdrRow, Name = uid(),
			Text                = winTitle,
			FontFace            = Library.Font,
			TextSize            = 13,
			TextColor3          = Library.Theme.Text,
			BackgroundTransparency = 1,
			Size                = U2.fromOffset(0, 20),
			AutomaticSize       = Enum.AutomaticSize.X,
			ZIndex              = 5,
			LayoutOrder         = 1,
		})
		themed(titleLbl, { TextColor3 = "Text" })

		if winSub ~= "" then
			local dot = make("TextLabel", {
				Parent              = hdrRow, Name = uid(),
				Text                = "·",
				FontFace            = Library.Font,
				TextSize            = 11,
				TextColor3          = Library.Theme.TextMuted,
				BackgroundTransparency = 1,
				Size                = U2.fromOffset(0, 20),
				AutomaticSize       = Enum.AutomaticSize.X,
				ZIndex              = 5,
				LayoutOrder         = 2,
			})
			themed(dot, { TextColor3 = "TextMuted" })
			local subLbl = make("TextLabel", {
				Parent              = hdrRow, Name = uid(),
				Text                = winSub,
				FontFace            = Library.Font,
				TextSize            = 12,
				TextColor3          = Library.Theme.TextMuted,
				BackgroundTransparency = 1,
				Size                = U2.fromOffset(0, 20),
				AutomaticSize       = Enum.AutomaticSize.X,
				ZIndex              = 5,
				LayoutOrder         = 3,
			})
			themed(subLbl, { TextColor3 = "TextMuted" })
		end

		local function hdrIconBtn(iconId, xOff, hoverColor, clickFn)
			local btn = make("ImageButton", {
				Parent              = header, Name = uid(),
				AnchorPoint         = V2(1, 0.5),
				Position            = U2.new(1, xOff, 0.5, 0),
				Size                = U2.fromOffset(18, 18),
				Image               = iconId,
				BackgroundTransparency = 1,
				ImageColor3         = Library.Theme.TextMuted,
				AutoButtonColor     = false,
				ZIndex              = 6,
			})
			themed(btn, { ImageColor3 = "TextMuted" })
			connect(btn.MouseEnter, function() tw(btn, { ImageColor3 = hoverColor }) end)
			connect(btn.MouseLeave, function() tw(btn, { ImageColor3 = Library.Theme.TextMuted }) end)
			connect(btn.MouseButton1Click, clickFn)
			return btn
		end

		hdrIconBtn("rbxassetid://76001605964586", -8, RGB(248, 113, 113), function()
			Library:Unload()
		end)

		local minimized = false
		local origH = winSize.Y.Offset
		hdrIconBtn("rbxassetid://94817928404736", -30, Library.Theme.Text, function()
			minimized = not minimized
			tw(mainFrame, { Size = minimized and U2.fromOffset(winSize.X.Offset, 38) or winSize }, 0.2)
		end)

		local dragging, dStart, dPos = false, nil, nil
		connect(header.InputBegan, function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				dStart   = inp.Position
				dPos     = mainFrame.Position
				connect(inp.Changed, function()
					if inp.UserInputState == Enum.UserInputState.End then dragging = false end
				end)
			end
		end)
		connect(UIS.InputChanged, function(inp)
			if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
				local d = inp.Position - dStart
				mainFrame.Position = U2.new(dPos.X.Scale, dPos.X.Offset + d.X, dPos.Y.Scale, dPos.Y.Offset + d.Y)
			end
		end)
		connect(UIS.InputBegan, function(inp, gpe)
			if not gpe and (tostring(inp.KeyCode) == tostring(Library.MenuKey) or tostring(inp.UserInputType) == tostring(Library.MenuKey)) then
				mainFrame.Visible = not mainFrame.Visible
			end
		end)

		local sidebar = make("Frame", {
			Parent           = mainFrame, Name = uid(),
			Position         = U2.fromOffset(0, 38),
			Size             = U2.new(0, 168, 1, -38),
			BackgroundColor3 = Library.Theme.Surface,
			BorderSizePixel  = 0,
			ZIndex           = 3,
		})
		themed(sidebar, { BackgroundColor3 = "Surface" })
		make("Frame", {
			Parent           = sidebar, Name = uid(),
			AnchorPoint      = V2(1, 0),
			Position         = U2.fromScale(1, 0),
			Size             = U2.new(0, 1, 1, 0),
			BackgroundColor3 = Library.Theme.Border,
			BorderSizePixel  = 0,
			ZIndex           = 4,
		})

		local sidebarBorderLine = make("Frame", {
			Parent           = sidebar, Name = uid(),
			AnchorPoint      = V2(1, 0),
			Position         = U2.fromScale(1, 0),
			Size             = U2.new(0, 1, 1, 0),
			BackgroundColor3 = Library.Theme.Border,
			BorderSizePixel  = 0,
			ZIndex           = 4,
		})
		themed(sidebarBorderLine, { BackgroundColor3 = "Border" })

		local tabList = make("ScrollingFrame", {
			Parent                  = sidebar, Name = uid(),
			Position                = U2.fromOffset(0, 8),
			Size                    = U2.new(1, -1, 1, -8),
			BackgroundTransparency  = 1,
			BorderSizePixel         = 0,
			ScrollBarThickness      = 0,
			CanvasSize              = U2.fromOffset(0, 0),
			AutomaticCanvasSize     = Enum.AutomaticSize.Y,
			ZIndex                  = 4,
		})
		make("UIListLayout", {
			Parent    = tabList,
			Padding   = U(0, 3),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
		pad(tabList, 0, 8, 6, 6)

		local contentArea = make("Frame", {
			Parent              = mainFrame, Name = uid(),
			Position            = U2.fromOffset(168, 38),
			Size                = U2.new(1, -168, 1, -38),
			BackgroundTransparency = 1,
			BorderSizePixel     = 0,
			ZIndex              = 2,
		})

		local Window = {
			_mainFrame  = mainFrame,
			_sidebar    = sidebar,
			_tabList    = tabList,
			_content    = contentArea,
			_pages      = {},
			_activePage = nil,
		}

		function Window:CreateTabBar()
			local TabBar = { _window = self, _tabs = {} }

			function TabBar:Add(tabName, tabIcon)
				local pageFrame = make("Frame", {
					Parent              = self._window._content,
					Name                = uid(),
					Size                = U2.fromScale(1, 1),
					BackgroundTransparency = 1,
					Visible             = false,
					ZIndex              = 2,
				})

			local colHolder = make("Frame", {
				Parent              = pageFrame, Name = uid(),
				Position            = U2.fromOffset(0, 0),
				Size                = U2.fromScale(1, 1),
				BackgroundTransparency = 1,
				ZIndex              = 2,
				ClipsDescendants    = false,
			})
			pad(colHolder, 8, 8, 8, 8)

			local col1 = make("ScrollingFrame", {
				Parent                 = colHolder, Name = uid(),
				Position               = U2.fromScale(0, 0),
				Size                   = U2.new(0.5, -4, 1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel        = 0,
				ScrollBarThickness     = 0,
				CanvasSize             = U2.fromOffset(0, 0),
				AutomaticCanvasSize    = Enum.AutomaticSize.Y,
				ZIndex                 = 2,
			})
			make("UIListLayout", { Parent = col1, Padding = U(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })

			local col2 = make("ScrollingFrame", {
				Parent                 = colHolder, Name = uid(),
				Position               = U2.new(0.5, 4, 0, 0),
				Size                   = U2.new(0.5, -4, 1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel        = 0,
				ScrollBarThickness     = 0,
				CanvasSize             = U2.fromOffset(0, 0),
				AutomaticCanvasSize    = Enum.AutomaticSize.Y,
				ZIndex                 = 2,
			})
			make("UIListLayout", { Parent = col2, Padding = U(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })

				Library.SearchItems[pageFrame] = {}

				local tabBtn = make("TextButton", {
					Parent              = self._window._tabList, Name = uid(),
					Size                = U2.new(1, 0, 0, 34),
					BackgroundColor3    = Library.Theme.SurfaceAlt,
					BackgroundTransparency = 1,
					BorderSizePixel     = 0,
					AutoButtonColor     = false,
					Text                = "",
					ZIndex              = 5,
				})
				corner(tabBtn, 6)

				local accentPill = make("Frame", {
					Parent           = tabBtn, Name = uid(),
					AnchorPoint      = V2(0, 0.5),
					Position         = U2.fromOffset(-6, 0),
					Size             = U2.new(0, 3, 0.6, 0),
					BackgroundColor3 = Library.Theme.Accent,
					BackgroundTransparency = 1,
					BorderSizePixel  = 0,
					ZIndex           = 6,
				})
				themed(accentPill, { BackgroundColor3 = "Accent" })
				corner(accentPill, 3)

				local btnRow = make("Frame", {
					Parent              = tabBtn, Name = uid(),
					BackgroundTransparency = 1,
					AnchorPoint         = V2(0, 0.5),
					Position            = U2.fromOffset(8, 0),
					Size                = U2.new(1, -16, 0, 20),
					ZIndex              = 6,
				})
				make("UIListLayout", {
					Parent            = btnRow,
					FillDirection     = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding           = U(0, 7),
				})

				if tabIcon then
					makeIconLabel(btnRow, tabIcon, 14, 7)
				end

				local tabLbl = make("TextLabel", {
					Parent              = btnRow, Name = uid(),
					Text                = tabName,
					FontFace            = Library.Font,
					TextSize            = 13,
					TextColor3          = Library.Theme.TextMuted,
					BackgroundTransparency = 1,
					Size                = U2.fromOffset(0, 20),
					AutomaticSize       = Enum.AutomaticSize.X,
					TextXAlignment      = Enum.TextXAlignment.Left,
					ZIndex              = 6,
				})
				themed(tabLbl, { TextColor3 = "TextMuted" })

				local Tab = {
					_page     = pageFrame,
					_col1     = col1,
					_col2     = col2,
					_tabBtn   = tabBtn,
					_accentPill = accentPill,
					_tabLbl   = tabLbl,
					_bar      = self,
					Name      = tabName,
				}

				local function activateTab()
					for _, t in self._tabs do
						if t == Tab then
							tw(t._tabBtn, { BackgroundTransparency = 0.85 })
							tw(t._accentPill, { BackgroundTransparency = 0 })
							tw(t._tabLbl, { TextColor3 = Library.Theme.Text })
							t._page.Visible = true
						else
							tw(t._tabBtn, { BackgroundTransparency = 1 })
							tw(t._accentPill, { BackgroundTransparency = 1 })
							tw(t._tabLbl, { TextColor3 = Library.Theme.TextMuted })
							t._page.Visible = false
						end
					end
					Library.SearchItems._current = pageFrame
				end

				connect(tabBtn.MouseButton1Click, activateTab)
				connect(tabBtn.MouseEnter, function()
					if Tab._page.Visible then return end
					tw(tabBtn, { BackgroundTransparency = 0.93 })
				end)
				connect(tabBtn.MouseLeave, function()
					if Tab._page.Visible then return end
					tw(tabBtn, { BackgroundTransparency = 1 })
				end)

				ins(self._tabs, Tab)
				if #self._tabs == 1 then activateTab() end

				function Tab:AddLeftGroupbox(gbName, gbIcon)
					return _makeGroupbox(self._col1, gbName, gbIcon, self._page)
				end

				function Tab:AddRightGroupbox(gbName, gbIcon)
					return _makeGroupbox(self._col2, gbName, gbIcon, self._page)
				end

				function Tab:AddGroupbox(gbName, gbIcon)
					return self:AddLeftGroupbox(gbName, gbIcon)
				end

				return Tab
			end

			return TabBar
		end

		return Window
	end

	-- [GROUPBOX]

	function _makeGroupbox(parent, gbName, gbIcon, page)
		local gbFrame = make("Frame", {
			Parent           = parent, Name = uid(),
			BackgroundColor3 = Library.Theme.SurfaceAlt,
			BorderSizePixel  = 0,
			AutomaticSize    = Enum.AutomaticSize.Y,
			Size             = U2.fromScale(1, 0),
			ZIndex           = 3,
		})
		themed(gbFrame, { BackgroundColor3 = "SurfaceAlt" })
		corner(gbFrame, 7)
		local gbStroke = stroke(gbFrame, Library.Theme.Border, 1)
		themed(gbStroke, { Color = "Border" })

		local textXOff = gbIcon and 26 or 8

		local headerRow = make("Frame", {
			Parent              = gbFrame, Name = uid(),
			BackgroundTransparency = 1,
			Size                = U2.new(1, 0, 0, 28),
			ZIndex              = 4,
		})

		if gbIcon then
			local ic = makeIconLabel(headerRow, gbIcon, 13, 5)
			ic.AnchorPoint = V2(0, 0.5)
			ic.Position    = U2.fromOffset(8, 14)
		end

		local gbTitleLbl = make("TextLabel", {
			Parent              = headerRow, Name = uid(),
			Text                = gbName or "Groupbox",
			FontFace            = Library.Font,
			TextSize            = 13,
			TextColor3          = Library.Theme.Text,
			BackgroundTransparency = 1,
			AnchorPoint         = V2(0, 0.5),
			Position            = U2.fromOffset(textXOff, 14),
			Size                = U2.fromOffset(0, 16),
			AutomaticSize       = Enum.AutomaticSize.X,
			ZIndex              = 4,
		})
		themed(gbTitleLbl, { TextColor3 = "Text" })

		local sepLine = make("Frame", {
			Parent           = gbFrame, Name = uid(),
			Position         = U2.fromOffset(8, 28),
			Size             = U2.new(1, -16, 0, 1),
			BackgroundColor3 = Library.Theme.Border,
			BackgroundTransparency = 0.4,
			BorderSizePixel  = 0,
			ZIndex           = 4,
		})
		themed(sepLine, { BackgroundColor3 = "Border" })

		local content = make("Frame", {
			Parent              = gbFrame, Name = uid(),
			Position            = U2.fromOffset(8, 36),
			Size                = U2.new(1, -16, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize       = Enum.AutomaticSize.Y,
			ZIndex              = 4,
		})
		make("UIListLayout", { Parent = content, Padding = U(0, 5), SortOrder = Enum.SortOrder.LayoutOrder })
		make("UIPadding", { Parent = gbFrame, PaddingBottom = U(0, 8) })

		local Groupbox = {
			_frame   = gbFrame,
			_content = content,
			_page    = page,
		}

		function Groupbox:AddBlank(height)
			make("Frame", {
				Parent              = self._content, Name = uid(),
				BackgroundTransparency = 1,
				Size                = U2.fromOffset(0, height or 6),
				ZIndex              = 5,
			})
		end

		function Groupbox:AddDivider(arg)
			local divText, marginTop, marginBottom
			if type(arg) == "table" then
				divText    = arg.Text or arg.text
				local mg   = arg.Margin or arg.margin or 3
				marginTop  = arg.MarginTop or mg
				marginBottom = arg.MarginBottom or mg
			else
				divText = arg
				marginTop, marginBottom = 3, 3
			end

			local hasText = type(divText) == "string" and divText ~= ""
			local innerH  = hasText and 13 or 1
			local totalH  = innerH + marginTop + marginBottom

			local container = make("Frame", {
				Parent              = self._content, Name = uid(),
				BackgroundTransparency = 1,
			Size                = U2.new(1, 0, 0, totalH),
				ZIndex              = 5,
			})

			local lineY = marginTop + (hasText and mFloor(innerH / 2) or 0)
			local lineF = make("Frame", {
				Parent           = container, Name = uid(),
				Size             = U2.new(1, 0, 0, 1),
				Position         = U2.fromOffset(0, lineY),
				BackgroundColor3 = Library.Theme.Border,
				BackgroundTransparency = 0.2,
				BorderSizePixel  = 0,
				ZIndex           = 6,
			})
			themed(lineF, { BackgroundColor3 = "Border" })

			if hasText then
				local textBg = make("Frame", {
					Parent           = container, Name = uid(),
					AnchorPoint      = V2(0.5, 0),
					Position         = U2.new(0.5, 0, 0, marginTop),
					Size             = U2.fromOffset(0, innerH),
					AutomaticSize    = Enum.AutomaticSize.X,
					BackgroundColor3 = Library.Theme.SurfaceAlt,
					BorderSizePixel  = 0,
					ZIndex           = 7,
				})
				themed(textBg, { BackgroundColor3 = "SurfaceAlt" })
				pad(textBg, 0, 0, 5, 5)

				make("TextLabel", {
					Parent              = textBg, Name = uid(),
					Text                = divText,
					FontFace            = Library.Font,
					TextSize            = 11,
					TextColor3          = Library.Theme.TextMuted,
					BackgroundTransparency = 1,
					Size                = U2.fromOffset(0, innerH),
					AutomaticSize       = Enum.AutomaticSize.X,
					ZIndex              = 8,
				})
			end
		end

		function Groupbox:AddLabel(text, richText)
			local row = make("Frame", {
				Parent              = self._content, Name = uid(),
				BackgroundTransparency = 1,
				Size                = U2.new(1, 0, 0, 20),
				ZIndex              = 5,
			})
			local lbl = make("TextLabel", {
				Parent              = row, Name = uid(),
				Text                = tostring(text or ""),
				FontFace            = Library.Font,
				TextSize            = 13,
				TextColor3          = Library.Theme.TextMuted,
				TextXAlignment      = Enum.TextXAlignment.Left,
				TextWrapped         = true,
				RichText            = richText == true,
				BackgroundTransparency = 1,
				Size                = U2.fromScale(1, 1),
				ZIndex              = 5,
			})
			themed(lbl, { TextColor3 = "TextMuted" })

			local Label = { _row = row, _lbl = lbl }
			function Label:SetText(t) lbl.Text = tostring(t or "") end
			function Label:SetColor(c) lbl.TextColor3 = c end

			if page then
				local sd = Library.SearchItems[page]
				if sd then ins(sd, { Name = tostring(text or ""), Item = row }) end
			end
			return Label
		end

		function Groupbox:AddToggle(flag, config)
			config = config or {}
			local text     = config.Text     or flag or "Toggle"
			local default  = config.Default  ~= nil and config.Default or false
			local tooltip  = config.Tooltip
			local disabled = config.Disabled or false
			local cb       = config.Callback or function() end

			local row = make("Frame", {
				Parent              = self._content, Name = uid(),
				BackgroundTransparency = 1,
				Size                = U2.new(1, 0, 0, 26),
				ZIndex              = 5,
			})

			local textLbl = make("TextLabel", {
				Parent              = row, Name = uid(),
				Text                = text,
				FontFace            = Library.Font,
				TextSize            = 13,
				TextColor3          = Library.Theme.Text,
				TextXAlignment      = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				AnchorPoint         = V2(0, 0.5),
				Position            = U2.fromOffset(2, 0),
				Size                = U2.new(1, -40, 1, 0),
				ZIndex              = 5,
			})
			themed(textLbl, { TextColor3 = "Text" })

			local pillW, pillH = 32, 17
			local pillBg = make("Frame", {
				Parent           = row, Name = uid(),
				AnchorPoint      = V2(1, 0.5),
				Position         = U2.new(1, -2, 0.5, 0),
				Size             = U2.fromOffset(pillW, pillH),
				BackgroundColor3 = Library.Theme.ToggleOff,
				BorderSizePixel  = 0,
				ZIndex           = 6,
			})
			themed(pillBg, { BackgroundColor3 = "ToggleOff" })
			corner(pillBg, pillH)

			local knob = make("Frame", {
				Parent           = pillBg, Name = uid(),
				AnchorPoint      = V2(0, 0.5),
				Position         = U2.fromOffset(2, 0),
				Size             = U2.fromOffset(pillH - 4, pillH - 4),
				BackgroundColor3 = RGB(255, 255, 255),
				BorderSizePixel  = 0,
				ZIndex           = 7,
			})
			corner(knob, pillH)

			local Toggle = {
				Value    = default,
				Flag     = flag,
				Disabled = disabled,
				_row     = row,
				_pill    = pillBg,
				_knob    = knob,
				_cbs     = { cb },
			}

			local function updateVisuals(val, instant)
				if val then
					local fn = instant and function(i, p) i[next(p)] = p[next(p)] end or tw
					tw(pillBg, { BackgroundColor3 = Library.Theme.Accent }, instant and 0 or 0.15)
					tw(knob, { Position = U2.fromOffset(pillW - (pillH - 4) - 2, 0) }, instant and 0 or 0.15)
				else
					tw(pillBg, { BackgroundColor3 = Library.Theme.ToggleOff }, instant and 0 or 0.15)
					tw(knob, { Position = U2.fromOffset(2, 0) }, instant and 0 or 0.15)
				end
				textLbl.TextColor3 = val and Library.Theme.Text or Library.Theme.TextMuted
			end

			function Toggle:SetValue(val)
				self.Value = val
				Library.Flags[flag] = val
				updateVisuals(val)
				for _, fn in self._cbs do pcall(fn, val) end
			end

			function Toggle:OnChanged(fn)
				ins(self._cbs, fn)
				fn(self.Value)
			end

			updateVisuals(default, true)

			local hitbox = make("TextButton", {
				Parent              = row, Name = uid(),
				Size                = U2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text                = "",
				ZIndex              = 8,
				AutoButtonColor     = false,
			})
			connect(hitbox.MouseButton1Click, function()
				if Toggle.Disabled then return end
				Toggle:SetValue(not Toggle.Value)
			end)

			Library.Toggles[flag]  = Toggle
			Library.Flags[flag]    = default
			Library.SetFlags[flag] = function(v) Toggle:SetValue(v) end

			if page then
				local sd = Library.SearchItems[page]
				if sd then ins(sd, { Name = text, Item = row }) end
			end
			return Toggle
		end

		function Groupbox:AddSlider(flag, config)
			config = config or {}
			local text     = config.Text     or flag or "Slider"
			local default  = config.Default  or 0
			local min      = config.Min      or 0
			local max      = config.Max      or 100
			local suffix   = config.Suffix   or ""
			local rounding = config.Rounding or config.Decimals or 0
			local disabled = config.Disabled or false
			local cb       = config.Callback or function() end

			local row = make("Frame", {
				Parent              = self._content, Name = uid(),
				BackgroundTransparency = 1,
				Size                = U2.new(1, 0, 0, 40),
				ZIndex              = 5,
			})

			local topRow = make("Frame", {
				Parent              = row, Name = uid(),
				BackgroundTransparency = 1,
				Size                = U2.new(1, 0, 0, 18),
				ZIndex              = 5,
			})

			local textLbl = make("TextLabel", {
				Parent              = topRow, Name = uid(),
				Text                = text,
				FontFace            = Library.Font,
				TextSize            = 13,
				TextColor3          = Library.Theme.Text,
				TextXAlignment      = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				AnchorPoint         = V2(0, 0.5),
				Position            = U2.fromOffset(0, 9),
				Size                = U2.new(0.7, 0, 1, 0),
				ZIndex              = 5,
			})
			themed(textLbl, { TextColor3 = "Text" })

			local valLbl = make("TextLabel", {
				Parent              = topRow, Name = uid(),
				Text                = tostring(default) .. suffix,
				FontFace            = Library.Font,
				TextSize            = 12,
				TextColor3          = Library.Theme.Accent,
				TextXAlignment      = Enum.TextXAlignment.Right,
				BackgroundTransparency = 1,
				AnchorPoint         = V2(1, 0.5),
				Position            = U2.new(1, 0, 0.5, 0),
				Size                = U2.new(0.3, 0, 1, 0),
				ZIndex              = 5,
			})
			themed(valLbl, { TextColor3 = "Accent" })

			local trackBg = make("Frame", {
				Parent           = row, Name = uid(),
				Position         = U2.fromOffset(0, 24),
				Size             = U2.new(1, 0, 0, 6),
				BackgroundColor3 = Library.Theme.Border,
				BackgroundTransparency = 0.3,
				BorderSizePixel  = 0,
				ZIndex           = 5,
			})
			corner(trackBg, 4)
			themed(trackBg, { BackgroundColor3 = "Border" })

			local trackFill = make("Frame", {
				Parent           = trackBg, Name = uid(),
				Size             = U2.fromScale(0, 1),
				BackgroundColor3 = Library.Theme.Accent,
				BorderSizePixel  = 0,
				ZIndex           = 6,
			})
			corner(trackFill, 4)
			themed(trackFill, { BackgroundColor3 = "Accent" })

			local knob = make("Frame", {
				Parent           = trackBg, Name = uid(),
				AnchorPoint      = V2(0.5, 0.5),
				Position         = U2.fromScale(0, 0.5),
				Size             = U2.fromOffset(12, 12),
				BackgroundColor3 = RGB(255, 255, 255),
				BorderSizePixel  = 0,
				ZIndex           = 7,
			})
			corner(knob, 12)
			make("UIStroke", { Parent = knob, Color = Library.Theme.Accent, Thickness = 2 })

			local Slider = {
				Value    = default,
				Flag     = flag,
				Disabled = disabled,
				_row     = row,
				_cbs     = { cb },
			}

			local function clampVal(v)
				if rounding == 0 then
					v = mFloor(v)
				else
					v = mFloor(v / rounding + 0.5) * rounding
				end
				return mClamp(v, min, max)
			end

			local function updateSlider(pct, fromInput)
				local v = clampVal(min + (max - min) * pct)
				Slider.Value = v
				Library.Flags[flag] = v
				local displayPct = (v - min) / (max - min)
				trackFill.Size = U2.fromScale(displayPct, 1)
				knob.Position  = U2.new(displayPct, 0, 0.5, 0)
				valLbl.Text    = (rounding == 0 and tostring(v) or sFormat("%.2f", v):gsub("%.?0+$", "")) .. suffix
				if fromInput then
					for _, fn in Slider._cbs do pcall(fn, v) end
				end
			end

			local pct0 = (default - min) / (max - min)
			updateSlider(mClamp(pct0, 0, 1), false)

			function Slider:SetValue(v)
				local pct = (mClamp(v, min, max) - min) / (max - min)
				updateSlider(pct, true)
			end

			function Slider:OnChanged(fn)
				ins(self._cbs, fn)
				fn(self.Value)
			end

			local draggingSlider = false
			connect(trackBg.InputBegan, function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1 then
					draggingSlider = true
					local pct = mClamp((inp.Position.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
					updateSlider(pct, true)
				end
			end)
			connect(UIS.InputChanged, function(inp)
				if draggingSlider and inp.UserInputType == Enum.UserInputType.MouseMovement then
					local pct = mClamp((inp.Position.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
					updateSlider(pct, true)
				end
			end)
			connect(UIS.InputEnded, function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1 then
					draggingSlider = false
				end
			end)

			Library.Options[flag]  = Slider
			Library.Flags[flag]    = default
			Library.SetFlags[flag] = function(v) Slider:SetValue(v) end

			if page then
				local sd = Library.SearchItems[page]
				if sd then ins(sd, { Name = text, Item = row }) end
			end
			return Slider
		end

		function Groupbox:AddDropdown(flag, config)
			config = config or {}
			local text     = config.Text    or flag or "Dropdown"
			local values   = config.Values  or {}
			local default  = config.Default
			local multi    = config.Multi   == true
			local disabled = config.Disabled or false
			local cb       = config.Callback or function() end

			local row = make("Frame", {
				Parent              = self._content, Name = uid(),
				BackgroundTransparency = 1,
				Size                = U2.new(1, 0, 0, 48),
				ZIndex              = 5,
				ClipsDescendants    = false,
			})

			local textLbl = make("TextLabel", {
				Parent              = row, Name = uid(),
				Text                = text,
				FontFace            = Library.Font,
				TextSize            = 13,
				TextColor3          = Library.Theme.Text,
				TextXAlignment      = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Position            = U2.fromOffset(0, 0),
				Size                = U2.new(1, 0, 0, 18),
				ZIndex              = 5,
			})
			themed(textLbl, { TextColor3 = "Text" })

			local btnFrame = make("Frame", {
				Parent           = row, Name = uid(),
				Position         = U2.fromOffset(0, 22),
				Size             = U2.new(1, 0, 0, 26),
				BackgroundColor3 = Library.Theme.Surface,
				BorderSizePixel  = 0,
				ZIndex           = 5,
			})
			themed(btnFrame, { BackgroundColor3 = "Surface" })
			corner(btnFrame, 5)
			local btnStroke = stroke(btnFrame, Library.Theme.Border, 1)
			themed(btnStroke, { Color = "Border" })

			local selLbl = make("TextLabel", {
				Parent              = btnFrame, Name = uid(),
				Text                = multi and "None selected" or (default or "Select..."),
				FontFace            = Library.Font,
				TextSize            = 12,
				TextColor3          = Library.Theme.TextMuted,
				TextXAlignment      = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				AnchorPoint         = V2(0, 0.5),
				Position            = U2.fromOffset(8, 0),
				Size                = U2.new(1, -26, 1, 0),
				ZIndex              = 6,
				ClipsDescendants    = true,
			})
			themed(selLbl, { TextColor3 = "TextMuted" })

			local arrowLbl = make("TextLabel", {
				Parent              = btnFrame, Name = uid(),
				Text                = "▾",
				FontFace            = Library.Font,
				TextSize            = 13,
				TextColor3          = Library.Theme.TextMuted,
				BackgroundTransparency = 1,
				AnchorPoint         = V2(1, 0.5),
				Position            = U2.new(1, -6, 0.5, 0),
				Size                = U2.fromOffset(14, 16),
				ZIndex              = 6,
			})
			themed(arrowLbl, { TextColor3 = "TextMuted" })

			local Dropdown = {
				Value    = multi and {} or default,
				Values   = values,
				Flag     = flag,
				Disabled = disabled,
				Multi    = multi,
				_cbs     = { cb },
				_row     = row,
			}

			local function getDisplayText()
				if multi then
					if type(Dropdown.Value) == "table" and #Dropdown.Value > 0 then
						return table.concat(Dropdown.Value, ", ")
					end
					return "None selected"
				else
					return tostring(Dropdown.Value or "Select...")
				end
			end

			local function updateDisplay()
				selLbl.Text = getDisplayText()
				selLbl.TextColor3 = (Dropdown.Value and (not multi or #Dropdown.Value > 0)) and Library.Theme.Text or Library.Theme.TextMuted
			end
			updateDisplay()

			local open = false
			local listFrame

			local lastListW = 0
			local function closeDropdown()
				if listFrame then
					tw(listFrame, { BackgroundTransparency = 1, Size = U2.fromOffset(lastListW, 0) }, 0.15)
					task.delay(0.16, function()
						if listFrame then listFrame:Destroy() listFrame = nil end
					end)
				end
				tw(arrowLbl, { Rotation = 0 }, 0.15)
				open = false
			end

			local function openDropdown()
				if listFrame then listFrame:Destroy() listFrame = nil end

				local itemH = 26
				local maxVisible = math.min(#values, 6)
				local listH = maxVisible * itemH + 6

				listFrame = make("Frame", {
					Parent              = Library.Holder, Name = uid(),
					BackgroundColor3    = Library.Theme.Surface,
					BorderSizePixel     = 0,
					Size                = U2.fromOffset(0, 0),
					ZIndex              = 50,
					ClipsDescendants    = true,
				})
				themed(listFrame, { BackgroundColor3 = "Surface" })
				corner(listFrame, 6)
				local lStroke = stroke(listFrame, Library.Theme.Border, 1)
				themed(lStroke, { Color = "Border" })

				local scrollFrame = make("ScrollingFrame", {
					Parent                 = listFrame, Name = uid(),
					Size                   = U2.fromScale(1, 1),
					BackgroundTransparency = 1,
					BorderSizePixel        = 0,
					ScrollBarThickness     = 3,
					ScrollBarImageColor3   = Library.Theme.Border,
					CanvasSize             = U2.fromOffset(0, 0),
					AutomaticCanvasSize    = Enum.AutomaticSize.Y,
					ZIndex                 = 51,
				})
				make("UIListLayout", { Parent = scrollFrame, Padding = U(0, 1), SortOrder = Enum.SortOrder.LayoutOrder })
				pad(scrollFrame, 3, 3, 3, 3)

				for _, val in values do
					local itemBtn = make("TextButton", {
						Parent              = scrollFrame, Name = uid(),
						Size                = U2.new(1, 0, 0, itemH - 1),
						BackgroundColor3    = Library.Theme.SurfaceAlt,
						BackgroundTransparency = 1,
						BorderSizePixel     = 0,
						AutoButtonColor     = false,
						Text                = "",
						ZIndex              = 52,
					})
					corner(itemBtn, 4)

					local isSelected = multi and find(Dropdown.Value, val) or Dropdown.Value == val

					make("TextLabel", {
						Parent              = itemBtn, Name = uid(),
						Text                = tostring(val),
						FontFace            = Library.Font,
						TextSize            = 12,
						TextColor3          = isSelected and Library.Theme.Accent or Library.Theme.Text,
						TextXAlignment      = Enum.TextXAlignment.Left,
						BackgroundTransparency = 1,
						AnchorPoint         = V2(0, 0.5),
						Position            = U2.fromOffset(8, 0),
						Size                = U2.new(1, -8, 1, 0),
						ZIndex              = 53,
					})

					connect(itemBtn.MouseEnter, function()
						tw(itemBtn, { BackgroundTransparency = 0.8 })
					end)
					connect(itemBtn.MouseLeave, function()
						tw(itemBtn, { BackgroundTransparency = 1 })
					end)
					connect(itemBtn.MouseButton1Click, function()
						if multi then
							local idx = find(Dropdown.Value, val)
							if idx then
								rem(Dropdown.Value, idx)
							else
								ins(Dropdown.Value, val)
							end
							Library.Flags[flag] = Dropdown.Value
							updateDisplay()
							for _, fn in Dropdown._cbs do pcall(fn, Dropdown.Value) end
							closeDropdown()
						else
							Dropdown.Value = val
							Library.Flags[flag] = val
							updateDisplay()
							for _, fn in Dropdown._cbs do pcall(fn, val) end
							closeDropdown()
						end
					end)
				end

			local absPos  = btnFrame.AbsolutePosition
			local absSize = btnFrame.AbsoluteSize
			local listW   = absSize.X
			lastListW     = listW

			listFrame.Position = U2.fromOffset(absPos.X, absPos.Y + absSize.Y + 3)
			listFrame.Size     = U2.fromOffset(listW, 0)

				tw(listFrame, { Size = U2.fromOffset(listW, listH) }, 0.15)
				tw(arrowLbl, { Rotation = 180 }, 0.15)
				open = true

				connect(UIS.InputBegan, function(inp, gpe)
					if not gpe and inp.UserInputType == Enum.UserInputType.MouseButton1 then
						if listFrame and not Library:_isMouseOver(listFrame) and not Library:_isMouseOver(btnFrame) then
							closeDropdown()
						end
					end
				end)
			end

			local ddBtn = make("TextButton", {
				Parent              = btnFrame, Name = uid(),
				Size                = U2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text                = "",
				ZIndex              = 7,
				AutoButtonColor     = false,
			})
			connect(ddBtn.MouseButton1Click, function()
				if Dropdown.Disabled then return end
				if open then closeDropdown() else openDropdown() end
			end)

			function Dropdown:SetValue(v)
				if multi then
					self.Value = type(v) == "table" and v or { v }
				else
					self.Value = v
				end
				Library.Flags[flag] = self.Value
				updateDisplay()
				for _, fn in self._cbs do pcall(fn, self.Value) end
			end

			function Dropdown:AddValue(v)
				if not find(self.Values, v) then ins(self.Values, v) end
			end

			function Dropdown:RemoveValue(v)
				local i = find(self.Values, v)
				if i then rem(self.Values, i) end
			end

			function Dropdown:OnChanged(fn)
				ins(self._cbs, fn)
				fn(self.Value)
			end

			Library.Options[flag]  = Dropdown
			Library.Flags[flag]    = multi and {} or default
			Library.SetFlags[flag] = function(v) Dropdown:SetValue(v) end

			if page then
				local sd = Library.SearchItems[page]
				if sd then ins(sd, { Name = text, Item = row }) end
			end
			return Dropdown
		end

		function Groupbox:AddInput(flag, config)
			config = config or {}
			local text     = config.Text        or flag or "Input"
			local default  = config.Default     or ""
			local ph       = config.Placeholder or "Type here..."
			local numeric  = config.Numeric     == true
			local finished = config.Finished    ~= false
			local disabled = config.Disabled    or false
			local cb       = config.Callback    or function() end

			local row = make("Frame", {
				Parent              = self._content, Name = uid(),
				BackgroundTransparency = 1,
				Size                = U2.new(1, 0, 0, 48),
				ZIndex              = 5,
			})

			make("TextLabel", {
				Parent              = row, Name = uid(),
				Text                = text,
				FontFace            = Library.Font,
				TextSize            = 13,
				TextColor3          = Library.Theme.Text,
				TextXAlignment      = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Position            = U2.fromOffset(0, 0),
				Size                = U2.new(1, 0, 0, 18),
				ZIndex              = 5,
			})

			local inputFrame = make("Frame", {
				Parent           = row, Name = uid(),
				Position         = U2.fromOffset(0, 22),
				Size             = U2.new(1, 0, 0, 26),
				BackgroundColor3 = Library.Theme.Surface,
				BorderSizePixel  = 0,
				ZIndex           = 5,
			})
			themed(inputFrame, { BackgroundColor3 = "Surface" })
			corner(inputFrame, 5)
			local inpStroke = stroke(inputFrame, Library.Theme.Border, 1)
			themed(inpStroke, { Color = "Border" })

			local inputBox = make("TextBox", {
				Parent              = inputFrame, Name = uid(),
				Text                = default,
				PlaceholderText     = ph,
				FontFace            = Library.Font,
				TextSize            = 12,
				TextColor3          = Library.Theme.Text,
				PlaceholderColor3   = Library.Theme.TextMuted,
				TextXAlignment      = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				AnchorPoint         = V2(0, 0.5),
				Position            = U2.fromOffset(8, 0),
				Size                = U2.new(1, -16, 1, 0),
				ClearTextOnFocus    = false,
				ZIndex              = 6,
			})
			themed(inputBox, { TextColor3 = "Text", PlaceholderColor3 = "TextMuted" })

			connect(inputBox.Focused, function()
				tw(inpStroke, { Color = Library.Theme.Accent, Thickness = 1.5 }, 0.15)
			end)
			connect(inputBox.FocusLost, function(enterPressed)
				tw(inpStroke, { Color = Library.Theme.Border, Thickness = 1 }, 0.15)
				if numeric then
					local n = tonumber(inputBox.Text)
					inputBox.Text = n and tostring(n) or default
				end
				if finished and enterPressed then
					cb(inputBox.Text)
				elseif not finished then
					cb(inputBox.Text)
				end
			end)

			if not finished then
				connect(inputBox:GetPropertyChangedSignal("Text"), function()
					cb(inputBox.Text)
				end)
			end

			local Input = {
				Value    = default,
				Flag     = flag,
				Disabled = disabled,
				_box     = inputBox,
				_cbs     = { cb },
			}

			function Input:SetValue(v)
				inputBox.Text = tostring(v or "")
				self.Value    = tostring(v or "")
				Library.Flags[flag] = self.Value
			end

			function Input:OnChanged(fn)
				ins(self._cbs, fn)
				fn(self.Value)
			end

			Library.Options[flag]  = Input
			Library.Flags[flag]    = default
			Library.SetFlags[flag] = function(v) Input:SetValue(v) end

			if page then
				local sd = Library.SearchItems[page]
				if sd then ins(sd, { Name = text, Item = row }) end
			end
			return Input
		end

		function Groupbox:AddColorPicker(flag, config)
			config = config or {}
			local text        = config.Text         or flag or "Color"
			local default     = config.Default      or RGB(255, 255, 255)
			local transparency = config.Transparency or 0
			local disabled    = config.Disabled     or false
			local cb          = config.Callback     or function() end

			local row = make("Frame", {
				Parent              = self._content, Name = uid(),
				BackgroundTransparency = 1,
				Size                = U2.new(1, 0, 0, 26),
				ZIndex              = 5,
			})

			local textLbl = make("TextLabel", {
				Parent              = row, Name = uid(),
				Text                = text,
				FontFace            = Library.Font,
				TextSize            = 13,
				TextColor3          = Library.Theme.Text,
				TextXAlignment      = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				AnchorPoint         = V2(0, 0.5),
				Position            = U2.fromOffset(0, 0),
				Size                = U2.new(1, -30, 1, 0),
				ZIndex              = 5,
			})
			themed(textLbl, { TextColor3 = "Text" })

			local preview = make("Frame", {
				Parent           = row, Name = uid(),
				AnchorPoint      = V2(1, 0.5),
				Position         = U2.new(1, -2, 0.5, 0),
				Size             = U2.fromOffset(22, 16),
				BackgroundColor3 = default,
				BorderSizePixel  = 0,
				ZIndex           = 6,
			})
			corner(preview, 4)
			stroke(preview, Library.Theme.Border, 1)

			local CP = {
				Value        = default,
				Transparency = transparency,
				Flag         = flag,
				Disabled     = disabled,
				_preview     = preview,
				_cbs         = { cb },
			}

			local cpOpen = false
			local cpFrame

			local function closeCP()
				if cpFrame then
					tw(cpFrame, { BackgroundTransparency = 1 }, 0.15)
					task.delay(0.16, function()
						if cpFrame then cpFrame:Destroy() cpFrame = nil end
					end)
				end
				cpOpen = false
			end

			local function openCP()
				if cpFrame then cpFrame:Destroy() cpFrame = nil end

				cpFrame = make("Frame", {
					Parent              = Library.Holder, Name = uid(),
					Size                = U2.fromOffset(220, 200),
					BackgroundColor3    = Library.Theme.Surface,
					BorderSizePixel     = 0,
					ZIndex              = 60,
					BackgroundTransparency = 1,
				})
				themed(cpFrame, { BackgroundColor3 = "Surface" })
				corner(cpFrame, 8)
				local cpStroke = stroke(cpFrame, Library.Theme.Border, 1)
				themed(cpStroke, { Color = "Border" })
				pad(cpFrame, 10, 10, 10, 10)

				local absPos = preview.AbsolutePosition
				cpFrame.Position = U2.fromOffset(absPos.X - 200, absPos.Y + 20)

				local h, s, v = CP.Value:ToHSV()

				local svFrame = make("Frame", {
					Parent           = cpFrame, Name = uid(),
					Size             = U2.new(1, 0, 0, 130),
					BackgroundColor3 = HSV(h, 1, 1),
					BorderSizePixel  = 0,
					ZIndex           = 61,
				})
				corner(svFrame, 5)

				make("UIGradient", {
					Parent  = svFrame,
					Color   = ColorSequence.new({ ColorSequenceKeypoint.new(0, RGB(255,255,255)), ColorSequenceKeypoint.new(1, RGB(255,255,255)) }),
					Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }),
				})

				local svOverlay = make("Frame", {
					Parent              = svFrame, Name = uid(),
					Size                = U2.fromScale(1, 1),
					BackgroundTransparency = 0,
					BorderSizePixel     = 0,
					ZIndex              = 62,
				})
				make("UIGradient", {
					Parent  = svOverlay,
					Color   = ColorSequence.new({ ColorSequenceKeypoint.new(0, RGB(0,0,0)), ColorSequenceKeypoint.new(1, RGB(0,0,0)) }),
					Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }),
					Rotation = 90,
				})
				corner(svOverlay, 5)

				local svKnob = make("Frame", {
					Parent           = svFrame, Name = uid(),
					AnchorPoint      = V2(0.5, 0.5),
					Position         = U2.fromScale(s, 1 - v),
					Size             = U2.fromOffset(10, 10),
					BackgroundColor3 = RGB(255, 255, 255),
					BorderSizePixel  = 0,
					ZIndex           = 63,
				})
				corner(svKnob, 10)
				make("UIStroke", { Parent = svKnob, Color = RGB(0,0,0), Thickness = 1 })

				local hueFrame = make("Frame", {
					Parent           = cpFrame, Name = uid(),
					Position         = U2.new(0, 0, 0, 142),
					Size             = U2.new(1, 0, 0, 12),
					BackgroundColor3 = RGB(255, 0, 0),
					BorderSizePixel  = 0,
					ZIndex           = 61,
				})
				corner(hueFrame, 4)
				local hueColors = {}
				for i = 0, 6 do
					ins(hueColors, ColorSequenceKeypoint.new(i/6, HSV(i/6, 1, 1)))
				end
				make("UIGradient", { Parent = hueFrame, Color = ColorSequence.new(hueColors) })

				local hueKnob = make("Frame", {
					Parent           = hueFrame, Name = uid(),
					AnchorPoint      = V2(0.5, 0.5),
					Position         = U2.new(h, 0, 0.5, 0),
					Size             = U2.fromOffset(8, 14),
					BackgroundColor3 = RGB(255, 255, 255),
					BorderSizePixel  = 0,
					ZIndex           = 62,
				})
				corner(hueKnob, 3)
				make("UIStroke", { Parent = hueKnob, Color = RGB(0,0,0), Thickness = 1 })

				local function updateColor()
					local newColor = HSV(h, s, v)
					CP.Value = newColor
					preview.BackgroundColor3 = newColor
					Library.Flags[flag] = { Color = newColor:ToHex(), Alpha = CP.Transparency }
					svFrame.BackgroundColor3 = HSV(h, 1, 1)
					for _, fn in CP._cbs do pcall(fn, newColor, CP.Transparency) end
				end

				local draggingSV, draggingHue = false, false
				connect(svFrame.InputBegan, function(inp)
					if inp.UserInputType == Enum.UserInputType.MouseButton1 then
						draggingSV = true
						s = mClamp((inp.Position.X - svFrame.AbsolutePosition.X) / svFrame.AbsoluteSize.X, 0, 1)
						v = 1 - mClamp((inp.Position.Y - svFrame.AbsolutePosition.Y) / svFrame.AbsoluteSize.Y, 0, 1)
						svKnob.Position = U2.fromScale(s, 1 - v)
						updateColor()
					end
				end)
				connect(hueFrame.InputBegan, function(inp)
					if inp.UserInputType == Enum.UserInputType.MouseButton1 then
						draggingHue = true
						h = mClamp((inp.Position.X - hueFrame.AbsolutePosition.X) / hueFrame.AbsoluteSize.X, 0, 1)
						hueKnob.Position = U2.new(h, 0, 0.5, 0)
						updateColor()
					end
				end)
				connect(UIS.InputChanged, function(inp)
					if inp.UserInputType == Enum.UserInputType.MouseMovement then
						if draggingSV then
							s = mClamp((inp.Position.X - svFrame.AbsolutePosition.X) / svFrame.AbsoluteSize.X, 0, 1)
							v = 1 - mClamp((inp.Position.Y - svFrame.AbsolutePosition.Y) / svFrame.AbsoluteSize.Y, 0, 1)
							svKnob.Position = U2.fromScale(s, 1 - v)
							updateColor()
						elseif draggingHue then
							h = mClamp((inp.Position.X - hueFrame.AbsolutePosition.X) / hueFrame.AbsoluteSize.X, 0, 1)
							hueKnob.Position = U2.new(h, 0, 0.5, 0)
							updateColor()
						end
					end
				end)
				connect(UIS.InputEnded, function(inp)
					if inp.UserInputType == Enum.UserInputType.MouseButton1 then
						draggingSV = false
						draggingHue = false
					end
				end)

				connect(UIS.InputBegan, function(inp, gpe)
					if not gpe and inp.UserInputType == Enum.UserInputType.MouseButton1 then
						if cpFrame and not Library:_isMouseOver(cpFrame) and not Library:_isMouseOver(preview) then
							closeCP()
						end
					end
				end)

				tw(cpFrame, { BackgroundTransparency = 0 }, 0.15)
				cpOpen = true
			end

			local previewBtn = make("TextButton", {
				Parent              = preview, Name = uid(),
				Size                = U2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text                = "",
				ZIndex              = 7,
				AutoButtonColor     = false,
			})
			connect(previewBtn.MouseButton1Click, function()
				if CP.Disabled then return end
				if cpOpen then closeCP() else openCP() end
			end)

			function CP:SetValue(color, alpha)
				if type(color) == "string" then
					local r = tonumber(color:sub(2,3), 16) or 255
					local g = tonumber(color:sub(4,5), 16) or 255
					local b = tonumber(color:sub(6,7), 16) or 255
					color = RGB(r, g, b)
				end
				self.Value       = color
				self.Transparency = alpha or self.Transparency
				preview.BackgroundColor3 = color
				Library.Flags[flag] = { Color = color:ToHex(), Alpha = self.Transparency }
				for _, fn in self._cbs do pcall(fn, color, self.Transparency) end
			end

			function CP:OnChanged(fn)
				ins(self._cbs, fn)
				fn(self.Value, self.Transparency)
			end

			Library.Options[flag]  = CP
			Library.Flags[flag]    = { Color = default:ToHex(), Alpha = transparency }
			Library.SetFlags[flag] = function(c, a) CP:SetValue(c, a) end

			if page then
				local sd = Library.SearchItems[page]
				if sd then ins(sd, { Name = text, Item = row }) end
			end
			return CP
		end

		function Groupbox:AddKeyPicker(flag, config)
			config = config or {}
			local text     = config.Text    or flag or "Keybind"
			local default  = config.Default or "None"
			local mode     = config.Mode    or "Toggle"
			local disabled = config.Disabled or false
			local cb       = config.Callback or function() end

			local Keys = {
				["Backspace"]="Back",["Tab"]="Tab",["Return"]="Enter",["Escape"]="Esc",
				["Space"]="Space",["Delete"]="Del",["Insert"]="Ins",["Home"]="Home",
				["End"]="End",["PageUp"]="PgUp",["PageDown"]="PgDn",
				["LeftShift"]="LShift",["RightShift"]="RShift",["LeftControl"]="LCtrl",
				["RightControl"]="RCtrl",["LeftAlt"]="LAlt",["RightAlt"]="RAlt",
				["F1"]="F1",["F2"]="F2",["F3"]="F3",["F4"]="F4",["F5"]="F5",
				["F6"]="F6",["F7"]="F7",["F8"]="F8",["F9"]="F9",["F10"]="F10",
				["F11"]="F11",["F12"]="F12",
			}
			local function keyName(kc)
				local s = tostring(kc):gsub("Enum.KeyCode.", "")
				return Keys[s] or s
			end

			local row = make("Frame", {
				Parent              = self._content, Name = uid(),
				BackgroundTransparency = 1,
				Size                = U2.new(1, 0, 0, 26),
				ZIndex              = 5,
			})

			make("TextLabel", {
				Parent              = row, Name = uid(),
				Text                = text,
				FontFace            = Library.Font,
				TextSize            = 13,
				TextColor3          = Library.Theme.Text,
				TextXAlignment      = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				AnchorPoint         = V2(0, 0.5),
				Position            = U2.fromOffset(0, 0),
				Size                = U2.new(1, -80, 1, 0),
				ZIndex              = 5,
			})

			local kbFrame = make("Frame", {
				Parent           = row, Name = uid(),
				AnchorPoint      = V2(1, 0.5),
				Position         = U2.new(1, -2, 0.5, 0),
				Size             = U2.fromOffset(74, 18),
				BackgroundColor3 = Library.Theme.Surface,
				BorderSizePixel  = 0,
				ZIndex           = 5,
			})
			themed(kbFrame, { BackgroundColor3 = "Surface" })
			corner(kbFrame, 4)
			stroke(kbFrame, Library.Theme.Border, 1)

			local kbLbl = make("TextLabel", {
				Parent              = kbFrame, Name = uid(),
				Text                = type(default) == "string" and default or keyName(default),
				FontFace            = Library.Font,
				TextSize            = 11,
				TextColor3          = Library.Theme.TextMuted,
				BackgroundTransparency = 1,
				AnchorPoint         = V2(0.5, 0.5),
				Position            = U2.fromScale(0.5, 0.5),
				Size                = U2.fromScale(1, 1),
				ZIndex              = 6,
			})
			themed(kbLbl, { TextColor3 = "TextMuted" })

			local KP = {
				Value    = default,
				Mode     = mode,
				Flag     = flag,
				Disabled = disabled,
				Active   = false,
				_cbs     = { cb },
			}

			local listening = false
			connect(kbFrame.InputBegan, function(inp)
				if inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
				if KP.Disabled then return end
				listening = true
				kbLbl.Text = "..."
				kbLbl.TextColor3 = Library.Theme.Accent
			end)
			connect(UIS.InputBegan, function(inp, gpe)
				if not listening then return end
				if inp.UserInputType == Enum.UserInputType.Keyboard then
					if inp.KeyCode == Enum.KeyCode.Escape then
						KP.Value = "None"
						kbLbl.Text = "None"
					else
						KP.Value = inp.KeyCode
						kbLbl.Text = keyName(inp.KeyCode)
						Library.Flags[flag] = { Key = tostring(inp.KeyCode), Mode = mode }
					end
					kbLbl.TextColor3 = Library.Theme.TextMuted
					listening = false
				end
			end)

			if mode == "Toggle" or mode == "Hold" then
				connect(UIS.InputBegan, function(inp, gpe)
					if gpe or listening then return end
					if type(KP.Value) ~= "userdata" then return end
					if inp.KeyCode == KP.Value then
						if mode == "Toggle" then
							KP.Active = not KP.Active
							for _, fn in KP._cbs do pcall(fn, KP.Active) end
						elseif mode == "Hold" then
							KP.Active = true
							for _, fn in KP._cbs do pcall(fn, true) end
						end
					end
				end)
				if mode == "Hold" then
					connect(UIS.InputEnded, function(inp)
						if type(KP.Value) ~= "userdata" then return end
						if inp.KeyCode == KP.Value then
							KP.Active = false
							for _, fn in KP._cbs do pcall(fn, false) end
						end
					end)
				end
			end

			function KP:SetValue(data)
				if type(data) == "table" then
					if data.Key then
						local kc = Enum.KeyCode[data.Key:gsub("Enum.KeyCode.", "")]
						if kc then self.Value = kc; kbLbl.Text = keyName(kc) end
					end
					if data.Mode then self.Mode = data.Mode end
				else
					self.Value = data
					kbLbl.Text = type(data) == "string" and data or keyName(data)
				end
				Library.Flags[flag] = { Key = tostring(self.Value), Mode = self.Mode }
			end

			function KP:OnChanged(fn)
				ins(self._cbs, fn)
			end

			Library.Options[flag]  = KP
			Library.Flags[flag]    = { Key = tostring(default), Mode = mode }
			Library.SetFlags[flag] = function(v) KP:SetValue(v) end

			if page then
				local sd = Library.SearchItems[page]
				if sd then ins(sd, { Name = text, Item = row }) end
			end
			return KP
		end

		function Groupbox:AddButton(config)
			config = config or {}
			local text      = config.Text       or "Button"
			local func      = config.Func       or config.Callback or function() end
			local doubleClick = config.DoubleClick == true
			local disabled  = config.Disabled   or false
			local tooltip   = config.Tooltip

			local row = make("Frame", {
				Parent              = self._content, Name = uid(),
				BackgroundTransparency = 1,
				Size                = U2.new(1, 0, 0, 26),
				ZIndex              = 5,
			})

			local btn = make("TextButton", {
				Parent              = row, Name = uid(),
				Size                = U2.fromScale(1, 1),
				BackgroundColor3    = Library.Theme.Accent,
				BackgroundTransparency = 0.1,
				BorderSizePixel     = 0,
				AutoButtonColor     = false,
				Text                = text,
				FontFace            = Library.Font,
				TextSize            = 13,
				TextColor3          = RGB(255, 255, 255),
				ZIndex              = 6,
			})
			corner(btn, 5)

			connect(btn.MouseEnter, function()
				if not disabled then
					tw(btn, { BackgroundTransparency = 0, BackgroundColor3 = Library.Theme.AccentDim })
				end
			end)
			connect(btn.MouseLeave, function()
				tw(btn, { BackgroundTransparency = 0.1, BackgroundColor3 = Library.Theme.Accent })
			end)

			if doubleClick then
				local clicks, lastClick = 0, 0
				connect(btn.MouseButton1Click, function()
					if disabled then return end
					local now = tick()
					if now - lastClick < 0.35 then
						clicks = 0
						pcall(func)
					else
						clicks = 1
					end
					lastClick = now
				end)
			else
				connect(btn.MouseButton1Click, function()
					if disabled then return end
					tw(btn, { BackgroundTransparency = 0.4 })
					task.delay(0.1, function() tw(btn, { BackgroundTransparency = 0.1 }) end)
					pcall(func)
				end)
			end

			local Button = {
				_btn = btn, Disabled = disabled,
				SetText = function(_, t) btn.Text = t end,
				SetDisabled = function(self, b)
					self.Disabled = b
					btn.BackgroundTransparency = b and 0.5 or 0.1
					btn.TextColor3 = b and Library.Theme.TextMuted or RGB(255, 255, 255)
				end,
			}

			if page then
				local sd = Library.SearchItems[page]
				if sd then ins(sd, { Name = text, Item = row }) end
			end
			return Button
		end

		return Groupbox
	end

	Library._isMouseOver = function(self, frame)
		if not frame then return false end
		local ok, pos = pcall(function() return frame.AbsolutePosition end)
		if not ok then return false end
		local m = UIS:GetMouseLocation()
		local p = pos
		local s = frame.AbsoluteSize
		return m.X >= p.X and m.X <= p.X + s.X and m.Y >= p.Y and m.Y <= p.Y + s.Y
	end

	Library.CreateSettingsPage = function(self, tabBar, window)
		local SettingsTab = tabBar:Add("Settings", "settings")

		local leftGroup  = SettingsTab:AddLeftGroupbox("Interface")
		local rightGroup = SettingsTab:AddRightGroupbox("Config")

		leftGroup:AddDropdown("__theme", {
			Text   = "Theme",
			Values = { "Default", "Nord", "Catppuccin", "Gruvbox", "RosePine" },
			Default = "Default",
			Callback = function(v)
				Library:ChangeTheme(v)
			end,
		})

		leftGroup:AddSlider("__tweenTime", {
			Text    = "Tween Speed",
			Min     = 0.05,
			Max     = 1,
			Default = 0.18,
			Rounding = 0.01,
			Suffix  = "s",
			Callback = function(v) end,
		})

		leftGroup:AddKeyPicker("__menuKey", {
			Text    = "Menu Keybind",
			Default = Library.MenuKey,
			Mode    = "Toggle",
			Callback = function() end,
		})

		local configName = ""
		local configSelected = ""

		rightGroup:AddInput("__cfgName", {
			Text        = "Config Name",
			Placeholder = "my_config",
			Callback    = function(v) configName = v end,
		})

		rightGroup:AddButton({
			Text = "Save Config",
			Func = function()
				if configName ~= "" then
					Library:SaveConfig(configName)
					Library:Notify({ Title = "Saved!", Content = "Config '" .. configName .. "' saved.", Duration = 3, Type = "success" })
				else
					Library:Notify({ Title = "Error", Content = "Enter a config name first.", Duration = 3, Type = "error" })
				end
			end,
		})

		local cfgDropdown = rightGroup:AddDropdown("__cfgList", {
			Text     = "Saved Configs",
			Values   = Library:ListConfigs(),
			Callback = function(v) configSelected = v end,
		})

		rightGroup:AddButton({
			Text = "Load Config",
			Func = function()
				if configSelected ~= "" then
					local path = Library.Folders.Configs .. "/" .. configSelected .. tostring(game.GameId) .. ".json"
					if isfile(path) then
						Library:LoadConfig(readfile(path))
						Library:Notify({ Title = "Loaded!", Content = "Config '" .. configSelected .. "' loaded.", Duration = 3, Type = "success" })
					end
				end
			end,
		})

		rightGroup:AddButton({
			Text = "Delete Config",
			Func = function()
				if configSelected ~= "" then
					Library:DeleteConfig(configSelected .. tostring(game.GameId) .. ".json")
					cfgDropdown.Values = Library:ListConfigs()
					Library:Notify({ Title = "Deleted", Content = "Config removed.", Duration = 3, Type = "warning" })
				end
			end,
		})

		rightGroup:AddButton({
			Text = "Refresh List",
			Func = function()
				cfgDropdown.Values = Library:ListConfigs()
			end,
		})
	end

end

getgenv().Samuraa1Hub = Library
return Library
