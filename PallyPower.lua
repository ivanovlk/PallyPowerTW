local initialized = false

PALLYPOWER_GREATERBLESSINGDURATION = 30 * 60
PALLYPOWER_NORMALBLESSINGDURATION = 10 * 60
PALLYPOWER_SKIPBLESSINGDURATION = 30 -- When i implement blacklist for out of LoS -- Test 
PALLYPOWER_BLESSINGTRESHOLD = 60
PALLYPOWER_RESTARTAUTOBLESS = 2 * 60

PALLYPOWER_MAXCLASSES = 10
PALLYPOWER_MAXPERCLASS = 15
PALLYPOWER_AURA_CLASS = 10
PALLYPOWER_SEAL_CLASS = 11
PP_PREFIX = "PLPWR"

AllPallys = {}
AllPallysAuras = {}
AllPallysSeals = {}

PallyPower_Assignments = {}
PallyPower_AuraAssignments = {}
PallyPower_SealAssignments = {}
PallyPower_NormalAssignments = {}
PallyPower_Tanks = {}

PallyPower = {}

BlessingIcon = {}
BuffIcon = {}
AuraIcons = {}
SealIcons = {}
BuffIconSmall = {}

PallyPower_LayOnHandsIcon = "Interface\\Icons\\Spell_Holy_LayOnHands"
PallyPower_DivineItervention = "Interface\\Icons\\Spell_Nature_TimeStop"

PP_PerUser = {
    scalemain = 1, -- corner of main window docked to
    scalebar = 1, -- corner menu window is docked from
    scanfreq = 10,
    scanperframe = 1,
    smartbuffs = 1,
    frameslocked = false,
    regularblessings = false,
    showrfbutton = true,
    showaurabutton = true,
    showsealbutton = true,
    minimapbuttonshow = true,
    playsoundwhen0 = true,
    minimapbuttonpos = 30,
    freeassign = true,
    horizontal = false,
    hideblizzaura = false,
    useunitxp_sp3 = false,
    usehdicons = false,
    transparency = 0.5
}
PP_NextScan = PP_PerUser.scanfreq
PP_UnitXPDllLoaded = false

PallyPower_ClassTexture = {}

LastCast = {}
LastCastPlayer = {}

-- Initialize LastCastOn
LastCastOn = {}
for iinit = 0, 9 do
    LastCastOn[iinit] = {}
end

PP_Symbols = 0
IsPally = 0
lastClassBtn = 1
lastClassBtnTime = PALLYPOWER_RESTARTAUTOBLESS
hasRighteousFury = false
nameRighteousFury = nil
versionBumpDisplayed = false

Assignment = {}

CurrentBuffs = {}

PP_ScanInfo = nil

local RestorSelfAutoCastTimeOut = 1
local RestorSelfAutoCast = false

-- Fix Shagu Tweaks displays error when trying to display boolean values
print = function(msg)
  DEFAULT_CHAT_FRAME:AddMessage("|cffffff00" .. ( tostring(msg) or "nil" ))
end

function PallyPower_FramesLockedOption()
    if (FramesLockedOptionChk:GetChecked() == 1) then
        PP_PerUser.frameslocked = true
    else
        PP_PerUser.frameslocked = false
    end
    PallyPowerGrid_Update(1)
    PP_NextScan = 0 --PallyPower_UpdateUI()
end

function PallyPower_RighteousFuryOption()
    if (RighteousFuryOptionChk:GetChecked() == 1) then
        PP_PerUser.showrfbutton = true
    else
        PP_PerUser.showrfbutton = false
    end
    PP_NextScan = 0 --PallyPower_UpdateUI()
end

function PallyPower_AuraOption()
    if (AuraOptionChk:GetChecked() == 1) then
        PP_PerUser.showaurabutton = true
    else
        PP_PerUser.showaurabutton = false
    end
    PP_NextScan = 0 --PallyPower_UpdateUI()
end

function PallyPower_SealOption()
    if (SealOptionChk:GetChecked() == 1) then
        PP_PerUser.showsealbutton = true
    else
        PP_PerUser.showsealbutton = false
    end
    PP_NextScan = 0 --PallyPower_UpdateUI()
end

function PallyPower_MinimapButtonOption()
    if (MinimapButtonOptionChk:GetChecked() == 1) then
        PP_PerUser.minimapbuttonshow = true
        PallyPowerMinimapButtonFrame:Show();
    else
        PP_PerUser.minimapbuttonshow = false
        PallyPowerMinimapButtonFrame:Hide();
    end
end

function PallyPower_PlaySoundOption()
    if (PlaySoundOptionChk:GetChecked() == 1) then
        PP_PerUser.playsoundwhen0 = true
    else
        PP_PerUser.playsoundwhen0 = false
    end
end

function PallyPower_HorizontalLayoutOption()
    if (HorizontalLayoutOptionChk:GetChecked() == 1) then
        PP_PerUser.horizontal = true
    else
        PP_PerUser.horizontal = false
    end
    PP_NextScan = 0 --PallyPower_UpdateUI()
end

function PallyPower_HideBlizzardAuraFrameOption()
    if (HideBlizzardFrameOptionChk:GetChecked() == 1) then
        PP_PerUser.hideblizzaura = true
        ShapeshiftBarFrame:Hide()    
    else
        PP_PerUser.hideblizzaura = false
        ShapeshiftBarFrame:Show()
    end
end

function PallyPower_FreeAssignOption()
    if (FreeAssignOptionChk:GetChecked() == 1) then
        PP_PerUser.freeassign = true
	PallyPower_SendMessage("FREEASSIGN YES")
    else
        PP_PerUser.freeassign = false
	PallyPower_SendMessage("FREEASSIGN NO")
    end
end

function PallyPower_UseUnitXPSP3Option()
    if (UseUnitXPSP3OptionChk:GetChecked() == 1) then
        PP_PerUser.useunitxp_sp3 = true
    else
        PP_PerUser.useunitxp_sp3 = false
    end
end

function PallyPower_UseHDIconsOption()
    if (UseHDIconsOptionChk:GetChecked() == 1) then
        PP_PerUser.usehdicons = true
    else
        PP_PerUser.usehdicons = false
    end
    PallyPower_AdjustIcons()
end

local function PP_Debug(string)
    if not string then
        string = "(nil)"
    end
    if (PP_DebugEnabled) then
        DEFAULT_CHAT_FRAME:AddMessage("[PP] " .. string, 1, 0, 0)
    end
end

function PallyPower_ShowMemoryUsage()
    local mem = gcinfo() -- Returns memory in KB
    mem = mem / 1024 -- Convert to MB
    mem = math.floor(mem * 100) / 100 -- Round to two decimal place
    return mem
end

function PallyPower_CheckTargetLoS(target)
    if PP_PerUser.useunitxp_sp3 == false then return true end -- If we are not using UnitXP.dll, we assume we are in LoS
    if not target then target = "target" end
    if (PP_UnitXPDllLoaded) then
        return UnitXP("inSight","player",target)
    else
        return true -- If UnitXP.dll is not loaded, we assume we are in LoS
    end
end

function PallyPower_InitConfig()
    if PP_PerUser.scalemain == nil then PP_PerUser.scalemain = 1 end
    if PP_PerUser.scalebar == nil then PP_PerUser.scalebar = 1 end
    if PP_PerUser.scanfreq == nil then PP_PerUser.scanfreq = 10 end
    if PP_PerUser.scanperframe == nil then PP_PerUser.scanperframe = 1 end
    if PP_PerUser.smartbuffs == nil then PP_PerUser.smartbuffs = 1 end
    if PP_PerUser.frameslocked == nil then PP_PerUser.frameslocked = false end
    if PP_PerUser.regularblessings == nil then PP_PerUser.regularblessings = false end
    if PP_PerUser.showrfbutton == nil then PP_PerUser.showrfbutton = true end
    if PP_PerUser.showaurabutton == nil then PP_PerUser.showaurabutton = true end
    if PP_PerUser.minimapbuttonshow == nil then PP_PerUser.minimapbuttonshow = true end
    if PP_PerUser.playsoundwhen0 == nil then PP_PerUser.playsoundwhen0 = true end
    if PP_PerUser.minimapbuttonpos == nil then PP_PerUser.minimapbuttonpos = 30 end
    if PP_PerUser.freeassign == nil then PP_PerUser.freeassign = true end
    if PP_PerUser.horizontal == nil then PP_PerUser.horizontal = false end
    if PP_PerUser.hideblizzaura == nil then PP_PerUser.hideblizzaura = false end
    if PP_PerUser.useunitxp_sp3 == nil then PP_PerUser.useunitxp_sp3 = false end
    if PP_PerUser.usehdicons == nil then PP_PerUser.usehdicons = false end
    if PP_PerUser.transparency == nil then PP_PerUser.transparency = 0.5 end
    if (pcall(UnitXP, "nop", "nop") == true) then
       PP_UnitXPDllLoaded = true;
    else
        PP_UnitXPDllLoaded = false;
        UseUnitXPSP3OptionChk:SetChecked(false)
        PP_PerUser.useunitxp_sp3 = false
        UseUnitXPSP3OptionChk:Disable()
    end    
end

function PallyPower_OnLoad()
    this:RegisterEvent("SPELLS_CHANGED")
    this:RegisterEvent("PLAYER_ENTERING_WORLD")
    this:RegisterEvent("CHAT_MSG_ADDON")
    this:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
    this:RegisterEvent("PLAYER_LOGIN")
    this:RegisterEvent("PARTY_MEMBERS_CHANGED")
    this:RegisterEvent("RAID_ROSTER_UPDATE")
    this:RegisterEvent("ADDON_LOADED")
    PallyPower_SetFrameBackdropColor(this)
    this:SetScale(1)
    SlashCmdList["PALLYPOWER"] = function(msg)
        PallyPower_SlashCommandHandler(msg)
    end
    --Hide BuffBar if not paladin. You can still see the assignments grid
    local _, class = UnitClass("player")
    if class ~= "PALADIN" then
        getglobal("PallyPowerBuffBar"):Hide()
    end    
end

function PallyPower_SetFrameBackdropColor(frame)
    if frame then
        frame:SetBackdropColor(0, 0, 0, PP_PerUser.transparency)
    end
end

function PallyPower_OnUpdate(tdiff)
    lastClassBtnTime = lastClassBtnTime - tdiff
    if lastClassBtnTime < 0 then
        lastClassBtnTime = PALLYPOWER_RESTARTAUTOBLESS
        lastClassBtn = 1
    end
    if (RestorSelfAutoCast) then
        RestorSelfAutoCastTimeOut = RestorSelfAutoCastTimeOut - tdiff
        if (RestorSelfAutoCastTimeOut < 0) then
            RestorSelfAutoCast = false
            SetCVar("autoSelfCast", "1")
        end
    end

    if (not PP_PerUser.scanfreq) then
        PP_PerUser.scanfreq = 10
        PP_PerUser.scanperframe = 1
    end
    PP_NextScan = PP_NextScan - tdiff
    if PP_NextScan < 0 and PP_IsPally then
        PP_Debug("Scanning")
        PallyPower_ScanRaid()
    end
    for i, k in LastCast do
        LastCast[i] = k - tdiff
        if LastCast[i] <= 0 then
            if PP_PerUser.playsoundwhen0 == true then
                PlaySoundFile("Interface\\Addons\\PallyPowerTW\\Sounds\\ding.mp3")
            end
            LastCast[i] = nil
        end
    end
    for i, k in LastCastPlayer do
        LastCastPlayer[i] = k - tdiff
        if LastCastPlayer[i] <= 0 then
            if PP_PerUser.playsoundwhen0 == true then
                PlaySoundFile("Interface\\Addons\\PallyPowerTW\\Sounds\\ding.mp3")
            end
            LastCastPlayer[i] = nil
        end
    end
end

function PallyPower_AdjustIcons()
    local icons_prefix
    if PP_PerUser.usehdicons == true then
        icons_prefix = "AddOns\\PallyPowerTW\\HD"
    else
        icons_prefix = "AddOns\\PallyPowerTW\\"
    end

    AuraIcons[0] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_DevotionAura"
    AuraIcons[1] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_AuraOfLight"
    AuraIcons[2] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_MindSooth"
    AuraIcons[3] = "Interface\\"..icons_prefix.."Icons\\Spell_Shadow_SealOfKings"
    AuraIcons[4] = "Interface\\"..icons_prefix.."Icons\\Spell_Frost_WizardMark"
    AuraIcons[5] = "Interface\\"..icons_prefix.."Icons\\Spell_Fire_SealOfFire"
    AuraIcons[6] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_MindVision"

    SealIcons[0] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_SealOfWisdom"
    SealIcons[1] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_FistOfJustice"
    SealIcons[2] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_SealOfSalvation"
    SealIcons[3] = "Interface\\"..icons_prefix.."Icons\\Spell_Shadow_SealOfKings"
    SealIcons[4] = "Interface\\"..icons_prefix.."Icons\\Spell_Fire_SealOfFire"
    SealIcons[5] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_SealOfFury"

    if (PP_PerUser.regularblessings == true) then
        RegularBlessings = true
        BlessingIcon[0] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_SealOfWisdom"
        BlessingIcon[1] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_FistOfJustice"
        BlessingIcon[2] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_SealOfSalvation"
        BlessingIcon[3] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_PrayerOfHealing02"
        BlessingIcon[4] = "Interface\\"..icons_prefix.."Icons\\Spell_Magic_MageArmor"
        BlessingIcon[5] = "Interface\\"..icons_prefix.."Icons\\Spell_Nature_LightningShield"
        BuffIcon[0] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_SealOfWisdom"
        BuffIcon[1] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_FistOfJustice"
        BuffIcon[2] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_SealOfSalvation"
        BuffIcon[3] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_PrayerOfHealing02"
        BuffIcon[4] = "Interface\\"..icons_prefix.."Icons\\Spell_Magic_MageArmor"
        BuffIcon[5] = "Interface\\"..icons_prefix.."Icons\\Spell_Nature_LightningShield"
        BuffIcon[9] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_SealOfFury"
    else
        RegularBlessings = false
        BlessingIcon[0] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_GreaterBlessingofWisdom"
        BlessingIcon[1] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_GreaterBlessingofKings"
        BlessingIcon[2] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_GreaterBlessingofSalvation"
        BlessingIcon[3] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_GreaterBlessingofLight"
        BlessingIcon[4] = "Interface\\"..icons_prefix.."Icons\\Spell_Magic_GreaterBlessingofKings"
        BlessingIcon[5] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_GreaterBlessingofSanctuary"
        BuffIcon[0] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_GreaterBlessingofWisdom"
        BuffIcon[1] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_GreaterBlessingofKings"
        BuffIcon[2] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_GreaterBlessingofSalvation"
        BuffIcon[3] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_GreaterBlessingofLight"
        BuffIcon[4] = "Interface\\"..icons_prefix.."Icons\\Spell_Magic_GreaterBlessingofKings"
        BuffIcon[5] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_GreaterBlessingofSanctuary"
        BuffIcon[9] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_SealOfFury"
        BuffIconSmall[0] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_SealOfWisdom"
        BuffIconSmall[1] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_FistOfJustice"
        BuffIconSmall[2] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_SealOfSalvation"
        BuffIconSmall[3] = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_PrayerOfHealing02"
        BuffIconSmall[4] = "Interface\\"..icons_prefix.."Icons\\Spell_Magic_MageArmor"
        BuffIconSmall[5] = "Interface\\"..icons_prefix.."Icons\\Spell_Nature_LightningShield"
    end

    PallyPower_ClassTexture[0] = "Interface\\"..icons_prefix.."Icons\\Warrior"
    PallyPower_ClassTexture[1] = "Interface\\"..icons_prefix.."Icons\\Rogue"
    PallyPower_ClassTexture[2] = "Interface\\"..icons_prefix.."Icons\\Priest"
    PallyPower_ClassTexture[3] = "Interface\\"..icons_prefix.."Icons\\Druid"
    PallyPower_ClassTexture[4] = "Interface\\"..icons_prefix.."Icons\\Paladin"
    PallyPower_ClassTexture[5] = "Interface\\"..icons_prefix.."Icons\\Hunter"
    PallyPower_ClassTexture[6] = "Interface\\"..icons_prefix.."Icons\\Mage"
    PallyPower_ClassTexture[7] = "Interface\\"..icons_prefix.."Icons\\Warlock"
    PallyPower_ClassTexture[8] = "Interface\\"..icons_prefix.."Icons\\Shaman"
    PallyPower_ClassTexture[9] = "Interface\\"..icons_prefix.."Icons\\Pet" 
    
    PallyPower_RighteousFury = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_SealOfFury"
    PallyPower_AuraMastery = "Interface\\"..icons_prefix.."Icons\\Spell_Holy_AuraMastery"
