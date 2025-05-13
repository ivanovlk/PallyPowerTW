PP_Presets = {}

function PallyPower_MinimapButton_OnClick(mouseBtn)
	PallyPowerMinimapPresetsDropDown:Hide();
	if mouseBtn == "LeftButton" then
		PallyPower_SlashCommandHandler("");
	else
		PallyPower_Options();
	end
end

function PallyPower_MinimapButton_Init()
	if(PP_PerUser.minimapbuttonshow == false) then
		PallyPowerMinimapButtonFrame:Hide();
	else
		PallyPowerMinimapButtonFrame:Show();
		PallyPower_MinimapButton_UpdatePosition()
	end
end

function PallyPower_MinimapButton_UpdatePosition()
	PallyPowerMinimapButtonFrame:SetPoint(
		"TOPLEFT",
		"Minimap",
		"TOPLEFT",
		52 - (80 * cos(PP_PerUser.minimapbuttonpos)),
		(80 * sin(PP_PerUser.minimapbuttonpos)) - 52
	);
end

function PallyPower_PresetsClick()
	PallyPowerMinimapPresetsDropDown.point = "TOPRIGHT";
	PallyPowerMinimapPresetsDropDown.relativePoint = "BOTTOMLEFT";
	ToggleDropDownMenu(1, nil, PallyPowerMinimapPresetsDropDown, "PallyPowerFramePresets", 0, 0);
end

function PallyPower_Minimap_PresetsDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, PallyPower_Minimap_PresetsDropDown_Initialize, "MENU");
end

function PallyPower_Minimap_PresetsDropDown_Initialize()
	-- Setup the minimap dropdown menu
	local info = {};
	local hasSets;

	info.text = PALLYPOWER_TEXT_DROPDOWN_SAVENEW;
	info.notCheckable = 1;
	info.func = PallyPower_Minimap_PresetsDropDown_OnClick;
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = PALLYPOWER_TEXT_DROPDOWN_SAVECURRENT;
	info.notCheckable = 1;
	if (not PallyPower_GetCurrentSet()) then
		info.disabled = 1;
	end
	info.func = PallyPower_Minimap_PresetsDropDown_OnClick;
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = PALLYPOWER_TEXT_DROPDOWN_SETS;
	info.isTitle = 1;
	info.justifyH = "CENTER";
	info.notCheckable = 1;
	UIDropDownMenu_AddButton(info);
	
	if (PP_Presets and PP_Presets[UnitName("player")] and PP_Presets[UnitName("player")]["s"]) then
		local list = {};
		for k, v in PP_Presets[UnitName("player")]["s"] do
			tinsert(list, k);
		end
		table.sort(list);
		for k, v in list do
			info = {};
			info.text = v;
			info.isTitle = nil;
			if (PallyPower_GetCurrentSet() == v) then
				info.checked = 1;
			end
			info.func = PallyPower_Minimap_PresetsDropDown_OnClick;
			UIDropDownMenu_AddButton(info);
			hasSets = 1;
		end
	end
	if (not hasSets) then
		info = { };
		info.text = PALLYPOWER_TEXT_DROPDOWN_NONE;
		info.disabled = 1;
		UIDropDownMenu_AddButton(info);
	end
end

function PallyPower_Minimap_PresetsDropDown_OnClick()
	-- minimap dropdown menu handler
	local id = this:GetID();
	if (id == 1) then
		PallyPower_Actions_SaveNew();
	elseif (id == 2) then
		PallyPower_Warning("SAVE", PallyPower_SaveSet, PallyPower_GetCurrentSet());
	elseif (id > 3) then
		PallyPower_SwapSet(this:GetText());

	end
end

function PallyPower_SwapSet(set)
	local player = UnitName("player");
	-- Swap a set
	if (set) then
		if (PP_Presets and PP_Presets[player] and PP_Presets[player]["s"] and PP_Presets[player]["s"][set]) then
			for id = 0, 9 do
				PallyPower_Assignments[player][id] = PP_Presets[player]["s"][set][id];
			end	
		    PP_NextScan = 0 --PallyPower_UpdateUI()
	        PallyPower_SendSelf()
		end
	end
end

function PallyPower_Warning(type, func, value)
	if (value) then
		PallyPowerWarningFrameText:SetText(string.gsub(getglobal("PALLYPOWER_TEXT_WARNING_" .. type), "%%s", value));
	else
		PallyPowerWarningFrameText:SetText(getglobal("PALLYPOWER_TEXT_WARNING_" .. type));
	end
	PallyPowerWarningFrame.func = func;
	PallyPowerWarningFrame.value = value
	ShowUIPanel(PallyPowerWarningFrame);
end

function PallyPower_Warning_Okay()
	PallyPowerWarningFrame.func(PallyPowerWarningFrame.value)
	PallyPowerWarningFrame.func = nil;
	PallyPowerWarningFrame.value = nil;
	HideUIPanel(this:GetParent());
end

function PallyPower_GetCurrentSet()
	if (PP_Presets) and PP_Presets[UnitName("player")] and PP_Presets[UnitName("player")]["CurrentSet"] then
		return PP_Presets[UnitName("player")]["CurrentSet"];
	end
end

