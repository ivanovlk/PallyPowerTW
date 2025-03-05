PallyPower_Version = "1.9"
SLASH_PALLYPOWER1 = "/pp"
SLASH_PALLYPOWER2 = "/pallypower"

BINDING_HEADER_PALLYPOWER_HEADER = "Pally Power"
BINDING_NAME_TOGGLE = "Toggle Buff Bar"
BINDING_NAME_REPORT = "Report Assignments"
BINDING_NAME_AUTOKEY1 = "Auto Normal Blessing Key"
BINDING_NAME_AUTOKEY2 = "Auto Greater Blessing Key"

PallyPower_BlessingID = { };
PallyPower_BlessingID[0] = "Wisdom";
PallyPower_BlessingID[1] = "Might";
PallyPower_BlessingID[2] = "Salvation";
PallyPower_BlessingID[3] = "Light";
PallyPower_BlessingID[4] = "Kings";
PallyPower_BlessingID[5] = "Sanctuary";

PallyPower_AuraID = { };
PallyPower_AuraID[0] = "Devotion";
PallyPower_AuraID[1] = "Retribution";
PallyPower_AuraID[2] = "Concentration";
PallyPower_AuraID[3] = "Shadow Resistance";
PallyPower_AuraID[4] = "Frost Resistance";
PallyPower_AuraID[5] = "Fire Resistance";
PallyPower_AuraID[6] = "Sanctity";

PallyPower_BlessingTalentSearch = "Improved Blessings";
PallyPower_ConcentrationAuraTalentSearch = "Improved Concentration Aura";
PallyPower_DevotionAuraTalentSearch = "Improved Devotion Aura";
PallyPower_RetributionAuraTalentSearch = "Improved Retribution Aura";

PallyPower_Greater = "Greater"
if (RegularBlessings == false) 
  then
    PallyPower_BlessingSpellSearch = "Greater Blessing of (.*)";
  else
    PallyPower_BlessingSpellSearch = "Blessing of (.*)";
end
PallyPower_AuraSpellSearch = "(.*) Aura";

PallyPower_Rank1 = "Rank 1"
PallyPower_RankSearch = "Rank (.*)"
PallyPower_Symbol = "Symbol of Kings"

-- _,class = UnitClass("player") returns....
PallyPower_Paladin = "PALADIN"

-- Used... ClassID .. ": Blessing of "..BlessingID
PallyPower_BuffFrameText = ": Blessing of "
PallyPower_Have = "Have: "
PallyPower_Need = "Need: "
PallyPower_NotHere = "Not Here: "
PallyPower_Dead = "Dead: "

PallyPower_Auras = " Auras:"

PallyPower_BuffBarTitle = "Pally Buffs (%d)"

--- By Lines... Keep People the same, feel free to add yourself in the _Credits3 line if your localizing
--- And feel free to add a friend or two to special thanks
PallyPower_Credits1 = "Pally Power - by ivanovlk"
PallyPower_Credits2 = "Version "..PallyPower_Version
PallyPower_Credits3 = ""
PallyPower_Credits4 = "Original update by Sneakyfoot / Rake / Xerron / Azgaardian / Aznamir"
PallyPower_Credits5 = "Updated version for Vanilla+ including Pets and other improvements by Hjorim"

-- Buff name, Class Name
PallyPower_CouldntFind = "Couldn't find a target for %s on %s!"

-- Buff name, Class name, Person Name
PallyPower_Casting = "Casting %s on %s (%s)"
-- Reporting
PallyPower_Assignments1 = "--- Paladin assignments ---"
PallyPower_Assignments2 = "--- end of assignments ---"

PallyPower_ClassID = { };
PallyPower_ClassID[0] = "Warrior";
PallyPower_ClassID[1] = "Rogue";
PallyPower_ClassID[2] = "Priest";
PallyPower_ClassID[3] = "Druid";
PallyPower_ClassID[4] = "Paladin";
PallyPower_ClassID[5] = "Hunter";
PallyPower_ClassID[6] = "Mage";
PallyPower_ClassID[7] = "Warlock";
PallyPower_ClassID[8] = "Shaman";
PallyPower_ClassID[9] = "Pet";

--XML
PALLYPOWER_CLEAR = "Clear";
PALLYPOWER_REFRESH = "Refresh";
PALLYPOWER_RESETPOSITION = "Reset Position";
PALLYPOWER_OPTIONS = "Options";
PALLYPOWER_OPTIONS_TITLE = "Pally Power Options";
PALLYPOWER_OPTIONS_SCAN = "Scan Frequency (seconds):";
PALLYPOWER_OPTIONS_SCAN2 = "Poll Per Frame: ";
PALLYPOWER_OPTIONS_FEEDBACK_CHAT = "Show feedback in chat";
PALLYPOWER_OPTIONS_SMARTBUFFS = "Smart Buffs";
PALLYPOWER_OPTIONS_REGULAR = "Enable Regular Blessing Only - NO GREATER BLESSINGS";
PALLYPOWER_OPTIONS_LOCK = "Lock All Frames";
PALLYPOWER_OPTIONS_RF = "Show Righteous Fury on BuffBar";
PALLYPOWER_OPTIONS_AURA = "Show Aura on BuffBar";
PALLYPOWER_OPTIONS_MINIMAP_BUTTON = "Show Minimap Button";
PALLYPOWER_OPTIONS_MINIMAP_BUTTONPOS = "Minimap Button Position"

PALLYPOWER_MESSAGE_BB_CENTERED = "PallyPowerBuffBar centered on the screen."
PALLYPOWER_MESSAGE_BB_NOTFOUND = "Frame PallyPowerBuffBar not found."