end

function PallyPower_OnEvent(event,arg1)
    local type, id

    if (event == "SPELLS_CHANGED" or event == "PLAYER_ENTERING_WORLD") then
        PallyPower_AdjustIcons()
        PallyPower_ScanSpells()
        if PP_PerUser.hideblizzaura == true then
            if ShapeshiftBarFrame:IsVisible() then ShapeshiftBarFrame:Hide() end
        else   
            if not ShapeshiftBarFrame:IsVisible() then ShapeshiftBarFrame:Show() end
        end         
    end

    if (event == "PLAYER_ENTERING_WORLD" and (not PallyPower_Assignments[UnitName("player")])) then
        PallyPower_Assignments[UnitName("player")] = {}
    end

    if (event == "PLAYER_ENTERING_WORLD" and (not PallyPower_SealAssignments[UnitName("player")])) then
        PallyPower_SealAssignments[UnitName("player")] = -1
    end

    if event == "CHAT_MSG_ADDON" and arg1 == PP_PREFIX and (arg3 == "PARTY" or arg3 == "RAID") then
        PallyPower_ParseMessage(arg4, arg2)
    end

    if event == "CHAT_MSG_COMBAT_FRIENDLY_DEATH" and PP_NextScan > 1 then
        PP_NextScan = 1
    end

    if event == "PLAYER_LOGIN" and PP_NextScan > 1 then
        PP_NextScan = 1 --PallyPower_UpdateUI()
    end

    if event == "PARTY_MEMBERS_CHANGED" or event == "RAID_ROSTER_UPDATE" then
        if PallyPower_PaladinLeftGroup() then
            AllPallys = {}       
            AllPallysAuras = {} 
            AllPallysSeals = {}
            for name in PallyPower_Assignments do
                if (name ~= UnitName("player")) then
                    PallyPower_Assignments[name] = nil
                end
            end
            for name in PallyPower_AuraAssignments do
                if (name ~= UnitName("player")) then
                    PallyPower_AuraAssignments[name] = nil
                end
            end
            for name in PallyPower_SealAssignments do
                if (name ~= UnitName("player")) then
                    PallyPower_SealAssignments[name] = nil
                end
            end
        end
        local _, class = UnitClass("player")
        if class == "PALADIN" then
            PallyPower_ScanSpells()
            PallyPower_SendSelf()
        end        
        PallyPower_SendVersion()
        PallyPower_RequestSend()
        PallyPower_ScanRaid()
    end

    if event == "ADDON_LOADED" and arg1 == "PallyPowerTW" then
        PallyPower_AdjustIcons()
        PallyPower_MinimapButton_Init();
        PallyPower_InitConfig();   
        PallyPower_AdjustTransparency();
    end
end

function PallyPower_AdjustTransparency()
    PallyPower_SetFrameBackdropColor(PallyPower_OptionsFrame)
    PallyPower_SetFrameBackdropColor(PallyPowerFrame)
    PallyPower_SetFrameBackdropColor(PallyPowerBuffBar)
    PallyPower_SetFrameBackdropColor(PallyPowerWarningFrame)
    PallyPower_SetFrameBackdropColor(PallyPowerSaveMenu)
end

function PallyPower_SlashCommandHandler(msg)
    if (msg == "debug") then
        if PP_DebugEnabled then
            PP_DebugEnabled = nil
        else
            PP_DebugEnabled = true
        end
	return true
    end
    if (msg == "report") then
        PallyPower_Report()
        return true
    end
    if (msg == "buff" or msg == "autobuff") then
        PallyPower_AutoBuffAll()
        return true
    end
    if PallyPowerFrame:IsVisible() then
        PallyPowerFrame:Hide()
    else
        PallyPowerFrame:Show()
    end
    PP_NextScan = 0.1 --PallyPower_UpdateUI()
end

function PallyPower_Report()
    if PallyPower_CanControl(UnitName("player")) then
        local type
        if GetNumRaidMembers() > 0 then
            type = "RAID"
        else
            type = "PARTY"
        end
        PP_Debug(type)
        SendChatMessage(PallyPower_Assignments1, type)
        for name in AllPallys do
            local blessings = nil
            for id = 0, 9 do
                local bid = PallyPower_Assignments[name][id]
                if bid >= 0 then
                    if (blessings) then
                        blessings = blessings .. ", "..PallyPower_ClassID[id]
                    else
                        blessings = ""..PallyPower_ClassID[id]
                    end
                    blessings = blessings .. "("..PallyPower_BlessingID[bid]..")"
                end
            end
            if not (blessings) then
                blessings = "Nothing"
            end
            if PallyPower_AuraAssignments[name] and PallyPower_AuraAssignments[name] ~= -1 then
                blessings = blessings.." --- Aura: "..PallyPower_AuraID[PallyPower_AuraAssignments[name]]
            end
            SendChatMessage(name .. ": " .. blessings, type)
            PP_Debug(name .. ": " .. blessings)
        end
        SendChatMessage(PallyPower_Assignments2, type)
    end
end

function PallyPower_FormatTime(time)
    if not time or time < 0 then
        return ""
    end
    mins = floor(time / 60)
    secs = time - (mins * 60)
    return string.format("%d:%02d", mins, secs)
end

function PallyPower_TableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
 end

 function PallyPower_RemoveFromTable(itab, ivalue)
    for i, v in ipairs(itab) do
        if v == ivalue then
            table.remove(itab, i)
            break -- Exit the loop after removing the value
        end
    end
end

function PallyPowerGrid_Update(tdiff)

    if not initialized then
        PallyPower_ScanSpells()
    end
    if PP_PerUser.frameslocked == true then
        PallyPowerFrameResizeButton:Hide()
    else
        PallyPowerFrameResizeButton:Show()
    end

    for i = 0, 9 do
        getglobal("PallyPowerFrameClass" .. i):SetTexture(PallyPower_ClassTexture[i])
    end
    getglobal("PallyPowerFrameClassA"):SetTexture(PallyPower_AuraMastery)

    -- Pally 1 is always myself
    local i = 1
    local numPallys = 0
    local name, skills
    if PallyPowerFrame:IsVisible() then
        PallyPowerFrame:SetScale(PP_PerUser.scalemain)
        for name, skills in AllPallys do
            getglobal("PallyPowerFramePlayer" .. i .. "Name"):SetText(name)
            getglobal("PallyPowerFramePlayer" .. i .. "InGroup"):SetText(PallyPower_GetPlayerGroupID(name))

            -- Set icons about Lay on Hands and Divine Intervention here ( communicated via messages )
            if skills["LayOnHands"] ~= nil  and skills["LayOnHands"] == true then
                getglobal("PallyPowerFramePlayer" .. i .. "IconLH"):SetTexture(PallyPower_LayOnHandsIcon)
                getglobal("PallyPowerFramePlayer" .. i .. "IconLH"):Show()
            else
                getglobal("PallyPowerFramePlayer" .. i .. "IconLH"):Hide()
            end
            if skills["DivineIntervention"] ~= nil  and skills["DivineIntervention"] == true then
                getglobal("PallyPowerFramePlayer" .. i .. "IconDI"):SetTexture(PallyPower_DivineItervention)
                getglobal("PallyPowerFramePlayer" .. i .. "IconDI"):Show()
            else
                getglobal("PallyPowerFramePlayer" .. i .. "IconDI"):Hide()
            end

            getglobal("PallyPowerFramePlayer" .. i .. "Symbols"):SetText(skills["symbols"])
            getglobal("PallyPowerFramePlayer" .. i .. "Symbols"):SetTextColor(1, 1, 0.5)
            if (PallyPower_CanControl(name)) then
                getglobal("PallyPowerFramePlayer" .. i .. "Name"):SetTextColor(1, 1, 1)
            else
                if (PallyPower_CheckRaidLeader(name)) then
                    getglobal("PallyPowerFramePlayer" .. i .. "Name"):SetTextColor(0, 1, 0)
                else
                    getglobal("PallyPowerFramePlayer" .. i .. "Name"):SetTextColor(1, 0, 0)
                end
            end
            for id = 0, 5 do -- Blessings Icons and skills
                if (skills[id]) then
                    getglobal("PallyPowerFramePlayer" .. i .. "Icon" .. id):Show()
                    getglobal("PallyPowerFramePlayer" .. i .. "Skill" .. id):Show()
                    txt = skills[id]["rank"]
                    if (skills[id]["talent"] + 0 > 0) then
                        txt = txt .. "+" .. skills[id]["talent"]
                    end
                    getglobal("PallyPowerFramePlayer" .. i .. "Skill" .. id):SetText(txt)
                else
                    getglobal("PallyPowerFramePlayer" .. i .. "Icon" .. id):Hide()
                    getglobal("PallyPowerFramePlayer" .. i .. "Skill" .. id):Hide()
                end
            end
            for id = 6, 8 do -- Aura Icons and skills (Auras start from 0 and icon start at 6)
                if AllPallysAuras[name] and AllPallysAuras[name][id-6] then
                    getglobal("PallyPowerFramePlayer" .. i .. "Icon" .. id):Show()
                    getglobal("PallyPowerFramePlayer" .. i .. "Skill" .. id):Show()
                    txt = AllPallysAuras[name][id-6].rank
                    if (AllPallysAuras[name][id-6].talent + 0 > 0) then
                        txt = txt .. "+" .. AllPallysAuras[name][id-6].talent
                    end
                    getglobal("PallyPowerFramePlayer" .. i .. "Skill" .. id):SetText(txt)
                else
                    getglobal("PallyPowerFramePlayer" .. i .. "Icon" .. id):Hide()
                    getglobal("PallyPowerFramePlayer" .. i .. "Skill" .. id):Hide()
                end
            end
            for id = 0, 9 do
                if (PallyPower_Assignments[name]) then
                    getglobal("PallyPowerFramePlayer" .. i .. "Class" .. id .. "Icon"):SetTexture(
                        BlessingIcon[PallyPower_Assignments[name][id]]
                    )
                else
                    getglobal("PallyPowerFramePlayer" .. i .. "Class" .. id .. "Icon"):SetTexture(nil)
                end
            end
            if (PallyPower_AuraAssignments[name]) then
                getglobal("PallyPowerFramePlayer" .. i .. "ClassAIcon"):SetTexture(
                    AuraIcons[PallyPower_AuraAssignments[name]]
                )
            else
                getglobal("PallyPowerFramePlayer" .. i .. "ClassAIcon"):SetTexture(nil)
            end
            i = i + 1
            numPallys = numPallys + 1
        end

        local numMaxClass = 0
        local currentPlayer = 0
        local assign = PallyPower_Assignments[UnitName("player")]
        local player = UnitName("player")

        for ii = 1, PALLYPOWER_MAXCLASSES do
            currentPlayer = 0

            local fname = "PallyPowerFrameClassGroup" .. ii

            for jj = 1, PALLYPOWER_MAXPERCLASS do
                local pbnt = fname .. "PlayerButton" .. jj
                getglobal(pbnt):SetFrameStrata("BACKGROUND")
                getglobal(pbnt):SetAlpha(0)
            end    
            
            if CurrentBuffs[ii - 1] then

                for unit, stats in CurrentBuffs[ii - 1] do

                    local pbnt = fname .. "PlayerButton" .. (currentPlayer + 1) -- Index is based on 1

                    if unit then
                        local shortname = stats.name
                        if string.find(unit,"pet") then
                            getglobal(pbnt .. "Text"):SetText(shortname) --"|T132242:0|t "..shortname
                        else
                            getglobal(pbnt .. "Text"):SetText(shortname)
                        end
                        local blessing = GetNormalBlessings(player,ii - 1, shortname) --class 0 == button 1
                        if blessing ~= -1 then
                            getglobal(pbnt .. "Icon"):SetTexture(BuffIconSmall[blessing])
                        else
                            getglobal(pbnt .. "Icon"):SetTexture("")
                        end
                        if PallyPower_Tanks[shortname] and PallyPower_Tanks[shortname] == true then
                            getglobal(pbnt .. "Text"):SetTextColor(1, 0.65, 0)
                        else
                            getglobal(pbnt .. "Text"):SetTextColor(1, 1, 1)
                        end
                        getglobal(pbnt):SetFrameStrata("DIALOG")
                        getglobal(pbnt):SetAlpha(1)        
                        currentPlayer = currentPlayer + 1
                        if currentPlayer > PALLYPOWER_MAXPERCLASS then
                            currentPlayer = PALLYPOWER_MAXPERCLASS
                        end
                    else
                        getglobal(pbnt .. "Icon"):SetTexture("")
                        getglobal(pbnt):SetFrameStrata("BACKGROUND")
                        getglobal(pbnt):SetAlpha(0)
                    end

                end

                numMaxClass = math.max(numMaxClass, currentPlayer)

            end

        end           

        PallyPowerFrame:SetHeight(10 + 14 + 24 + 56 + (numPallys * 76) + 22 + (13 * numMaxClass)) -- 14 from border, 24 from Title, 56 from space for class icons, 56 per paladin, 22 for Buttons at bottom
        getglobal("PallyPowerFramePlayer1"):SetPoint("TOPLEFT", 8, -84 - 13 * numMaxClass)
		for i = 1, PALLYPOWER_MAXCLASSES do
			getglobal("PallyPowerFrameClassGroup" .. i .. "Line"):SetHeight( 2 + 13 * numMaxClass)
        end        
        getglobal("PallyPowerFrameClassGroupALine"):SetHeight( 2 + 13 * numMaxClass)

        for i = 1, 12 do
            if i <= numPallys then
                getglobal("PallyPowerFramePlayer" .. i):Show()
            else
                getglobal("PallyPowerFramePlayer" .. i):Hide()
            end
        end
    end
