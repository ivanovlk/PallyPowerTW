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
	info.text = PALLYPOWER_TEXT_DROPDOWN_DELETE;
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
	elseif (id == 3) then
		PallyPower_Warning("DELETE", PallyPower_Delete, PallyPower_GetCurrentSet());
	elseif (id > 4) then
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
				if PP_Presets[player]["s"][set]["A"] then
					PallyPower_AuraAssignments[player] = PP_Presets[player]["s"][set]["A"]
				end
				PP_Presets[UnitName("player")]["CurrentSet"] = set;
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
	local player = UnitName("player");
	if (PP_Presets) and PP_Presets[player] and PP_Presets[player]["CurrentSet"] then
		return PP_Presets[player]["CurrentSet"];
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

function PallyPower_Delete(set)
	-- Delete a set
	local player = UnitName("player");
	print(PALLYPOWER_TEXT_DELETE .. set);
	PP_Presets[player]["s"][set] = nil;
	if (PallyPower_GetCurrentSet() == set) then
		PP_Presets[player]["CurrentSet"] = nil;
	end
end

function PallyPower_SaveSet(set)
	-- Save a set
	local player = UnitName("player");
	if (not set) then
		if (PallyPower_GetCurrentSet()) then
			set = PallyPower_GetCurrentSet();
		else
			return ;
		end
	end
	print(PALLYPOWER_TEXT_SAVING .. set);
	if PP_Presets[player] == nil then
		PP_Presets[player] = {};
		PP_Presets[player]["s"] = {};
	end
	if PallyPower_Assignments[player] then 
		PP_Presets[player]["s"][set] = PallyPower_CopyTable(PallyPower_Assignments[player]);
		if PallyPower_AuraAssignments[player] then
			PP_Presets[player]["s"][set]["A"] = PallyPower_AuraAssignments[player];
		end
		PP_Presets[player]["CurrentSet"] = set;
	end
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

function PallyPower_SetExists(set)
	-- Check to see if the set already exists
	if PP_Presets[UnitName("player")] and PP_Presets[UnitName("player")]["s"] and PP_Presets[UnitName("player")]["s"][set] then
		return true;
	end
end

-- Print the contents of a table (including nested tables)
function PallyPower_PrintTable(tbl, indent)
    if not indent then indent = 0 end
    local formatting = string.rep("  ", indent)
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            print(formatting .. tostring(k) .. ":")
            PallyPower_PrintTable(v, indent + 1)
        else
            print(formatting .. tostring(k) .. " = " .. tostring(v))
        end
    end
end