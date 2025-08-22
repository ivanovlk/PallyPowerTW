PallyPower_Version = GetAddOnMetadata("PallyPowerTW", "Version")
SLASH_PALLYPOWER1 = "/pp"
SLASH_PALLYPOWER2 = "/pallypower"

BINDING_HEADER_PALLYPOWER_HEADER = "Pally Power"
BINDING_NAME_TOGGLE = "Toggle Buff Bar"
BINDING_NAME_REPORT = "Report Assignments"
BINDING_NAME_AUTOKEY1 = "Auto Normal Blessing Key"
BINDING_NAME_AUTOKEY2 = "Auto Greater Blessing Key"
BINDING_NAME_SEALKEY = "Cast Seal Key"

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

PallyPower_SealID = { };
PallyPower_SealID[0] = "Wisdom";
PallyPower_SealID[1] = "the Crusader";
PallyPower_SealID[2] = "Light";
PallyPower_SealID[3] = "Justice";
PallyPower_SealID[4] = "Command";
PallyPower_SealID[5] = "Righteousness";

PallyPower_Greater = "Greater"
if (RegularBlessings == false) 
  then
    PallyPower_BlessingSpellSearch = "Greater Blessing of (.*)";
  else
    PallyPower_BlessingSpellSearch = "Blessing of (.*)";
end
PallyPower_AuraSpellSearch = "(.*) Aura";
PallyPower_SealSpellSearch = "Seal of (.*)";
PallyPower_SealSpellPrefix = "Seal of ";

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

PallyPower_Auras = " additional Auras:"
PallyPower_Seals = " additional Seals:"

PallyPower_BuffBarTitle = "Pally Buffs (%d)"

--- By Lines... Keep People the same, feel free to add yourself in the _Credits3 line if your localizing
--- And feel free to add a friend or two to special thanks
PallyPower_Credits1 = "Pally Power - by ivanovlk"
PallyPower_Credits2 = "Version "..PallyPower_Version
PallyPower_Credits3 = ""
PallyPower_Credits4 = "Original update by Hjorim / Sneakyfoot / Rake / Xerron / Azgaardian / Aznamir"
PallyPower_Credits5 = "Updated version for Turtle WoW including Pets and other improvements by ivanovlk"

-- Buff name, Class Name
PallyPower_CouldntFind = "Couldn't find a target for %s on %s!"
PallyPower_BlessingsDiffer = "Cannot cast Greater Blessing on pets when Warrior and Pet assignments differ. Use regular blessings for pets."

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
PALLYPOWER_PRESETS = "Presets";
PALLYPOWER_OPTIONS = "Options";
PALLYPOWER_OPTIONS_TITLE = "Pally Power Options";
PALLYPOWER_OPTIONS_SCAN = "Scan Frequency (seconds):";
PALLYPOWER_OPTIONS_SCAN2 = "Poll Per Frame: ";
PALLYPOWER_OPTIONS_FEEDBACK_CHAT = "Show feedback in chat";
PALLYPOWER_OPTIONS_SMARTBUFFS = "Smart Buffs";
PALLYPOWER_OPTIONS_LOCK = "Lock All Frames";
PALLYPOWER_OPTIONS_RF = "Show Righteous Fury on BuffBar";
PALLYPOWER_OPTIONS_AURA = "Show Aura on BuffBar";
PALLYPOWER_OPTIONS_SEAL = "Show Seal on BuffBar";
PALLYPOWER_OPTIONS_MINIMAP_BUTTON = "Show Minimap Button";
PALLYPOWER_OPTIONS_MINIMAP_BUTTONPOS = "Minimap Button Position";
PALLYPOWER_OPTIONS_PLAY_SOUND = "Play sound when blessings expire";
PALLYPOWER_OPTIONS_HORIZONTAL_LAYOUT = "Horizontal BuffBar layout";
PALLYPOWER_OPTIONS_HIDE_BLIZZ_AURA = "Hide Blizzard aura frame";
PALLYPOWER_OPTIONS_USE_UNITXP_SP3_LOS = "Use UnitXP_SP3.dll for Line of Sight check";
PALLYPOWER_OPTIONS_USE_HDICONS = "Use HD Icons";
PALLYPOWER_OPTIONS_TRANSPARENCY = "Global Transparency";

PALLYPOWER_TEXT_DROPDOWN_SAVENEW = "Save New Set";
PALLYPOWER_TEXT_DROPDOWN_SAVECURRENT = "Save Current Set";
PALLYPOWER_TEXT_DROPDOWN_DELETE = "Delete Set";
PALLYPOWER_TEXT_DROPDOWN_SETS = "Apply Set";
PALLYPOWER_TEXT_DROPDOWN_NONE = "No sets";
PALLYPOWER_TEXT_WARNING = "Warning";
PALLYPOWER_TEXT_OK = "Ok";
PALLYPOWER_TEXT_CANCEL = "Cancel";
PALLYPOWER_TEXT_SAVENEW = "Save New Set As";
PALLYPOWER_TEXT_NEWNAME = "Type in the name of the new set:";
PALLYPOWER_TEXT_ALREADYEXISTS = "This name is already used by another set.";
PALLYPOWER_TEXT_MUSTENTER = "|cffff0000You must enter a name for the new set.";
PALLYPOWER_TEXT_OVERWRITE = "|cffff0000This set already exists, save over it?";
PALLYPOWER_TEXT_SAVING = "Saving set ";
PALLYPOWER_TEXT_DELETE = "Deleting set ";

PALLYPOWER_TEXT_WARNING_DELETE = "You are about to delete set '|cffffffff%s|r'.\nDo you really want to delete this set?";
PALLYPOWER_TEXT_WARNING_SAVE = "You are about to save changes to set '|cffffffff%s|r'";

PALLYPOWER_MESSAGE_BB_CENTERED = "PallyPowerBuffBar centered on the screen."
PALLYPOWER_MESSAGE_BB_NOTFOUND = "Frame PallyPowerBuffBar not found."

PALLYPOWER_MESSAGE_NEWVERSION = "New version of PallyPowerTW available"

PALLYPOWER_FREEASSIGN = "Free Assignment"
PALLYPOWER_FREEASSIGN_DESC = "Allow others to change your blessings without being Party Leader / Raid Assistant."

PALLYPOWER_MSG_PREFIX = "[PallyPower] "
PALLYPOWER_MSG_NOTPALLYORRAID = "Not in raid or not a paladin"
PALLYPOWER_MSG_BARHIDDEN = "Bar hidden"
PALLYPOWER_MSG_BARVISIBLE = "Bar visible"
PALLYPOWER_MSG_NOTPALLY = "|cffffff00PallyPower: You are not a paladin.|r"
PALLYPOWER_MSG_NOASSIGNMENTS ="|cffffff00PallyPower: No assignments found.|r"

--PALLYPOWER_HUNTER_FEIGN_DEATH = "Feign Death"