end

function GetNormalBlessings(pname, class, tname)
    if PallyPower_NormalAssignments[pname] and PallyPower_NormalAssignments[pname][class] and PallyPower_NormalAssignments[pname][class][tname] then
		local blessing = PallyPower_NormalAssignments[pname][class][tname]
		if blessing then
			return blessing
		else
			return -1
		end
    else
        return -1
    end
end

function SetNormalBlessings(pname, class, tname, value)
	if not PallyPower_NormalAssignments[pname] then
		PallyPower_NormalAssignments[pname] = {}
	end
	if not PallyPower_NormalAssignments[pname][class] then
		PallyPower_NormalAssignments[pname][class] = {}
	end
	PallyPower_NormalAssignments[pname][class][tname] = value
end

function PallyPower_mod(a, b)
    return a - math.floor(a / b) * b
end

function PallyPower_PerformPlayerCycle(delta, pname, class)
    if PallyPower_Assignments[UnitName("player")][class] == -1 then return end
	local blessing = 0
    local player = UnitName("player")
	if not PP_IsPally then
		return
	end
	if PallyPower_NormalAssignments[player] and PallyPower_NormalAssignments[player][class] and PallyPower_NormalAssignments[player][class][pname] then
		blessing = PallyPower_NormalAssignments[player][class][pname]
    else
        blessing = -1
	end

    for test = blessing + 1, 6 do
        if PallyPower_CanBuff(player, test) and (PallyPower_NeedsBuff(class, test) or IsShiftKeyDown()) then
            blessing = test
            do
                break
            end
        end
    end

    if (blessing == 6) then
        blessing = -1
    end

    SetNormalBlessings(player, class, pname, blessing)
end

function PallyPowerPlayerButton_OnMouseWheel(btn, arg1)
    if btn then
        local _, _, class, pnum = strfind(btn:GetName(), "PallyPowerFrameClassGroup(.+)PlayerButton(.+)")
        class = tonumber(class) - 1 --class 0 == button 1
        local pname = getglobal(btn:GetName() .. "Text"):GetText()
        PallyPower_PerformPlayerCycle(arg1, pname, class)
    end
end

function PallyPowerPlayerButton_OnClick(plbtn, mouseBtn)
    if plbtn then
        local _, _, class, pnum = strfind(plbtn:GetName(), "PallyPowerFrameClassGroup(.+)PlayerButton(.+)")
        class = tonumber(class) - 1 --class 0 == button 1
        local pname = getglobal(plbtn:GetName() .. "Text"):GetText()
        if mouseBtn == "RightButton" then
            if PallyPower_NormalAssignments[UnitName("player")] and 
               PallyPower_NormalAssignments[UnitName("player")][class] and 
               PallyPower_NormalAssignments[UnitName("player")][class][pname] then
                PallyPower_NormalAssignments[UnitName("player")][class][pname] = -1
            end
            PP_NextScan = 0.1 --PallyPower_UpdateUI()
        elseif mouseBtn == "LeftButton" then
            PallyPower_PerformPlayerCycle(nil, pname, class)
        else
            if PallyPower_Tanks[pname] and PallyPower_Tanks[pname] == true then
                PallyPower_Tanks[pname] = nil
                if pfUI ~= nil and pfUI.uf ~= nil and pfUI.uf.raid ~= nil and pfUI.uf.raid.tankrole ~= nil then
                    pfUI.uf.raid.tankrole[pname] = nil
                end
                PallyPower_SendMessage("TANKCLEAR", pname)
            else
                PallyPower_Tanks[pname] = true
                if pfUI ~= nil and pfUI.uf ~= nil and pfUI.uf.raid ~= nil and pfUI.uf.raid.tankrole ~= nil then
                    pfUI.uf.raid.tankrole[pname] = true
                end
                PallyPower_SendMessage("TANK", pname)
            end
        end
    end
end

function PallyPower_UpdateLayout()
    local addAura = 0
    local addHeight = 0
    local hasAura = false
    local hasSeal = false
    local namePlayer = UnitName("player")

    if PallyPower_AuraAssignments[namePlayer] and PallyPower_AuraAssignments[namePlayer] ~= -1 then
        hasAura = true
    end

    if PallyPower_SealAssignments[namePlayer] and PallyPower_SealAssignments[namePlayer] ~= -1 then
        hasSeal = true
    end

    -- Calculate which buttons should be shown
    local showRF = (PP_PerUser.showrfbutton == true and hasRighteousFury == true) and (IsPally == 1)
    local showAura = (PP_PerUser.showaurabutton == true and hasAura == true) and (IsPally == 1)
    local showSeal = (PP_PerUser.showsealbutton == true and hasSeal == true) and (IsPally == 1)
    
    -- Hide all buttons initially
    PallyPowerBuffBarRF:Hide()
    PallyPowerBuffBarAura:Hide()
    PallyPowerBuffBarSeal:Hide()
    
    -- Count visible buttons and set up positioning
    local visibleButtons = {}
    if showRF then table.insert(visibleButtons, "PallyPowerBuffBarRF") end
    if showAura then table.insert(visibleButtons, "PallyPowerBuffBarAura") end
    if showSeal then table.insert(visibleButtons, "PallyPowerBuffBarSeal") end
    
    local numVisible = table.getn(visibleButtons)
    
    if numVisible == 0 then
        -- No special buttons visible
        addAura = 0
        addHeight = 0
        getglobal("PallyPowerBuffBarBuff1"):ClearAllPoints()
        getglobal("PallyPowerBuffBarBuff1"):SetPoint("TOPLEFT",5,-28)
    else
        -- Calculate dimensions based on layout
        if PP_PerUser.horizontal == false then
            addAura = 36 * numVisible
            addHeight = 0
        else
            addAura = 100 * numVisible
            addHeight = 100
        end
        
        -- Show and position buttons
        local lastButton = nil
        for i = 1, numVisible do
            local buttonName = visibleButtons[i]
            local button = getglobal(buttonName)
            button:Show()
            button:ClearAllPoints()
            
            if i == 1 then
                -- First button
                button:SetPoint("TOPLEFT", 5, -28)
                lastButton = buttonName
            else
                -- Subsequent buttons
                if PP_PerUser.horizontal == false then
                    button:SetPoint("TOPLEFT", lastButton, "BOTTOMLEFT", 0, 0)
                else
                    button:SetPoint("TOPLEFT", lastButton, "TOPRIGHT", 0, 0)
                end
                lastButton = buttonName
            end
        end
        
        -- Position first blessing button after the last special button
        getglobal("PallyPowerBuffBarBuff1"):ClearAllPoints()
        if PP_PerUser.horizontal == false then
            getglobal("PallyPowerBuffBarBuff1"):SetPoint("TOPLEFT", lastButton, "BOTTOMLEFT", 0, 0)
        else
            getglobal("PallyPowerBuffBarBuff1"):SetPoint("TOPLEFT", lastButton, "TOPRIGHT", 0, 0)
        end
    end

    for rest = 2, 10 do
        local btn = getglobal("PallyPowerBuffBarBuff" .. rest)
        btn:ClearAllPoints()

        if PP_PerUser.horizontal == false then
            btn:SetPoint("TOPLEFT","PallyPowerBuffBarBuff"..rest - 1,"BOTTOMLEFT",0,0)
        else
            btn:SetPoint("TOPLEFT","PallyPowerBuffBarBuff"..rest - 1,"TOPRIGHT",0,0)
        end
        btn:Hide()
    end

    return addHeight, addAura
end

function PallyPower_UpdateUI()
    if not initialized then
        PallyPower_ScanSpells()
    end

    if PP_PerUser.hideblizzaura == true then
	    if ShapeshiftBarFrame:IsVisible() then ShapeshiftBarFrame:Hide() end
    else   
        if not ShapeshiftBarFrame:IsVisible() then ShapeshiftBarFrame:Show() end
    end 
	
    -- Buff Bar
    PallyPowerBuffBar:SetScale(PP_PerUser.scalebar)
    getglobal("PallyPowerBuffBarRFBuffIcon"):SetTexture(PallyPower_RighteousFury)


    local pclass, eclass = UnitClass("player")
    local namePlayer = UnitName("player")

    if eclass == "PALADIN" then
        IsPally = 1
    end

    local addAura = 0
    local addHeight = 0

    if ((IsPally == 1) or (GetNumRaidMembers() > 0 and GetNumPartyMembers() > 0)) then
        if PP_PerUser.frameslocked == true then
            PallyPowerBuffBarResizeButton:Hide()
        else
            PallyPowerBuffBarResizeButton:Show()
        end

        addHeight, addAura = PallyPower_UpdateLayout()

        local icons_prefix
        if PP_PerUser.usehdicons == true then
            icons_prefix = "AddOns\\PallyPowerTW\\HD"
        else
            icons_prefix = "AddOns\\PallyPowerTW\\"
        end
        
        PallyPowerBuffBarRF:SetBackdropColor(0, 0, 0, PP_PerUser.transparency)
        local i
        local testUnitBuff
        for i = 1,40 do 
            testUnitBuff = UnitBuff("player",i) 
            if (testUnitBuff and testUnitBuff == string.gsub(BuffIcon[9],icons_prefix,"")) then 
                PallyPowerBuffBarRF:SetBackdropColor(0, 1, 0, PP_PerUser.transparency)
                break
            end 
        end 
    
        PallyPowerBuffBarAura:SetBackdropColor(0, 0, 0, PP_PerUser.transparency)
        if PallyPower_AuraAssignments[namePlayer] then
            getglobal("PallyPowerBuffBarAuraBuffIcon"):SetTexture(AuraIcons[PallyPower_AuraAssignments[namePlayer]])
            for i=1,40 do 
                testUnitBuff = UnitBuff("player",i) 
                if (testUnitBuff and PallyPower_AuraAssignments[namePlayer] ~= nil and 
                    AuraIcons[PallyPower_AuraAssignments[namePlayer]] ~= nil and
                    testUnitBuff == string.gsub(AuraIcons[PallyPower_AuraAssignments[namePlayer]],icons_prefix,"")) then 
                    PallyPowerBuffBarAura:SetBackdropColor(0, 1, 0, PP_PerUser.transparency)
                    break
                end 
            end 
        else
            getglobal("PallyPowerBuffBarAuraBuffIcon"):SetTexture(nil)
        end

        PallyPowerBuffBar:Show()
        PallyPowerBuffBarTitleText:SetText(format(PallyPower_BuffBarTitle, PP_Symbols))
        BuffNum = 1
        if PallyPower_Assignments[namePlayer] then
            local assign = PallyPower_Assignments[namePlayer]
            for class = 0, 9 do
                if (assign[class] and assign[class] ~= -1) then
                    getglobal("PallyPowerBuffBarBuff" .. BuffNum .. "ClassIcon"):SetTexture(
                        PallyPower_ClassTexture[class]
                    )
                    getglobal("PallyPowerBuffBarBuff" .. BuffNum .. "BuffIcon"):SetTexture(BlessingIcon[assign[class]])

                    local btn = getglobal("PallyPowerBuffBarBuff" .. BuffNum)
                    btn.classID = class
                    btn.buffID = assign[class]
                    btn.need = {}
                    btn.have = {}
                    btn.range = {}
                    btn.dead = {}
                    -- Calculate number of people who need buff.
                    local nneed = 0
                    local nhave = 0
                    local ndead = 0
                    local naway = 0
                    if CurrentBuffs[class] then
                        for member, stats in CurrentBuffs[class] do
                            if stats["visible"] then
                                local hasBuffs = false
                                if GetNormalBlessings(namePlayer,class, UnitName(member)) ~= -1 then
                                    if stats[GetNormalBlessings(namePlayer,class, UnitName(member))] then
                                        hasBuffs = true
                                    end
                                elseif stats[assign[class]] then
                                    hasBuffs = true
                                end
                                
                                if not hasBuffs then
                                    if UnitIsDeadOrGhost(member) then
                                        ndead = ndead + 1
                                        tinsert(btn.dead, stats["name"])
                                    else
                                        nneed = nneed + 1
                                        tinsert(btn.need, stats["name"])
                                    end
                                else
                                    tinsert(btn.have, stats["name"])
                                    nhave = nhave + 1
                                end
                            else
                                tinsert(btn.range, stats["name"])
                                nhave = nhave + 1
                                naway = naway + 1
                            end
                        end
                    end

                    --Cleanup timers if no Have
                    if nhave == 0 then
                        LastCast[assign[btn.classID] .. btn.classID] = nil
                        if CurrentBuffs[btn.classID] then
                            for unit, stats in CurrentBuffs[btn.classID] do
                                if LastCastPlayer[stats.name] then
                                    LastCastPlayer[stats.name] = nil
                                end
                            end
                        end
                    end

                    local individual_time = PALLYPOWER_GREATERBLESSINGDURATION    
                    if CurrentBuffs[btn.classID] then
                        for unit, stats in CurrentBuffs[btn.classID] do
                            if LastCastPlayer[stats.name] and LastCastPlayer[stats.name] < individual_time then
                                individual_time = LastCastPlayer[stats.name]
                            end 
                        end    
                    end
                    if individual_time ~= PALLYPOWER_GREATERBLESSINGDURATION then
                        getglobal("PallyPowerBuffBarBuff" .. BuffNum .. "Time2"):SetText(PallyPower_FormatTime(individual_time))
                    else
                        getglobal("PallyPowerBuffBarBuff" .. BuffNum .. "Time2"):SetText("")
                    end    

                    if ndead > 0 then
                        getglobal("PallyPowerBuffBarBuff" .. BuffNum .. "Text"):SetText(nneed .. " (" .. ndead .. ")")
                    else
                        getglobal("PallyPowerBuffBarBuff" .. BuffNum .. "Text"):SetText(nneed)
                    end
                    getglobal("PallyPowerBuffBarBuff" .. BuffNum .. "Time"):SetText(
                        PallyPower_FormatTime(LastCast[assign[class] .. class])
                    )
                    if not (nneed > 0 or nhave > 0 or ndead > 0) then
                    else
                        BuffNum = BuffNum + 1
                        if (nhave == 0) then
                            btn:SetBackdropColor(1, 0, 0, PP_PerUser.transparency)
                        elseif (nneed > 0 or ndead > 0) then
                            btn:SetBackdropColor(1, 1, 0.5, PP_PerUser.transparency)
                        elseif (nneed == 0 and ndead == 0 and naway == 0) then
                            btn:SetBackdropColor(0, 1, 0, PP_PerUser.transparency)
                        else
                            btn:SetBackdropColor(0, 0, 0, PP_PerUser.transparency)
                        end
                        btn:Show()
                    end
                end
            end
        end
        for rest = BuffNum, 10 do
            local btn = getglobal("PallyPowerBuffBarBuff" .. rest)
            btn.classID = {}
            btn.buffID = {}
            btn.need = {}
            btn.have = {}
            btn.range = {}
            btn.dead = {}
            btn:Hide()
        end
        if PP_PerUser.horizontal == false then
            PallyPowerBuffBar:SetHeight(32 + (36 * (BuffNum - 1)) + addHeight + addAura)
            PallyPowerBuffBar:SetWidth(110)
        else
            PallyPowerBuffBar:SetWidth((100 * (BuffNum - 1)) + addHeight + addAura + 10)
            PallyPowerBuffBar:SetHeight(68)
        end
    else
        PallyPowerBuffBar:Hide()
    end
