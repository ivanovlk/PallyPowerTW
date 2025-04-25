PallyPower_Version = GetAddOnMetadata("PallyPowerTW", "Version")
SLASH_PALLYPOWER1 = "/pp"
SLASH_PALLYPOWER2 = "/pallypower"

BINDING_HEADER_PALLYPOWER_HEADER = "Pally Power"
BINDING_NAME_TOGGLE = "Toggle Buff Bar"
BINDING_NAME_REPORT = "Report Assignments"
BINDING_NAME_AUTOKEY1 = "Auto Normal Blessing Key"
BINDING_NAME_AUTOKEY2 = "Auto Greater Blessing Key"

PallyPower_BlessingID = { };
PallyPower_BlessingID[0] = "Sabiduría";
PallyPower_BlessingID[1] = "Poder";
PallyPower_BlessingID[2] = "Salvación";
PallyPower_BlessingID[3] = "Luz";
PallyPower_BlessingID[4] = "Reyes";
PallyPower_BlessingID[5] = "Santuario";

PallyPower_AuraID = { };
PallyPower_AuraID[0] = "Devoción";
PallyPower_AuraID[1] = "Retribución";
PallyPower_AuraID[2] = "Concentración";
PallyPower_AuraID[3] = "Resistencia a las Sombras";
PallyPower_AuraID[4] = "Resistencia a la Escarcha";
PallyPower_AuraID[5] = "Resistencia al Fuego";
PallyPower_AuraID[6] = "Santidad";

PallyPower_BlessingTalentSearch = "Bendiciones mejoradas";
PallyPower_ConcentrationAuraTalentSearch = "Aura de concentración mejorada";
PallyPower_DevotionAuraTalentSearch = "Aura de devoción mejorada";
PallyPower_RetributionAuraTalentSearch = "Aura de reprensión mejorada";

PallyPower_Greater = "Mayor"
if (RegularBlessings == false) 
  then
    PallyPower_BlessingSpellSearch = "Bendición mayor de (.*)";
  else
    PallyPower_BlessingSpellSearch = "Bendición de (.*)";
end
PallyPower_AuraSpellSearch = "Aura de (.*)";

PallyPower_Rank1 = "Rango 1"
PallyPower_RankSearch = "Rango (.*)"
PallyPower_Symbol = "Símbolo de Reyes"

-- _,class = UnitClass("player") returns....
PallyPower_Paladin = "PALADIN"

-- Used... ClassID .. ": Blessing of "..BlessingID
PallyPower_BuffFrameText = ": Bendición de "
PallyPower_Have = "Tiene: "
PallyPower_Need = "Necesita: "
PallyPower_NotHere = "Ausente: "
PallyPower_Dead = "Muerto: "

PallyPower_Auras = " auras adicionales:"

PallyPower_BuffBarTitle = "Pally Buffs (%d)"

--- By Lines... Keep People the same, feel free to add yourself in the _Credits3 line if your localizing
--- And feel free to add a friend or two to special thanks
PallyPower_Credits1 = "Pally Power - by ivanovlk"
PallyPower_Credits2 = "Version "..PallyPower_Version
PallyPower_Credits3 = ""
PallyPower_Credits4 = "Actualización original by Hjorim / Sneakyfoot / Rake / Xerron / Azgaardian / Aznamir / Nuevemasnueve"
PallyPower_Credits5 = "Versión actualizada para Turtle WoW incluyendo mascotas y otras caraterísticas by ivanovlk"

-- Buff name, Class Name
PallyPower_CouldntFind = "No hay objetivo para %s en %s!"

-- Buff name, Class name, Person Name
PallyPower_Casting = "Lanzando %s en %s (%s)"
-- Reporting
PallyPower_Assignments1 = "--- Paladin assignments ---"
PallyPower_Assignments2 = "--- end of assignments ---"

PallyPower_ClassID = { };
PallyPower_ClassID[0] = "Guerrero"
PallyPower_ClassID[1] = "Pícaro"
PallyPower_ClassID[2] = "Sacerdote"
PallyPower_ClassID[3] = "Druida"
PallyPower_ClassID[4] = "Paladín"
PallyPower_ClassID[5] = "Cazador"
PallyPower_ClassID[6] = "Mago"
PallyPower_ClassID[7] = "Brujo"
PallyPower_ClassID[8] = "Chamán"
PallyPower_ClassID[9] = "Mascota"

--XML
PALLYPOWER_CLEAR = "Limpiar";
PALLYPOWER_REFRESH = "Recargar";
PALLYPOWER_RESETPOSITION = "Reiniciar Posición";
PALLYPOWER_OPTIONS = "Opciones";
PALLYPOWER_OPTIONS_TITLE = "Opciones de Pally Power";
PALLYPOWER_OPTIONS_SCAN = "Frecuencia de escaneo (seconds):";
PALLYPOWER_OPTIONS_SCAN2 = "Poll Per Frame: ";
PALLYPOWER_OPTIONS_FEEDBACK_CHAT = "Mostrar feedback en el chat";
PALLYPOWER_OPTIONS_SMARTBUFFS = "Buffs menores";
PALLYPOWER_OPTIONS_REGULAR = "Activar solo bendiciones menores - NO BENDICIONES MAYORES";
PALLYPOWER_OPTIONS_LOCK = "Bloquear todos los marcos";
PALLYPOWER_OPTIONS_RF = "Mostrar Furia Justa en el panel de Buffs"
PALLYPOWER_OPTIONS_AURA = "Mostrar Aura en el panel de Buffs"
PALLYPOWER_OPTIONS_MINIMAP_BUTTON = "Mostrar botón en el Minimapa";
PALLYPOWER_OPTIONS_MINIMAP_BUTTONPOS = "Posición del botón en el Minimapa"
PALLYPOWER_OPTIONS_PLAY_SOUND = "Reproducir sonido al expirar la bendición";

PALLYPOWER_MESSAGE_BB_CENTERED = "PallyPowerBuffBar centrada en la pantalla."
PALLYPOWER_MESSAGE_BB_NOTFOUND = "No se encuentra el cuadro PallyPowerBuffBar."

PALLYPOWER_MESSAGE_NEWVERSION = "Nueva versión de PallyPowerTW disponible"

PALLYPOWER_FREEASSIGN = "Asignación libre"
PALLYPOWER_FREEASSIGN_DESC = "Permite a otros cambiar tus bendiciones sin ser líder de party/raid"

--PALLYPOWER_HUNTER_FEIGN_DEATH = "Fingir Muerte"