function PallyPower_Actions_SaveNew(set)
	PallyPowerSaveMenuNameEB:SetText("");
	ShowUIPanel(PallyPowerSaveMenu);
	if (set) then
		PallyPowerSaveMenuNameEB:SetText(set);
		PallyPower_SaveMenu_Save(set);
	end
end

function PallyPower_SaveMenu_Save(set)
	PallyPowerSaveMenuHelp.warned = nil
	PallyPowerSaveMenuHelp:Hide();
	PallyPower_SaveSet(set);
	HideUIPanel(PallyPowerSaveMenu);
end

function PallyPower_SetExists(set)
	-- Check to see if the set already exists
	if PP_Presets[UnitName("player")] and PP_Presets[UnitName("player")]["s"] and PP_Presets[UnitName("player")]["s"][set] then
		return true;
	end
end

function PallyPower_SaveSet(set)
	-- Save a set
	if (not set) then
		if (PallyPower_GetCurrentSet()) then
			set = PallyPower_GetCurrentSet();
		else
			return ;
		end
	end
	print(PALLYPOWER_TEXT_SAVING .. set);
	if PP_Presets[UnitName("player")] == nil then
		PP_Presets[UnitName("player")] = {};
		PP_Presets[UnitName("player")]["s"] = {};
	end
	if PallyPower_Assignments[UnitName("player")] then 
		PP_Presets[UnitName("player")]["s"][set] = PallyPower_CopyTable(PallyPower_Assignments[UnitName("player")]);
	end
	--PallyPower_Actions_Load(set);
end

function PallyPower_CopyTable(copyTable)
	-- properly copies a table instead of referencing the same table, thanks Sallust.
	if (not copyTable) then
		return ;
	end
	local returnTable = {};
	for k, v in copyTable do
		if type(v) == "table" then
			returnTable[k] = PallyPower_CopyTable(v);
		else
			returnTable[k] = v;
		end
	end
	return returnTable;
end

--[[function PallyPower_Actions_GetLoaded()
	local set = UIDropDownMenu_GetSelectedName(PallyPowerActionSetsDropDown);
	if (set ~= PallyPower_TEXT_CURRENT) then
		return set;
	end
end

function PallyPowerActions_Load(set, plr)
	PallyPower_Temp = {};

	if (not plr) then
		plr = PlrName;
	end

	if (not set or set == PallyPower_TEXT_CURRENT) then
		set = nil;
		PallyPower_Temp = PallyPower_IterateActions();
		PallyPowerDebug("Loading current actions");
		UIDropDownMenu_Initialize(PallyPowerActionSetsDropDown, PallyPowerActions_DropDown_Initialize);
		UIDropDownMenu_SetSelectedID(PallyPowerActionSetsDropDown, 0);
		PallyPowerActionSetsDropDownButton:Disable();
		PallyPowerActionSetsDropDownText:SetText("|c00999999" .. PallyPower_TEXT_CURRENT);
		PallyPowerActionsDelete:Disable();
	elseif (plr ~= PlrName) then
		PallyPower_Temp = PallyPower_CopyTable(PallyPower_Saved[plr]["s"][set]);
		PallyPowerDebug("Loading set " .. set .. " from " .. plr);
		UIDropDownMenu_Initialize(PallyPowerActionSetsDropDown, PallyPowerActions_DropDown_Initialize);
		UIDropDownMenu_SetSelectedID(PallyPowerActionSetsDropDown, 0);
		PallyPowerActionSetsDropDownText:SetText("|c00999999" .. PallyPower_TEXT_CURRENT);
		PallyPowerActionsDelete:Disable();
	else
		PallyPower_Temp = PallyPower_CopyTable(PallyPower_Saved[plr]["s"][set]);
		PallyPowerDebug("Loading set " .. set);
		UIDropDownMenu_Initialize(PallyPowerActionSetsDropDown, PallyPowerActions_DropDown_Initialize);
		UIDropDownMenu_SetSelectedName(PallyPowerActionSetsDropDown, set);
		PallyPowerActionsDelete:Enable();
	end

	for k, v in PallyPower_Saved[PlrName]["s"] do
		PallyPowerActionSetsDropDownButton:Enable();
		break ;
	end

	PallyPowerActions_Display();
	PallyPowerActionsSave:Disable();
	--PallyPower_CurrentSet = set;
	TitanPanelPallyPower_Update();
end

function PallyPower_Actions_SwapSet()
	if (PallyPowerActionsSave:GetButtonState() == "NORMAL") then
		PallyPower_Warning("SWAPPINGSAVE", PallyPowerActions_SwapSave, PallyPowerActions_GetLoaded());
	else
		PallyPower_Warning("SWAPPING", PallyPower_SwapSet, PallyPowerActions_GetLoaded());
	end
end

function PallyPower_Actions_SwapSave(set)
	PallyPower_SaveSet(set);
	PallyPower_SwapSet(set);
end

function PallyPower_Actions_Delete()
	PallyPower_Warning("DELETE", PallyPower_Delete, PallyPowerActions_GetLoaded());
end

function PallyPower_Actions_Save()
	PallyPower_Warning("SAVE", PallyPower_SaveSet, PallyPowerActions_GetLoaded());
end
]]