end

function PallyPower_ScanSpells()
    local RankInfo = {}
    local AuraRankInfo = {}
    local i = 1

    local icons_prefix
    if PP_PerUser.usehdicons == true then
        icons_prefix = "AddOns\\PallyPowerTW\\HD"
    else
        icons_prefix = "AddOns\\PallyPowerTW\\"
    end

    while true do
        local spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL)
        local spellTexture = GetSpellTexture(i, BOOKTYPE_SPELL)
        if not spellName then
            break
        end

        if spellTexture == string.gsub(BuffIcon[9],icons_prefix,"") then
            hasRighteousFury = true
            nameRighteousFury = spellName
        end

        if spellTexture == PallyPower_DivineItervention then
            if GetSpellCooldown(i, BOOKTYPE_SPELL) == 0 then
                RankInfo["DivineIntervention"] = true
            end
        end
        if spellTexture == PallyPower_LayOnHandsIcon then
            if GetSpellCooldown(i, BOOKTYPE_SPELL) == 0 then
                RankInfo["LayOnHands"] = true
            end
        end

        if not spellRank or spellRank == "" then
            spellRank = PallyPower_Rank1
        end

        local _, _, aura = string.find(spellName, PallyPower_AuraSpellSearch)
        if aura then
            for id, name in PallyPower_AuraID do
                if (name == aura) then
                    local _, _, rank = string.find(spellRank, PallyPower_RankSearch)
                    if (AuraRankInfo[id] and spellRank < AuraRankInfo[id]["rank"]) then
                    else
                        AuraRankInfo[id] = {}
                        AuraRankInfo[id]["rank"] = rank
                        AuraRankInfo[id]["id"] = i
                        AuraRankInfo[id]["name"] = name
                        AuraRankInfo[id]["talent"] = 0
                    end
                end
            end
        end

        local _, _, bless = string.find(spellName, PallyPower_BlessingSpellSearch)
        if bless then
            local greaterBless, _ = string.find(spellName, PallyPower_Greater)
            for id, name in PallyPower_BlessingID do
                if ((name == bless) and (not greaterBless)) then
                    local _, _, rank = string.find(spellRank, PallyPower_RankSearch)
                    if (RankInfo[id] and spellRank < RankInfo[id]["rank"]) then
                    else
                        RankInfo[id] = {}
                        RankInfo[id]["rank"] = rank
                        RankInfo[id]["id"] = i
                        RankInfo[id]["idsmall"] = i
                        RankInfo[id]["name"] = name
                        RankInfo[id]["talent"] = 0
                    end
                end
            end
        end

        if (RegularBlessings == false) then
            local _, _, bless = string.find(spellName, PallyPower_BlessingSpellSearch)
            if bless then
                local greaterBless, _ = string.find(spellName, PallyPower_Greater)
                for id, name in PallyPower_BlessingID do
                    if ((name == bless) and (greaterBless)) then
                        local _, _, rank = string.find(spellRank, PallyPower_RankSearch)
                        if (RankInfo[id] and spellRank < RankInfo[id]["rank"]) then
                        else
                            RankInfo[id]["id"] = i
                            RankInfo[id]["name"] = name
                        end
                    end
                end
            end
        end
        i = i + 1
    end

    --Improved Blessings
    nameTalent, icon, iconx, icony, currRank, maxRank = GetTalentInfo(3, 1);
    if currRank > 0 then
        for id = 0, 1 do -- wisdom & might
            if (RankInfo[id]) then
                RankInfo[id]["talent"] = currRank
            end
        end
    end
    --Improved Concentration Aura
    nameTalent, icon, iconx, icony, currRank, maxRank = GetTalentInfo(1, 10);
    if currRank > 0 then
        for id, name in pairs(PallyPower_AuraID) do
            if (id == 2) then
                if AuraRankInfo and AuraRankInfo[id] and AuraRankInfo[id]["rank"] then
                    AuraRankInfo[id]["talent"] = currRank
                end
            end
        end
    end
    --Improved Devotion Aura
    nameTalent, icon, iconx, icony, currRank, maxRank = GetTalentInfo(2, 1);
    if currRank > 0 then
        for id, name in pairs(PallyPower_AuraID) do
            if (id == 0) then
                if AuraRankInfo and AuraRankInfo[id] and AuraRankInfo[id]["rank"] then
                    AuraRankInfo[id]["talent"] = currRank
                end
            end
        end
    end
    --Improved Retribution Aura
    nameTalent, icon, iconx, icony, currRank, maxRank = GetTalentInfo(3, 6);
    if currRank > 0 then
        for id, name in pairs(PallyPower_AuraID) do
            if (id == 1) then
                if AuraRankInfo and AuraRankInfo[id] and AuraRankInfo[id]["rank"] then
                    AuraRankInfo[id]["talent"] = currRank
                end
            end
        end
    end

    local _, class = UnitClass("player")
    if class == "PALADIN" then
        AllPallys[UnitName("player")] = RankInfo
        AllPallysAuras[UnitName("player")] = AuraRankInfo
        PP_IsPally = true
        if initialized then
            PallyPower_SendSelf()
        end
    else
        PP_Debug("I'm not a paladin?? " .. class)
        PP_IsPally = nil
        initialized = true
    end

    nameTalent, icon, iconx, icony, currRank, maxRank = GetTalentInfo(3, 1);
    if nameTalent ~= nil then 
        initialized = true
    end

    PallyPower_ScanInventory()
    return RankInfo
end

function PallyPower_Refresh()
    AllPallys = {}       
    AllPallysAuras = {} 
    AllPallysSeals = {} 

    --[[for name in PallyPower_Assignments do
        if (name ~= UnitName("player")) then
            PallyPower_Assignments[name] = nil
        end
    end
    for name in PallyPower_AuraAssignments do
        if (name ~= UnitName("player")) then
            PallyPower_AuraAssignments[name] = nil
        end
    end]]

    local _, class = UnitClass("player")
    if class == "PALADIN" then
        PallyPower_ScanSpells()
        PallyPower_SendSelf()
    end
    PallyPower_SendVersion()
    PallyPower_RequestSend()
    PP_NextScan = 0 --PallyPower_UpdateUI()
end

function PallyPower_Clear(fromupdate, who)
    if not who then
        who = UnitName("player")
    end
    for name, skills in PallyPower_Assignments do
        if (PallyPower_CheckRaidLeader(who) or PP_PerUser.freeassign or name == who) then
            for class, id in PallyPower_Assignments[name] do
                PallyPower_Assignments[name][class] = -1
            end
            PallyPower_NormalAssignments = {}
            PallyPower_AuraAssignments = {}
            PallyPower_Tanks = {}
        end
    end
    PP_NextScan = 0 --PallyPower_UpdateUI()
    if not fromupdate then
        PallyPower_SendMessage("CLEAR")
    end
end

function PallyPower_RequestSend()
    PallyPower_SendMessage("REQ")
end

function PallyPower_SendSelf()
    if not initialized then
        PallyPower_ScanSpells()
    end
    if not AllPallys[UnitName("player")] and not AllPallysAuras[UnitName("player")] then
        return
    end
    msg = "SELF "
    local RankInfo = AllPallys[UnitName("player")]
    local i
    for id = 0, 5 do
        if (not RankInfo[id]) then
            msg = msg .. "nn"
        else
            msg = msg .. RankInfo[id]["rank"]
            msg = msg .. RankInfo[id]["talent"]
        end
    end
    msg = msg .. "@"
    for id = 0, 9 do
        if
            (not PallyPower_Assignments[UnitName("player")]) or (not PallyPower_Assignments[UnitName("player")][id]) or
                PallyPower_Assignments[UnitName("player")][id] == -1
         then
            msg = msg .. "n"
        else
            msg = msg .. PallyPower_Assignments[UnitName("player")][id]
        end
    end
    PallyPower_SendMessage(msg)
    PallyPower_SendMessage("SYMCOUNT " .. PP_Symbols ) 
    local cooldownsString = ""
    if RankInfo["DivineIntervention"] and RankInfo["DivineIntervention"] == true then
        cooldownsString = cooldownsString .. "1"
    else
        cooldownsString = cooldownsString .. "0"
    end
    if RankInfo["LayOnHands"] and RankInfo["LayOnHands"] == true then
        cooldownsString = cooldownsString .. "1"
    else
        cooldownsString = cooldownsString .. "0"
    end
    PallyPower_SendMessage("COOLDOWNS " .. cooldownsString)
    if PP_PerUser.freeassign == true then
        PallyPower_SendMessage("FREEASSIGN YES")
    else
        PallyPower_SendMessage("FREEASSIGN NO")
    end
    msg = "ASELF "
    local RankInfo = AllPallysAuras[UnitName("player")]
    local i
    for id = 0, 6 do
        if (not RankInfo[id]) then
            msg = msg .. "nn"
        else
            msg = msg .. RankInfo[id]["rank"]
            msg = msg .. RankInfo[id]["talent"]
        end
    end
    msg = msg .. "@"
    if
        (not PallyPower_AuraAssignments[UnitName("player")]) or 
            PallyPower_AuraAssignments[UnitName("player")] == -1
        then
        msg = msg .. "n"
    else
        msg = msg .. PallyPower_AuraAssignments[UnitName("player")]
    end
    PallyPower_SendMessage(msg)
    for name, _ in pairs(PallyPower_Tanks) do
        msg = "TANK " .. name
        PallyPower_SendMessage(msg)
    end    
end

function PallyPower_SendVersion()
    PallyPower_SendMessage("VERSION " .. PallyPower_Version)
end

function PallyPower_SendMessage(msg)
    if GetNumRaidMembers() == 0 then
        SendAddonMessage(PP_PREFIX, msg, "PARTY", UnitName("player"))
    else
        SendAddonMessage(PP_PREFIX, msg, "RAID", UnitName("player"))
    end
end

function PallyPower_ParseMessage(sender, msg)
    local nameplayer = UnitName("player")
    if not (sender == nameplayer) then
        if msg == "REQ" then
            PallyPower_SendSelf()
        end
        if string.find(msg, "^SELF") then
            PallyPower_Assignments[sender] = {}
            AllPallys[sender] = {}
            local _, _, numbers, assign = string.find(msg, "SELF ([0-9n]*)@?([0-9n]*)")
            for id = 0, 5 do
                rank = string.sub(numbers, id * 2 + 1, id * 2 + 1)
                talent = string.sub(numbers, id * 2 + 2, id * 2 + 2)
                if not (rank == "n") then
                    AllPallys[sender][id] = {}
                    AllPallys[sender][id]["rank"] = rank
                    AllPallys[sender][id]["talent"] = talent
                end
            end
            if assign then
                for id = 0, 9 do
                    tmp = string.sub(assign, id + 1, id + 1)
                    if (tmp == "n" or tmp == "") then
                        tmp = -1
                    end
                    PallyPower_Assignments[sender][id] = tmp + 0
                end
            end
            PP_NextScan = 0.1 --PallyPower_UpdateUI()
        end
        if string.find(msg, "^ASELF") then
            PallyPower_AuraAssignments[sender] = {}
            AllPallysAuras[sender] = {}
            local _, _, numbers, assign = string.find(msg, "ASELF ([0-9n]*)@?([0-9n]*)")
            for id = 0, 6 do
                rank = string.sub(numbers, id * 2 + 1, id * 2 + 1)
                talent = string.sub(numbers, id * 2 + 2, id * 2 + 2)
                if not (rank == "n") then
                    AllPallysAuras[sender][id] = {}
                    if PallyPower_AuraID[id] then
                        AllPallysAuras[sender][id]["name"] = PallyPower_AuraID[id]
                        AllPallysAuras[sender][id]["rank"] = rank
                        AllPallysAuras[sender][id]["talent"] = talent
                    end
                end
            end
            if assign then
                tmp = string.sub(assign, 1, 1)
                if (tmp == "n" or tmp == "") then
                    tmp = -1
                end
                PallyPower_AuraAssignments[sender] = tmp + 0
            end
            PP_NextScan = 0 --PallyPower_UpdateUI()
        end
        if string.find(msg, "^ASSIGN") then
           local  _, _, name, class, skill = string.find(msg, "^ASSIGN (.*) (.*) (.*)")
            if (not (name == sender)) and (not (PallyPower_CheckRaidLeader(sender) or PP_PerUser.freeassign)) then
                return false
            end
            if (not PallyPower_Assignments[name]) then
                PallyPower_Assignments[name] = {}
            end
            class = class + 0
            skill = skill + 0
            PallyPower_Assignments[name][class] = skill
            if name == nameplayer then
                if (PallyPower_NormalAssignments[nameplayer] and PallyPower_NormalAssignments[nameplayer][class]) then
                    for lname in pairs(PallyPower_NormalAssignments[nameplayer][class]) do
                        if skill == -1 or PallyPower_NormalAssignments[nameplayer][class][lname] == skill then
                            PallyPower_NormalAssignments[nameplayer][class][lname] = -1
                        end
                    end                    
                end
            end
            PP_NextScan = 0.1 --PallyPower_UpdateUI()
        end
        if string.find(msg, "^AASSIGN") then
            local _, _, name, skill = string.find(msg, "^AASSIGN (.*) (.*)")
            if (not (name == sender)) and (not (PallyPower_CheckRaidLeader(sender) or PP_PerUser.freeassign)) then
                return false
            end
            if (not PallyPower_AuraAssignments[name]) then
                PallyPower_AuraAssignments[name] = {}
            end
            skill = skill + 0
            PallyPower_AuraAssignments[name] = skill
            PP_NextScan = 0 --PallyPower_UpdateUI()
        end
        if string.find(msg, "^MASSIGN") then
            local _, _, name, skill = string.find(msg, "^MASSIGN (.*) (.*)")
            if (not (name == sender)) and (not (PallyPower_CheckRaidLeader(sender) or PP_PerUser.freeassign)) then
                return false
            end
            if (not PallyPower_Assignments[name]) then
                PallyPower_Assignments[name] = {}
            end
            skill = skill + 0
            for class = 0, 9 do
                PallyPower_Assignments[name][class] = skill
                if name == nameplayer then
                    if (PallyPower_NormalAssignments[nameplayer] and PallyPower_NormalAssignments[nameplayer][class]) then
                        for lname in pairs(PallyPower_NormalAssignments[nameplayer][class]) do
                            if skill == -1 or PallyPower_NormalAssignments[nameplayer][class][lname] == skill then
                                PallyPower_NormalAssignments[nameplayer][class][lname] = -1
                            end
                        end                    
                    end
                end
            end
            PP_NextScan = 0.1 --PallyPower_UpdateUI()
        end
        if string.find(msg, "^SYMCOUNT ([0-9]*)") then
            local _, _, count = string.find(msg, "^SYMCOUNT ([0-9]*)")
            if AllPallys[sender] then
                if count == nil or count == "0" then
                    AllPallys[sender]["symbols"] = 0
                else
                    AllPallys[sender]["symbols"] = count
                end
            else
                PallyPower_SendMessage("REQ")
            end
        end
	    if strfind(msg, "^COOLDOWNS ([0-9]*)") then
            local _, _, cooldowns = string.find(msg, "^COOLDOWNS ([0-9]*)")
            local diAvailable = string.sub(cooldowns, 1, 1)
            local lhAvailable = string.sub(cooldowns, 2, 2)
            AllPallys[sender]["DivineIntervention"] = (diAvailable == "1")
            AllPallys[sender]["LayOnHands"] = (lhAvailable == "1")
        end
        if string.find(msg, "FREEASSIGN YES") then
            if AllPallys[sender] then
                AllPallys[sender]["freeassign"] = true
            else
                PallyPower_SendMessage("REQ")
            end
        end
        if string.find(msg, "FREEASSIGN NO") then
            if AllPallys[sender] then
                AllPallys[sender]["freeassign"] = false
            else
                PallyPower_SendMessage("REQ")
            end
        end
        if string.find(msg, "^TANK") then
            local _, _, name = string.find(msg, "^TANK (.*)")
            if (not (name == sender)) and (not (PallyPower_CheckRaidLeader(sender) or PP_PerUser.freeassign)) then
                return false
            end
            PallyPower_Tanks[name] = true
            if pfUI ~= nil and pfUI.uf ~= nil and pfUI.uf.raid ~= nil and pfUI.uf.raid.tankrole ~= nil then
                pfUI.uf.raid.tankrole[name] = true
            end
        end
        if string.find(msg, "^TANKCLEAR") then
            local _, _, name = string.find(msg, "^TANKCLEAR (.*)")
            if (not (name == sender)) and (not (PallyPower_CheckRaidLeader(sender) or PP_PerUser.freeassign)) then
                return false
            end
            if PallyPower_Tanks[name] then
                PallyPower_Tanks[name] = nil
                if pfUI ~= nil and pfUI.uf ~= nil and pfUI.uf.raid ~= nil and pfUI.uf.raid.tankrole ~= nil then
                    pfUI.uf.raid.tankrole[name] = nil
                end
            end
        end
        if string.find(msg, "^CLEAR") then
            PallyPower_Clear(true, sender)
        end
        if string.find(msg, "^VERSION") then
            local  _, _, msgVer = string.find(msg, "^VERSION (.*)")
            if msgVer > PallyPower_Version and not(versionBumpDisplayed) then
                versionBumpDisplayed = true
                DEFAULT_CHAT_FRAME:AddMessage(PALLYPOWER_MESSAGE_NEWVERSION.." ("..msgVer..")")
            end
        end
    end
end

function PallyPower_ResetPosition()
    if PP_PerUser.frameslocked == false then
        local frame = PallyPowerBuffBar
        if frame then
            frame:ClearAllPoints()
            frame:SetPoint("CENTER", 0, 0)
            DEFAULT_CHAT_FRAME:AddMessage(PALLYPOWER_MESSAGE_BB_CENTERED)
        else
            DEFAULT_CHAT_FRAME:AddMessage(PALLYPOWER_MESSAGE_BB_NOTFOUND)
        end
    end
end

function PallyPower_ShowCredits()
    GameTooltip:SetOwner(this, "ANCHOR_TOPLEFT")
    GameTooltip:SetText(PallyPower_Credits1, 1, 1, 1)
    GameTooltip:AddLine(PallyPower_Credits2, 1, 1, 1)
    GameTooltip:AddLine(PallyPower_Credits3)
    GameTooltip:AddLine(PallyPower_Credits4, 0, 1, 0)
    GameTooltip:AddLine(PallyPower_Credits5)
    GameTooltip:AddLine(tostring(PallyPower_ShowMemoryUsage()) .. "MB")
    GameTooltip:Show()
end

function PallyPower_ShowAuras(btn)
    GameTooltip:SetOwner(this, "ANCHOR_TOPLEFT")
    _, _, pnum, _ = string.find(btn:GetName(), "PallyPowerFramePlayer(.+)Class")
    pname = getglobal("PallyPowerFramePlayer" .. pnum .. "Name"):GetText()
    local auras = AllPallysAuras[pname]
    if auras then
        GameTooltip:SetText(pname..PallyPower_Auras, 1, 1, 1)
        for i = 3, 6 do
            if auras[i] then
                local strAura = auras[i].name.." "..auras[i].rank.."+"..auras[i].talent            
                GameTooltip:AddLine(strAura)
            end
        end    
        GameTooltip:Show()
    end
end

function PallyPower_ShowSeals(btn)
    GameTooltip:SetOwner(this, "ANCHOR_TOPLEFT")
    _, _, pnum, _ = string.find(btn:GetName(), "PallyPowerFramePlayer(.+)Class")
    pname = getglobal("PallyPowerFramePlayer" .. pnum .. "Name"):GetText()
    local seals = AllPallysSeals[pname]
    if seals then
        GameTooltip:SetText(pname..PallyPower_Seals, 1, 1, 1)
        for i = 0, 5 do
            if seals[i] then
                local strSeal = seals[i].name.." "..seals[i].rank.."+"..seals[i].talent            
                GameTooltip:AddLine(strSeal)
            end
        end    
        GameTooltip:Show()
    end
end


function PallyPowerFrame_MouseDown(arg1)
    if (((not PallyPowerFrame.isLocked) or (PallyPowerFrame.isLocked == 0)) and (arg1 == "LeftButton" and (PP_PerUser.frameslocked == false))) then
        PallyPowerFrame:StartMoving()
        PallyPowerFrame.isMoving = true
    end
end

function PallyPowerFrame_MouseUp()
    if (PallyPowerFrame.isMoving) then
        PallyPowerFrame:StopMovingOrSizing()
        PallyPowerFrame.isMoving = false
    end
end

function PallyPowerBuffBar_MouseDown(arg1)
    if
        (((not PallyPowerBuffBar.isLocked) or (PallyPowerBuffBar.isLocked == 0)) and
            ((arg1 == "LeftButton") or (arg1 == "RightButton")) and  (PP_PerUser.frameslocked == false))
     then
        PallyPowerBuffBar:StartMoving()
        PallyPowerBuffBar.isMoving = true
        PallyPowerBuffBar.startPosX = PallyPowerBuffBar:GetLeft()
        PallyPowerBuffBar.startPosY = PallyPowerBuffBar:GetTop()
    end
end

function PallyPowerBuffBar_MouseUp()
    if (PallyPowerBuffBar.isMoving) then
        PallyPowerBuffBar:StopMovingOrSizing()
        PallyPowerBuffBar.isMoving = false
    end
    if PP_PerUser.frameslocked == false then
        if
            abs(PallyPowerBuffBar.startPosX - PallyPowerBuffBar:GetLeft()) < 2 and
                abs(PallyPowerBuffBar.startPosY - PallyPowerBuffBar:GetTop()) < 2
        then
            PallyPowerFrame:Show()
            PP_NextScan = 0 --PallyPower_UpdateUI()
        end
    else
        PallyPowerFrame:Show()
        PP_NextScan = 0 --PallyPower_UpdateUI()
    end
end

function PallyPowerGridButton_OnLoad(btn)
end

function PallyPowerGridButton_OnClick(btn, mouseBtn)
    local nameplayer = UnitName("player")
    local _, _, pnum, class = string.find(btn:GetName(), "PallyPowerFramePlayer(.+)Class(.+)")
    if class == "A" then class = 10 end
    if class == "S" then class = 11 end
    pnum = pnum + 0
    class = class + 0
    pname = getglobal("PallyPowerFramePlayer" .. pnum .. "Name"):GetText()
    if not PallyPower_CanControl(pname) then
        return false
    end

    if (mouseBtn == "RightButton") then
        if class ~= PALLYPOWER_AURA_CLASS and class ~= PALLYPOWER_SEAL_CLASS then
            PallyPower_Assignments[pname][class] = -1
            if (PallyPower_NormalAssignments[nameplayer] and PallyPower_NormalAssignments[nameplayer][class]) then
                for lname in pairs(PallyPower_NormalAssignments[nameplayer][class]) do
                    PallyPower_NormalAssignments[nameplayer][class][lname] = -1
                end                    
            end
            PP_NextScan = 0 --PallyPower_UpdateUI()
            PallyPower_SendMessage("ASSIGN " .. pname .. " " .. class .. " -1")
        elseif class == PALLYPOWER_AURA_CLASS then
            PallyPower_AuraAssignments[pname] = -1
            PP_NextScan = 0 --PallyPower_UpdateUI()
            PallyPower_SendMessage("AASSIGN " .. pname .. " " .. "-1")
        elseif class == PALLYPOWER_SEAL_CLASS then
            PallyPower_SealAssignments[pname] = -1
            PP_NextScan = 0 --PallyPower_UpdateUI()
            PallyPower_SendMessage("SASSIGN " .. pname .. " " .. "-1")
        end
    else
        PallyPower_PerformCycle(pname, class, false)
    end
end

function PallyPowerGridButton_OnLeave(btn)
end

function PallyPowerGridButton_OnEnter(btn)
end

function PallyPower_PerformAuraCycleBackwards(name, skipempty)
    local shift = IsShiftKeyDown()
    if not PallyPower_AuraAssignments[name] then
        cur = 7
    else
        cur = PallyPower_AuraAssignments[name]
        if skipempty == false then
            if cur == -1 then
                cur = 7
            end
        else
            if cur == 0 then
                cur = 7
            end
        end
    end

    local stoploop = -1

    if skipempty == false then
        PallyPower_AuraAssignments[name] = -1
        stoploop = -1
    else
        PallyPower_AuraAssignments[name] = 0
        stoploop = 0
    end

    for test = cur - 1, stoploop, -1 do
        cur = test
        if PallyPower_AuraCanBuff(name, test) and ( PallyPower_AuraNeedsBuff(test) or shift) then
            do
                break
            end
        end
    end

    PallyPower_AuraAssignments[name] = cur
    PallyPower_SendMessage("AASSIGN " .. name .. " "  .. cur)

    PP_NextScan = 0 --PallyPower_UpdateUI()
end

function PallyPower_PerformAuraCycle(name, skipempty)
    local shift = IsShiftKeyDown()
    if not PallyPower_AuraAssignments[name] then
        if skipempty == false then
            cur = -1
        else
            cur = 0
        end
    else
        cur = PallyPower_AuraAssignments[name]
    end
    PallyPower_AuraAssignments[name] = -1
    for test = cur + 1, 7 do
        if PallyPower_AuraCanBuff(name, test) and ( PallyPower_AuraNeedsBuff(test) or shift)  then
            cur = test
            do
                break
            end
        end
    end

    if (cur == 7) then
        if skipempty == false then
            cur = -1
        else
            cur = 0
        end
    end

    PallyPower_AuraAssignments[name] = cur
    PallyPower_SendMessage("AASSIGN " .. name .. " " .. cur)

    PP_NextScan = 0 --PallyPower_UpdateUI()
end

function PallyPower_PerformSealCycleBackwards(name, skipempty)
    local shift = IsShiftKeyDown()
    if not PallyPower_SealAssignments[name] then
        cur = 5
    else
        cur = PallyPower_SealAssignments[name]
        if skipempty == false then
            if cur == -1 then
                cur = 5
            end
        else
            if cur == 0 then
                cur = 5
            end
        end
    end

    local stoploop = -1

    if skipempty == false then
        PallyPower_SealAssignments[name] = -1
        stoploop = -1
    else
        PallyPower_SealAssignments[name] = 0
        stoploop = 0
    end

    for test = cur - 1, stoploop, -1 do
        cur = test
        if PallyPower_SealCanBuff(name, test) and ( PallyPower_SealNeedsBuff(test) or shift) then
            do
                break
            end
        end
    end

    PallyPower_SealAssignments[name] = cur
    PallyPower_SendMessage("SASSIGN " .. name .. " "  .. cur)

    PP_NextScan = 0 --PallyPower_UpdateUI()
end

function PallyPower_PerformSealCycle(name, skipempty)
    local shift = IsShiftKeyDown()
    if not PallyPower_SealAssignments[name] then
        if skipempty == false then
            cur = -1
        else
            cur = 0
        end
    else
        cur = PallyPower_SealAssignments[name]
    end
    PallyPower_SealAssignments[name] = -1
    for test = cur + 1, 5 do
        if PallyPower_SealCanBuff(name, test) and ( PallyPower_SealNeedsBuff(test) or shift)  then
            cur = test
            do
                break
            end
        end
    end

    if (cur == 5) then
        if skipempty == false then
            cur = -1
        else
            cur = 0
        end
    end

    PallyPower_SealAssignments[name] = cur
    PallyPower_SendMessage("SASSIGN " .. name .. " " .. cur)

    PP_NextScan = 0 --PallyPower_UpdateUI()
end

function PallyPower_PerformCycleBackwards(name, class, skipempty)
    local nameplayer = UnitName("player")
    if class == PALLYPOWER_AURA_CLASS then
        PallyPower_PerformAuraCycleBackwards(name, skipempty)
        return
    end
    if class == PALLYPOWER_SEAL_CLASS then
        PallyPower_PerformSealCycleBackwards(name, skipempty)
        return
    end

    if skipempty == false then
        shift = IsShiftKeyDown()
    end

    --force pala (all buff possible) when shift wheeling
    if shift then
        class = 4
    end

    if not PallyPower_Assignments[name][class] then
        cur = 6
    else
        cur = PallyPower_Assignments[name][class]
        if skipempty == false then
            if cur == -1 then
                cur = 6
            end
        else
            if cur == 0 then
                cur = 6
            end
        end
    end

    local stoploop = -1

    if skipempty == false then
        PallyPower_Assignments[name][class] = -1
        stoploop = -1
    else
        PallyPower_Assignments[name][class] = 0
        stoploop = 0
    end

    for test = cur - 1, stoploop, -1 do
        cur = test
        if PallyPower_CanBuff(name, test) and (PallyPower_NeedsBuff(class, test) or shift) then
            do
                break
            end
        end
    end

    if shift then
        for test = 0, 9 do
            PallyPower_Assignments[name][test] = cur
            if name == nameplayer then
                if (PallyPower_NormalAssignments[nameplayer] and PallyPower_NormalAssignments[nameplayer][test]) then
                    for lname in pairs(PallyPower_NormalAssignments[nameplayer][test]) do
                        if cur == -1 or PallyPower_NormalAssignments[nameplayer][test][lname] == cur then
                            PallyPower_NormalAssignments[nameplayer][test][lname] = -1
                        end
                    end                    
                end
            end
        end
        PallyPower_SendMessage("MASSIGN " .. name .. " " .. cur)
    else
        PallyPower_Assignments[name][class] = cur
        if name == nameplayer then
            if (PallyPower_NormalAssignments[nameplayer] and PallyPower_NormalAssignments[nameplayer][class]) then
                for lname in pairs(PallyPower_NormalAssignments[nameplayer][class]) do
                    if cur == -1 or PallyPower_NormalAssignments[nameplayer][class][lname] == cur then
                        PallyPower_NormalAssignments[nameplayer][class][lname] = -1
                    end
                end                    
            end
        end
        PallyPower_SendMessage("ASSIGN " .. name .. " " .. class .. " " .. cur)
    end    
    PP_NextScan = 0 --PallyPower_UpdateUI()
end

function PallyPower_PerformCycle(name, class, skipempty)
    local nameplayer = UnitName("player")

    if class == PALLYPOWER_AURA_CLASS then
        PallyPower_PerformAuraCycle(name, skipempty)
        return
    end

    if class == PALLYPOWER_SEAL_CLASS then
        PallyPower_PerformSealCycle(name, skipempty)
        return
    end

    if skipempty == false then
        shift = IsShiftKeyDown()
    end    

    --force pala (all buff possible) when shift wheeling
    if shift then
        class = 4
    end

    if not PallyPower_Assignments[name][class] then
        if skipempty == false then
            cur = -1
        else
            cur = 0
        end
    else
        cur = PallyPower_Assignments[name][class]
    end
    if skipempty == false then
        PallyPower_Assignments[name][class] = -1
    else
        PallyPower_Assignments[name][class] = 0
    end
    for test = cur + 1, 6 do
        if PallyPower_CanBuff(name, test) and (PallyPower_NeedsBuff(class, test) or shift) then
            cur = test
            do
                break
            end
        end
    end

    if (cur == 6) then
        if skipempty == false then
            cur = -1
        else
            cur = 0
        end
    end

    if shift then
        for test = 0, 9 do
            PallyPower_Assignments[name][test] = cur
            if name == nameplayer then
                if (PallyPower_NormalAssignments[nameplayer] and PallyPower_NormalAssignments[nameplayer][test]) then
                    for lname in pairs(PallyPower_NormalAssignments[nameplayer][test]) do
                        if cur == -1 or PallyPower_NormalAssignments[nameplayer][test][lname] == cur then
                            PallyPower_NormalAssignments[nameplayer][test][lname] = -1
                        end
                    end                    
                end
            end
        end
        PallyPower_SendMessage("MASSIGN " .. name .. " " .. cur)
    else
        PallyPower_Assignments[name][class] = cur
        if name == nameplayer then
            if (PallyPower_NormalAssignments[nameplayer] and PallyPower_NormalAssignments[nameplayer][class]) then
                for lname in pairs(PallyPower_NormalAssignments[nameplayer][class]) do
                    if cur == -1 or PallyPower_NormalAssignments[nameplayer][class][lname] == cur then
                        PallyPower_NormalAssignments[nameplayer][class][lname] = -1
                    end
                end                    
            end
        end
        PallyPower_SendMessage("ASSIGN " .. name .. " " .. class .. " " .. cur)
    end

    PP_NextScan = 0 --PallyPower_UpdateUI()
end

function PallyPower_AuraCanBuff(name, test)
    if test == 7 then
        return true
    end
    if (not AllPallysAuras[name]) or (not AllPallysAuras[name][test]) or (AllPallysAuras[name][test]["rank"] == 0) then
        return false
    end
    return true
end

function PallyPower_AuraNeedsBuff(test)
    if test == 7 then
        return true
    end
    if test == -1 then
        return true
    end

    for name, skills in PallyPower_AuraAssignments do
        if (AllPallysAuras[name]) and (skills == test) then
            return false
        end
    end
    return true
end

function PallyPower_SealCanBuff(name, test)
    if test == 5 then
        return true
    end
    if (not AllPallysSeals[name]) or (not AllPallysSeals[name][test]) or (AllPallysSeals[name][test]["rank"] == 0) then
        return false
    end
    return true
end

function PallyPower_SealNeedsBuff(test)
    if test == 5 then
        return true
    end
    if test == -1 then
        return true
    end

    for name, skills in PallyPower_SealAssignments do
        if (AllPallysSeals[name]) and (skills == test) then
            return false
        end
    end
    return true
end

function PallyPower_CanBuff(name, test)
    if test == 6 then
        return true
    end
    if (not AllPallys[name][test]) or (AllPallys[name][test]["rank"] == 0) then
        return false
    end
    return true
end

function PallyPower_NeedsBuff(class, test)
    if test == 6 then
        return true
    end
    if test == -1 then
        return true
    end
    if PP_PerUser.smartbuffs then
        -- no wisdom for warriors and rogues
        if (class == 0 or class == 1) and test == 0 then
            return false
        end
        -- no salv for warriors
        --if class == 0 and test == 2 then
        --    return false
        --end
        -- no might for casters
        if (class == 2 or class == 6 or class == 7) and test == 1 then --class == 5 or allow Might on Hunters
            return false
        end
    end

    for name, skills in PallyPower_Assignments do
        if (AllPallys[name]) and ((skills[class]) and (skills[class] == test)) then
            return false
        end
    end
    return true
end

function PallyPower_GetPlayerGroupID(pname)
    if GetNumRaidMembers() == 0 then
        return "" --Party
    end
    for i = 1, GetNumRaidMembers(), 1 do
        local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i)
        if (name == pname) then
            return "G"..subgroup --G1, G2 ... G8
        end
    end
end

function PallyPower_CheckRaidLeader(nick)
    if GetNumRaidMembers() == 0 then
        for i = 1, GetNumPartyMembers(), 1 do
            if nick == UnitName("party" .. i) and UnitIsPartyLeader("party" .. i) then
                return true
            end
        end
        return false
    end
    for i = 1, GetNumRaidMembers(), 1 do
        local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i)
        if (rank >= 1 and name == nick) then
            return true
        end
    end
    return false
end

function PallyPower_CanControl(name)
    return (IsPartyLeader() or IsRaidLeader() or IsRaidOfficer() or (name == UnitName("player") or (AllPallys[name] and (AllPallys[name].freeassign == true))))
end

function PallyPower_ScanInventory()
    if not PP_IsPally then
        return
    end
    PP_Debug("Scanning for symbols")
    oldcount = PP_Symbols
    PP_Symbols = 0
    for bag = 0, 4 do
        local bagslots = GetContainerNumSlots(bag)
        if (bagslots) then
            for slot = 1, bagslots do
                local link = GetContainerItemLink(bag, slot)
                if (link and string.find(link, PallyPower_Symbol)) then
                    local _, count, locked = GetContainerItemInfo(bag, slot)
                    PP_Symbols = PP_Symbols + count
                end
            end
        end
    end
    if PP_Symbols ~= oldcount then
        PallyPower_SendMessage("SYMCOUNT " .. PP_Symbols)
    end
    AllPallys[UnitName("player")]["symbols"] = PP_Symbols
    AllPallys[UnitName("player")]["freeassign"] = PP_PerUser.freeassign
end

function PallyPower_PaladinLeftGroup()
    local AllPallysScanned = {}
    local Scan_Paladins = {}
    if GetNumRaidMembers() > 0 then
        for i = 1, GetNumRaidMembers() do
            tinsert(Scan_Paladins, "raid" .. i)
        end
    else
        tinsert(Scan_Paladins, "player")
        for i = 1, GetNumPartyMembers() do
            tinsert(Scan_Paladins, "party" .. i)
        end
    end
    while Scan_Paladins[1] do
        local unit = Scan_Paladins[1]
        local _,class = UnitClass(unit)
        if class == "PALADIN" then
            local name = UnitName(unit)
            AllPallysScanned[name] = true
        end
        tremove(Scan_Paladins, 1)
    end
    for name, _ in pairs(PallyPower_Assignments) do
        if AllPallysScanned[name] == nil then
            return true -- a paladin left the group
        end
    end
end

function PallyPower_ScanRaid()
    if not PP_IsPally then
        return
    end
    if not (PP_ScanInfo) then
        PP_Scanners = {}
        PP_ScanInfo = {}
        if GetNumRaidMembers() > 0 then
            for i = 1, GetNumRaidMembers() do
                tinsert(PP_Scanners, "raid" .. i)
            end
            INRAID = 1
        else
            tinsert(PP_Scanners, "player")
            for i = 1, GetNumPartyMembers() do
                tinsert(PP_Scanners, "party" .. i)
            end
            INRAID = 0
        end
    end
    local tests = PP_PerUser.scanperframe
    if (not tests) then
        tests = 1
    end

    while PP_Scanners[1] do
        unit = PP_Scanners[1]
        local name = UnitName(unit)
        local class = UnitClass(unit)
        if (name and class) then
            local cid = PallyPower_GetClassID(class)
            if cid == 5 then -- hunters
                if GetNumRaidMembers() > 0 then
                    local petId = "raidpet" .. string.sub(unit, 5)
                    local pet_name = UnitName(petId)

                    if pet_name then
                        local classID = 9
                        if not PP_ScanInfo[classID] then
                            PP_ScanInfo[classID] = {}
                        end

                        PP_ScanInfo[classID][petId] = {}
                        PP_ScanInfo[classID][petId]["name"] = pet_name
                        PP_ScanInfo[classID][petId]["visible"] = UnitIsVisible(petId)

                        local j = 1
                        while UnitBuff(petId, j, true) do
                            local buffIcon, _ = UnitBuff(petId, j, true)
                            local txtID = PallyPower_GetBuffTextureID(buffIcon)
                            if txtID > 5 then
                                txtID = txtID - 6
                            end
                            PP_ScanInfo[classID][petId][txtID] = true
                            j = j + 1
                        end
                    end
                else
                    local petId = "partypet" .. string.sub(unit, 6)
                    local pet_name = UnitName(petId)

                    if pet_name then
                        local classID = 9
                        if not PP_ScanInfo[classID] then
                            PP_ScanInfo[classID] = {}
                        end

                        PP_ScanInfo[classID][petId] = {}
                        PP_ScanInfo[classID][petId]["name"] = pet_name
                        PP_ScanInfo[classID][petId]["visible"] = UnitIsVisible(petId)

                        local j = 1
                        while UnitBuff(petId, j, true) do
                            local buffIcon, _ = UnitBuff(petId, j, true)
                            local txtID = PallyPower_GetBuffTextureID(buffIcon)
                            if txtID > 5 then
                                txtID = txtID - 6
                            end
                            PP_ScanInfo[classID][petId][txtID] = true
                            j = j + 1
                        end
                    end
                end
            end

            if not PP_ScanInfo[cid] then
                PP_ScanInfo[cid] = {}
            end
            PP_ScanInfo[cid][unit] = {}
            PP_ScanInfo[cid][unit]["name"] = name
            PP_ScanInfo[cid][unit]["visible"] = UnitIsVisible(unit)

            local j = 1
            while UnitBuff(unit, j, true) do
                local buffIcon, _ = UnitBuff(unit, j, true)
                local txtID = PallyPower_GetBuffTextureID(buffIcon)
                if txtID > 5 then
                    txtID = txtID - 6
                end
                PP_ScanInfo[cid][unit][txtID] = true
                j = j + 1
            end
        end
        tremove(PP_Scanners, 1)
        tests = tests - 1
        PP_Debug("Scanning " .. unit .. " and " .. tests .. " remain")
        if (tests <= 0) then
            return
        end
    end
    CurrentBuffs = PP_ScanInfo
    PP_ScanInfo = nil
    PP_NextScan = PP_PerUser.scanfreq
    PallyPower_ScanInventory()
    PallyPower_UpdateUI()
end

function PallyPower_GetClassID(class)
    for id, name in PallyPower_ClassID do
        if (name == class) then
            return id
        end
    end
    return -1
end

function PallyPower_GetBuffTextureID(text)
    local icons_prefix
    if PP_PerUser.usehdicons == true then
        icons_prefix = "AddOns\\PallyPowerTW\\HD"
    else
        icons_prefix = "AddOns\\PallyPowerTW\\"
    end

    for id, name in BuffIcon do
        if (string.gsub(name,icons_prefix,"") == text) then
            return id
        end
    end
    -- Check also the small buffs
    for id, name in BuffIconSmall do
        if (string.gsub(name,icons_prefix,"") == text) then
            return id
        end
    end
    return -2
end

function PallyPowerBuffButton_OnLoad(btn)
    this:SetBackdropColor(0, 0, 0, PP_PerUser.transparency)
end

function PallyPowerBuffButton_OnClick(btn, mousebtn)
    if (btn == getglobal("PallyPowerBuffBarRF")) and (hasRighteousFury == true) and 
       (nameRighteousFury ~= nil)
    then
        CastSpellByName(nameRighteousFury)
        return
    end

    if btn == getglobal("PallyPowerBuffBarAura") then
        local auraId = PallyPower_AuraAssignments[UnitName("player")]
        if auraId ~= -1 and 
           AllPallysAuras[UnitName("player")] and 
           AllPallysAuras[UnitName("player")][auraId] and
           AllPallysAuras[UnitName("player")][auraId]["id"]
        then
            if GetSpellCooldown(AllPallysAuras[UnitName("player")][auraId]["id"], BOOKTYPE_SPELL) < 1 then
                CastSpell(AllPallysAuras[UnitName("player")][auraId]["id"], BOOKTYPE_SPELL)
            else
                return
            end
        end    
        return
    end

    if btn == getglobal("PallyPowerBuffBarSeal") then
        local sealId = PallyPower_SealAssignments[UnitName("player")]
        if sealId ~= -1 and 
           AllPallysSeals[UnitName("player")] and 
           AllPallysSeals[UnitName("player")][sealId] and
           AllPallysSeals[UnitName("player")][sealId]["id"]
        then
            if GetSpellCooldown(AllPallysSeals[UnitName("player")][sealId]["id"], BOOKTYPE_SPELL) < 1 then
                CastSpell(AllPallysSeals[UnitName("player")][sealId]["id"], BOOKTYPE_SPELL)
            else
                return
            end
        end    
        return
    end

    local rankInfo = PallyPower_ScanSpells()

    RestorSelfAutoCastTimeOut = 1
    if (GetCVar("autoSelfCast") == "1") then
        RestorSelfAutoCast = true
        SetCVar("autoSelfCast", "0")
    end

    DoEmote("STAND") -- Force player stand

    ClearTarget()
    local castspellid = -1
    local castspelloverride = -1    

    if AllPallys[UnitName("player")][btn.buffID] == nil then return end
    PP_Debug("Casting " .. btn.buffID .. " on " .. btn.classID)
    if (mousebtn == "RightButton") then
        if GetSpellCooldown(AllPallys[UnitName("player")][btn.buffID]["idsmall"], BOOKTYPE_SPELL) < 1 then
            CastSpell(AllPallys[UnitName("player")][btn.buffID]["idsmall"], BOOKTYPE_SPELL)
            castspellid = btn.buffID
        else
            return
        end
    elseif (mousebtn == "LeftButton") then
        if GetSpellCooldown(AllPallys[UnitName("player")][btn.buffID]["id"], BOOKTYPE_SPELL) < 1 then
            CastSpell(AllPallys[UnitName("player")][btn.buffID]["id"], BOOKTYPE_SPELL)
            castspellid = btn.buffID
        else
            return
        end
    end

    local RecentCast = false
    local skipclear = false
    if (RegularBlessings == true) then
        if LastCast[btn.buffID .. btn.classID] and LastCast[btn.buffID .. btn.classID] > (PALLYPOWER_NORMALBLESSINGDURATION) - PALLYPOWER_BLESSINGTRESHOLD then
            RecentCast = true
        end
    else
        if (mousebtn == "LeftButton" and not (AllPallys[UnitName("player")][btn.buffID]["id"] == AllPallys[UnitName("player")][btn.buffID]["idsmall"])) then
            if LastCast[btn.buffID .. btn.classID] and LastCast[btn.buffID .. btn.classID] > (PALLYPOWER_GREATERBLESSINGDURATION) - PALLYPOWER_BLESSINGTRESHOLD then
                RecentCast = true
            end
        else
            if LastCast[btn.buffID .. btn.classID] and LastCast[btn.buffID .. btn.classID] > (PALLYPOWER_NORMALBLESSINGDURATION) - PALLYPOWER_BLESSINGTRESHOLD then
                RecentCast = true
            end
        end
    end
    local LastRecentCast = RecentCast
    for unit, stats in CurrentBuffs[btn.classID] do
        castspelloverride = -1
        if RecentCast ~= LastRecentCast then
            RecentCast = LastRecentCast
        end
        skipclear = false
        if mousebtn == "LeftButton" and GetNormalBlessings(UnitName("player"),btn.classID,UnitName(unit)) ~= -1 then
            --continue with next unit if GB and unit has Individual blessings assigned
        else 
            -- Disable Greater Blessing LeftButton for pets if assignments differ
            if (btn.classID == 9) and (mousebtn == "LeftButton") then
                local player = UnitName("player")
                if PallyPower_Assignments[player][0] ~= PallyPower_Assignments[player][9] then
                    SpellStopTargeting()
                    TargetLastTarget()
                    PallyPower_ShowFeedback(
                        format(PallyPower_BlessingsDiffer),
                        1, 1, 0 -- Yellow color for feedback
                    )
                    return
                end
            end

            if mousebtn == "RightButton" then
                local bltest = GetNormalBlessings(UnitName("player"),btn.classID, stats.name)
                if string.find(table.concat(btn.need, " "), stats.name) or 
                   (bltest ~= -1 and LastCastPlayer[stats.name] and ( LastCastPlayer[stats.name] < PALLYPOWER_NORMALBLESSINGDURATION - PALLYPOWER_BLESSINGTRESHOLD ) ) then 
                    RecentCast = false
                    skipclear = true
                    castspelloverride = bltest
                end
            end

            if
                SpellCanTargetUnit(unit) and (not UnitIsDeadOrGhost(unit)) and PallyPower_CheckTargetLoS(unit) and
                    not (RecentCast and string.find(table.concat(LastCastOn[btn.classID], " "), unit)) and
                    (not PallyPower_CastingSalvationOnTank(unit, castspellid, castspelloverride))
            then
                PP_Debug("Trying to cast on " .. unit)
                local blessing = GetNormalBlessings(UnitName("player"),btn.classID, stats.name)
                if blessing ~= -1 and mousebtn == "RightButton" then
                    if GetSpellCooldown(AllPallys[UnitName("player")][blessing]["idsmall"], BOOKTYPE_SPELL) < 1 then
                        CastSpell(AllPallys[UnitName("player")][blessing]["idsmall"], BOOKTYPE_SPELL)
                    else
                        return
                    end
                end    

                SpellTargetUnit(unit)

                PP_NextScan = 1
                if (RegularBlessings == true) then
                    LastCast[btn.buffID .. btn.classID] = PALLYPOWER_NORMALBLESSINGDURATION
                    LastCastPlayer[stats.name] = PALLYPOWER_NORMALBLESSINGDURATION
                else
                    if (mousebtn == "LeftButton" and not(AllPallys[UnitName("player")][btn.buffID]["id"] == AllPallys[UnitName("player")][btn.buffID]["idsmall"])) then
                        LastCast[btn.buffID .. btn.classID] = PALLYPOWER_GREATERBLESSINGDURATION
                    else
                        if LastCast[btn.buffID .. btn.classID] == nil or LastCast[btn.buffID .. btn.classID] < PALLYPOWER_NORMALBLESSINGDURATION then 
                            LastCast[btn.buffID .. btn.classID] = PALLYPOWER_NORMALBLESSINGDURATION
                        elseif LastCast[btn.buffID .. btn.classID] ~= nil and LastCast[btn.buffID .. btn.classID] > PALLYPOWER_NORMALBLESSINGDURATION and mousebtn == "RightButton" then 
                            LastCastPlayer[stats.name] = PALLYPOWER_NORMALBLESSINGDURATION
                        end
                        if blessing ~= -1 and mousebtn == "RightButton" then
                            LastCastPlayer[stats.name] = PALLYPOWER_NORMALBLESSINGDURATION
                        end
                    end
                end
                
                if not skipclear and not RecentCast then 
                    LastCastOn[btn.classID] = {} 
                end            
                if skipclear then
                    PallyPower_RemoveFromTable(btn.need,UnitName(unit))
                end
                if (RegularBlessings == false and mousebtn == "LeftButton" and not(AllPallys[UnitName("player")][btn.buffID]["id"] == AllPallys[UnitName("player")][btn.buffID]["idsmall"])) then
                    for unit, stats in CurrentBuffs[btn.classID] do
                        if GetNormalBlessings(UnitName("player"),btn.classID,UnitName(unit)) == -1 then   
                            if UnitIsVisible(unit) then
                                tinsert(LastCastOn[btn.classID], unit)
                            end
                        end
                    end
                    if (btn.classID == 0 or btn.classID == 9) and (PallyPower_Assignments[UnitName("player")][0] == PallyPower_Assignments[UnitName("player")][9]) then
                        local classIDToFill = (btn.classID == 9) and 0 or 9
                        if CurrentBuffs[classIDToFill] ~= nil then
                            for unit, stats in CurrentBuffs[classIDToFill] do
                                if UnitIsVisible(unit) then
                                    tinsert(LastCastOn[classIDToFill], unit)
                                end
                            end
                            LastCast[btn.buffID .. classIDToFill] = PALLYPOWER_GREATERBLESSINGDURATION
                        end
                    end
                else
                    tinsert(LastCastOn[btn.classID], unit)
                end

                if blessing ~= -1 and mousebtn == "RightButton" then
                    PallyPower_ShowFeedback(
                        format(
                            PallyPower_Casting,
                            PallyPower_BlessingID[blessing],
                            PallyPower_ClassID[btn.classID],
                            UnitName(unit)
                        ), 0, 1, 0 -- Green color for feedback
                    )
                else
                    PallyPower_ShowFeedback(
                        format(
                            PallyPower_Casting,
                            PallyPower_BlessingID[btn.buffID],
                            PallyPower_ClassID[btn.classID],
                            UnitName(unit)
                        ), 0, 1, 0 -- Green color for feedback
                    )
                end
                PP_NextScan = 1 --PallyPower_UpdateUI()
                TargetLastTarget()
                return
            end
        end
    end
    SpellStopTargeting()
    TargetLastTarget()
    PallyPower_ShowFeedback(
        format(PallyPower_CouldntFind, PallyPower_BlessingID[btn.buffID], PallyPower_ClassID[btn.classID]),
        1, 1, 0 -- Yellow color for feedback
    )
end

function PallyPower_CastingSalvationOnTank(punit, castspell, overridespell)
    if ( castspell == 2 and overridespell == -1 ) or overridespell == 2 then --Salvation
        local pname = UnitName(punit)
        if PallyPower_Tanks[pname] and PallyPower_Tanks[pname] == true then
            return true
        else
            return false    
        end
    else
        return false
    end
end

function PallyPower_AutoBless(mousebutton)
    local rankInfo = PallyPower_ScanSpells()

    RestorSelfAutoCastTimeOut = 1
    if (GetCVar("autoSelfCast") == "1") then
        RestorSelfAutoCast = true
        SetCVar("autoSelfCast", "0")
    end

    DoEmote("STAND") -- Force player stand

    classbtn = lastClassBtn
    lastClassBtnTime = PALLYPOWER_RESTARTAUTOBLESS
    local btn = getglobal("PallyPowerBuffBarBuff" .. classbtn)

    if (btn ~= nil and btn.classID and 
        PallyPower_Assignments[UnitName("player")][btn.classID] and 
        PallyPower_Assignments[UnitName("player")][btn.classID] ~= -1) then
    
        ClearTarget()
        local castspellid = -1
        local castspelloverride = -1
        
        if AllPallys[UnitName("player")][btn.buffID] == nil then 
            lastClassBtn = lastClassBtn + 1
            -- classID == 9 is for pets
            if (lastClassBtn > 10 or btn.classID == 9) then lastClassBtn = 1 end 
            return 
        end

        PP_Debug("Casting " .. btn.buffID .. " on " .. btn.classID)
        if (mousebutton == "Hotkey1") then
            if GetSpellCooldown(AllPallys[UnitName("player")][btn.buffID]["idsmall"], BOOKTYPE_SPELL) < 1 then
                CastSpell(AllPallys[UnitName("player")][btn.buffID]["idsmall"], BOOKTYPE_SPELL)
                castspellid = btn.buffID
            else
                return
            end
        elseif (mousebutton == "Hotkey2") then
            if GetSpellCooldown(AllPallys[UnitName("player")][btn.buffID]["id"], BOOKTYPE_SPELL) < 1 then
                CastSpell(AllPallys[UnitName("player")][btn.buffID]["id"], BOOKTYPE_SPELL)
                castspellid = btn.buffID
            else
                return
            end
        end

        local RecentCast = false
        local skipclear = false
        if (RegularBlessings == true) then
            if LastCast[btn.buffID .. btn.classID] and LastCast[btn.buffID .. btn.classID] > (PALLYPOWER_NORMALBLESSINGDURATION) - PALLYPOWER_BLESSINGTRESHOLD then
                RecentCast = true
            end
        else
            if (mousebutton == "Hotkey2" and not (AllPallys[UnitName("player")][btn.buffID]["id"] == AllPallys[UnitName("player")][btn.buffID]["idsmall"])) then
                if LastCast[btn.buffID .. btn.classID] and LastCast[btn.buffID .. btn.classID] > (PALLYPOWER_GREATERBLESSINGDURATION) - PALLYPOWER_BLESSINGTRESHOLD then
                    RecentCast = true
                end
            else
                if LastCast[btn.buffID .. btn.classID] and LastCast[btn.buffID .. btn.classID] > (PALLYPOWER_NORMALBLESSINGDURATION) - PALLYPOWER_BLESSINGTRESHOLD then
                    RecentCast = true
                end
            end
        end
        local LastRecentCast = RecentCast
        if (btn.classID ~= nil and CurrentBuffs[btn.classID]) then
            
            for unit, stats in CurrentBuffs[btn.classID] do
                castspelloverride = -1
                if RecentCast ~= LastRecentCast then
                    RecentCast = LastRecentCast
                end
                skipclear = false
                if mousebutton == "Hotkey2" and GetNormalBlessings(UnitName("player"),btn.classID,UnitName(unit)) ~= -1 then
                    --continue with next unit if GB and unit has Individual blessings assigned
                else
                    -- Disable Greater Blessing Hotkey2 for pets if assignments differ
                    if (btn.classID == 9) and (mousebutton == "Hotkey2") then
                        local player = UnitName("player")
                        if PallyPower_Assignments[player][0] ~= PallyPower_Assignments[player][9] then
                            SpellStopTargeting()
                            TargetLastTarget()
                            PallyPower_ShowFeedback(
                                format(PallyPower_BlessingsDiffer),
                                1, 1, 0 -- Yellow color for feedback
                            )
                            return
                        end
                    end

                    if mousebutton == "Hotkey1" then
                        local bltest = GetNormalBlessings(UnitName("player"),btn.classID, stats.name)
                        if string.find(table.concat(btn.need, " "), stats.name) or 
                           (bltest ~= -1 and LastCastPlayer[stats.name] and ( LastCastPlayer[stats.name] < PALLYPOWER_NORMALBLESSINGDURATION - PALLYPOWER_BLESSINGTRESHOLD ) ) then 
                            RecentCast = false
                            skipclear = true
                            castspelloverride = bltest
                        end
                    end
                        
                    if
                            SpellCanTargetUnit(unit) and (not UnitIsDeadOrGhost(unit)) and PallyPower_CheckTargetLoS(unit) and
                                not (RecentCast and string.find(table.concat(LastCastOn[btn.classID], " "), unit)) and 
                                (not PallyPower_CastingSalvationOnTank(unit, castspellid, castspelloverride))
                    then
                        PP_Debug("Trying to cast on " .. unit)
                        local blessing = GetNormalBlessings(UnitName("player"),btn.classID, stats.name)
                        if blessing ~= -1 and mousebutton == "Hotkey1" then
                            if GetSpellCooldown(AllPallys[UnitName("player")][blessing]["idsmall"], BOOKTYPE_SPELL) < 1 then
                                CastSpell(AllPallys[UnitName("player")][blessing]["idsmall"], BOOKTYPE_SPELL)
                            else
                                return
                            end
                        end    

                        SpellTargetUnit(unit)

                        PP_NextScan = 1
                        if (RegularBlessings == true) then
                            LastCast[btn.buffID .. btn.classID] = PALLYPOWER_NORMALBLESSINGDURATION
                            LastCastPlayer[stats.name] = PALLYPOWER_NORMALBLESSINGDURATION
                        else
                            if (mousebutton == "Hotkey2" and not(AllPallys[UnitName("player")][btn.buffID]["id"] == AllPallys[UnitName("player")][btn.buffID]["idsmall"])) then
                                LastCast[btn.buffID .. btn.classID] = PALLYPOWER_GREATERBLESSINGDURATION
                            else
                                if LastCast[btn.buffID .. btn.classID] == nil or LastCast[btn.buffID .. btn.classID] < PALLYPOWER_NORMALBLESSINGDURATION then 
                                    LastCast[btn.buffID .. btn.classID] = PALLYPOWER_NORMALBLESSINGDURATION
                                elseif LastCast[btn.buffID .. btn.classID] ~= nil and LastCast[btn.buffID .. btn.classID] > PALLYPOWER_NORMALBLESSINGDURATION and mousebtn == "Hotkey1" then 
                                    LastCastPlayer[stats.name] = PALLYPOWER_NORMALBLESSINGDURATION
                                end
                                if blessing ~= -1 and mousebutton == "Hotkey1" then
                                    LastCastPlayer[stats.name] = PALLYPOWER_NORMALBLESSINGDURATION
                                end
                            end
                        end
                        if not skipclear and not RecentCast then 
                            LastCastOn[btn.classID] = {} 
                        end
                        if skipclear then
                            PallyPower_RemoveFromTable(btn.need,UnitName(unit))
                        end
        
                        if (RegularBlessings == false and mousebutton == "Hotkey2" and not(AllPallys[UnitName("player")][btn.buffID]["id"] == AllPallys[UnitName("player")][btn.buffID]["idsmall"])) then
                            for unit, stats in CurrentBuffs[btn.classID] do
                                if GetNormalBlessings(UnitName("player"),btn.classID,UnitName(unit)) == -1 then   
                                    if UnitIsVisible(unit) then
                                        tinsert(LastCastOn[btn.classID], unit)
                                    end
                                end
                            end
                            if (btn.classID == 0 or btn.classID == 9) and (PallyPower_Assignments[UnitName("player")][0] == PallyPower_Assignments[UnitName("player")][9]) then
                                local classIDToFill = (btn.classID == 9) and 0 or 9
                                if CurrentBuffs[classIDToFill] ~= nil then
                                    for unit, stats in CurrentBuffs[classIDToFill] do
                                        if UnitIsVisible(unit) then
                                            tinsert(LastCastOn[classIDToFill], unit)
                                        end
                                    end
                                    LastCast[btn.buffID .. classIDToFill] = PALLYPOWER_GREATERBLESSINGDURATION
                                end
                            end
                        else
                            tinsert(LastCastOn[btn.classID], unit)
                        end
                        if blessing ~= -1 and mousebutton == "Hotkey1" then
                            PallyPower_ShowFeedback(
                                format(
                                    PallyPower_Casting,
                                    PallyPower_BlessingID[blessing],
                                    PallyPower_ClassID[btn.classID],
                                    UnitName(unit)
                                ), 0, 1, 0 --Green feedback for casting
                            )
                        else
                            PallyPower_ShowFeedback(
                                format(
                                    PallyPower_Casting,
                                    PallyPower_BlessingID[btn.buffID],
                                    PallyPower_ClassID[btn.classID],
                                    UnitName(unit)
                                ), 0, 1, 0 --Green feedback for casting
                            )
                        end         
                        PP_NextScan = 1 --PallyPower_UpdateUI()
                        TargetLastTarget()
                        return
                    end
                end
            end
        end
        SpellStopTargeting()
        TargetLastTarget()
        PallyPower_ShowFeedback(
            format(PallyPower_CouldntFind, PallyPower_BlessingID[btn.buffID], PallyPower_ClassID[btn.classID]),
            1, 1, 0 --Yellow feedback for not finding a target
        )
        lastClassBtn = lastClassBtn + 1
        -- classID == 9 is for pets
        if (lastClassBtn > 10 or btn.classID == 9) then lastClassBtn = 1 end 
    else
        lastClassBtn = 1
    end
end

function PallyPower_HasBlessingActive(unit,class)
    local i
    local testUnitBuff
    for i=1,40 do 
        testUnitBuff = UnitBuff(unit,i) 
        if (testUnitBuff and testUnitBuff == BlessingIcon[PallyPower_Assignments[UnitName("player")][id]]) then 
            return true
        end 
    end 
    return false
end

function PallyPowerBuffButton_OnEnter(btn)
    GameTooltip:SetOwner(this, "ANCHOR_TOPLEFT")
    GameTooltip:SetText(
        PallyPower_ClassID[btn.classID] .. PallyPower_BuffFrameText .. PallyPower_BlessingID[btn.buffID],
        1,
        1,
        1
    )
    GameTooltip:AddLine(PallyPower_Have .. table.concat(btn.have, ", "), 0.5, 1, 0.5)
    GameTooltip:AddLine(PallyPower_Need .. table.concat(btn.need, ", "), 1, 0.5, 0.5)
    GameTooltip:AddLine(PallyPower_NotHere .. table.concat(btn.range, ", "), 0.5, 0.5, 1)
    GameTooltip:AddLine(PallyPower_Dead .. table.concat(btn.dead, ", "), 1, 0, 0)
    GameTooltip:Show()
end

function PallyPowerBuffButton_OnLeave(btn)
    GameTooltip:Hide()
end
 --

--[[ MainFrame and MenuFrame Scaling ]] 
function PallyPower_StartScaling(arg1)
    if arg1 == "LeftButton" then
        this:LockHighlight()
        PallyPower.FrameToScale = this:GetParent()
        PallyPower.ScalingWidth = this:GetParent():GetWidth() * PallyPower.FrameToScale:GetParent():GetEffectiveScale()
        PallyPower.ScalingHeight =
            this:GetParent():GetHeight() * PallyPower.FrameToScale:GetParent():GetEffectiveScale()
        PallyPower_ScalingFrame:Show()
    end
end

function PallyPower_StopScaling(arg1)
    if arg1 == "LeftButton" then
        PallyPower_ScalingFrame:Hide()
        PallyPower.FrameToScale = nil
        this:UnlockHighlight()
    end
end

local function really_setpoint(frame, point, relativeTo, relativePoint, xoff, yoff)
    frame:SetPoint(point, relativeTo, relativePoint, xoff, yoff)
end

function PallyPower_ScaleFrame(scale)
    local frame = PallyPower.FrameToScale
    local oldscale = frame:GetScale() or 1
    local framex = (frame:GetLeft() or PallyPowerPerOptions.XPos) * oldscale
    local framey = (frame:GetTop() or PallyPowerPerOptions.YPos) * oldscale

    frame:SetScale(scale)
    if frame:GetName() == "PallyPowerFrame" then
        really_setpoint(PallyPowerFrame, "TOPLEFT", "UIParent", "BOTTOMLEFT", framex / scale, framey / scale)
        PP_PerUser.scalemain = scale
    end
    if frame:GetName() == "PallyPowerBuffBar" then
        really_setpoint(PallyPowerBuffBar, "TOPLEFT", "UIParent", "BOTTOMLEFT", framex / scale, framey / scale)
        PP_PerUser.scalebar = scale
    end
end

function PallyPower_ScalingFrame_OnUpdate(arg1)
    if not PallyPower.ScalingTime then
        PallyPower.ScalingTime = 0
    end
    PallyPower.ScalingTime = PallyPower.ScalingTime + arg1
    if PallyPower.ScalingTime > 0.25 then
        PallyPower.ScalingTime = 0
        local frame = PallyPower.FrameToScale
        local oldscale = frame:GetEffectiveScale()
        local framex, framey, cursorx, cursory =
            frame:GetLeft() * oldscale,
            frame:GetTop() * oldscale,
            GetCursorPosition()
        if PallyPower.ScalingWidth > PallyPower.ScalingHeight then
            if (cursorx - framex) > 32 then
                local newscale = (cursorx - framex) / PallyPower.ScalingWidth
                PallyPower_ScaleFrame(newscale)
            end
        else
            if (framey - cursory) > 32 then
                local newscale = (framey - cursory) / PallyPower.ScalingHeight
                PallyPower_ScaleFrame(newscale)
            end
        end
    end
end

function PallyPower_SetOption(opt, value)
    PP_PerUser[opt] = value
end

function PallyPower_Options()
    MinimapButtonOptionSlider:SetValue(PP_PerUser.minimapbuttonpos);
    TransparencyOptionSlider:SetValue(PP_PerUser.transparency);
    PallyPower_OptionsFrame:Show()
end

function PallyPower_ShowFeedback(msg, r, g, b, a)
    if PP_PerUser.chatfeedback then
        DEFAULT_CHAT_FRAME:AddMessage(PALLYPOWER_MSG_PREFIX .. msg, r, g, b, a)
    else
        UIErrorsFrame:AddMessage(msg, r, g, b, a)
    end
end

function PallyPowerBuffBarButton_OnMouseWheel(btn, arg1)
    pname = UnitName("player")

    if btn:GetName() == "PallyPowerBuffBarRF" or btn:GetName() == "PallyPowerBuffBarTitle" then return end

    if btn == getglobal("PallyPowerBuffBarAura") then 
        class = PALLYPOWER_AURA_CLASS 
    elseif btn == getglobal("PallyPowerBuffBarSeal") then 
        class = PALLYPOWER_SEAL_CLASS 
    else
        class = btn.classID
    end

    if not PallyPower_CanControl(pname) then
        return false
    end

    if (arg1 == -1) then
        --mouse wheel down
        PallyPower_PerformCycle(pname, class, true)
    else
        PallyPower_PerformCycleBackwards(pname, class, true)
    end
end

function PallyPowerGridButton_OnMouseWheel(btn, arg1)
    local _, _, pnum, class = string.find(btn:GetName(), "PallyPowerFramePlayer(.+)Class(.+)")
    if class == "A" then class = PALLYPOWER_AURA_CLASS end
    if class == "S" then class = PALLYPOWER_SEAL_CLASS end
    pnum = pnum + 0
    class = class + 0
    pname = getglobal("PallyPowerFramePlayer" .. pnum .. "Name"):GetText()
    if not PallyPower_CanControl(pname) then
        return false
    end

    if (arg1 == -1) then
        --mouse wheel down
        PallyPower_PerformCycle(pname, class, false)
    else
        PallyPower_PerformCycleBackwards(pname, class, false)
    end
end

function PallyPower_BarToggle()
    if ((GetNumRaidMembers() == 0 and GetNumPartyMembers() == 0) or (PP_IsPally == false)) then
        PallyPower_ShowFeedback(PALLYPOWER_MSG_NOTPALLYORRAID, 0.5, 1, 1, 1)
    else
        if PallyPowerBuffBar:IsVisible() then
            PallyPowerBuffBar:Hide()
            PallyPower_ShowFeedback(PALLYPOWER_MSG_BARHIDDEN, 0.5, 1, 1, 1)
        else
            PallyPowerBuffBar:Show()
            PallyPower_ShowFeedback(PALLYPOWER_MSG_BARVISIBLE, 0.5, 1, 1, 1)
        end
    end
end

function PallyPower_AutoBuffAll() --Test
    if not PP_IsPally then
        DEFAULT_CHAT_FRAME:AddMessage(PALLYPOWER_MSG_NOTPALLY)
        return
    end

    local nameplayer = UnitName("player")
    if not PallyPower_Assignments[nameplayer] then
        DEFAULT_CHAT_FRAME:AddMessage(PALLYPOWER_MSG_NOASSIGNMENTS)
        return
    end

    -- Iterate through all buff buttons and simulate clicks
    for i = 1, 10 do
        local btn = getglobal("PallyPowerBuffBarBuff" .. i)
        if btn and btn:IsVisible() then
            local nneed = getglobal("PallyPowerBuffBarBuff" .. i .. "Text"):GetText()
            if nneed and nneed ~= "" and tonumber(nneed) > 0 then
                -- Simulate a left-click to cast the greater blessing
                PallyPowerBuffButton_OnClick(btn, "LeftButton")
                -- Simulate a right-click to cast the normal blessing if needed
                PallyPowerBuffButton_OnClick(btn, "RightButton")
            end
        end
    end
end