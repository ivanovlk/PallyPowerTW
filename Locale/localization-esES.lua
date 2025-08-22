--[[ Spanish translation ]]

if ( GetLocale() == "esES" ) then

    BINDING_HEADER_PALLYPOWER_HEADER = "Pally Power"
    BINDING_NAME_TOGGLE = "Mostrar/Ocultar Barra de Buffs"
    BINDING_NAME_REPORT = "Reportar Asignaciones"
    BINDING_NAME_AUTOKEY1 = "Tecla de Bendición Normal Automática"
    BINDING_NAME_AUTOKEY2 = "Tecla de Bendición Mayor Automática"
    BINDING_NAME_SEALKEY = "Tecla de Lanzar Sello"
    
    PallyPower_BlessingID = { };
    PallyPower_BlessingID[0] = "Sabiduría";
    PallyPower_BlessingID[1] = "Poder";
    PallyPower_BlessingID[2] = "Salvación";
    PallyPower_BlessingID[3] = "Luz";
    PallyPower_BlessingID[4] = "los Reyes";
    PallyPower_BlessingID[5] = "Santuario";

    PallyPower_AuraID = { };
    PallyPower_AuraID[0] = "Devoción";
    PallyPower_AuraID[1] = "Retribución";
    PallyPower_AuraID[2] = "Concentración";
    PallyPower_AuraID[3] = "Resistencia a Sombra";
    PallyPower_AuraID[4] = "Resistencia a la Escarcha";
    PallyPower_AuraID[5] = "Resistencia al Fuego";
    PallyPower_AuraID[6] = "Santidad";

    PallyPower_SealID = { };
    PallyPower_SealID[0] = "Sabiduría";
    PallyPower_SealID[1] = "Poder";
    PallyPower_SealID[2] = "Salvación";
    PallyPower_SealID[3] = "los Reyes";
    PallyPower_SealID[4] = "Fuego";
    PallyPower_SealID[5] = "Furia";

    PallyPower_Greater = "Mayor"
    if (RegularBlessings == false) 
      then
        PallyPower_BlessingSpellSearch = "Bendición Mayor de (.*)";
      else
        PallyPower_BlessingSpellSearch = "Bendición de (.*)";
    end
    PallyPower_AuraSpellSearch = "Aura de (.*)";
    PallyPower_SealSpellSearch = "Sello de (.*)";
    PallyPower_SealSpellPrefix = "Sello de ";

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
    PallyPower_Seals = " sellos adicionales:"

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
    PallyPower_BlessingsDiffer = "No se puede lanzar Bendición Mayor en mascotas cuando las asignaciones de Guerrero y Mascota difieren. Usa bendiciones regulares para mascotas."

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
    PALLYPOWER_PRESETS = "Preestablecidos";
    PALLYPOWER_OPTIONS = "Opciones";
    PALLYPOWER_OPTIONS_TITLE = "Opciones de Pally Power";
    PALLYPOWER_OPTIONS_SCAN = "Frecuencia de escaneo (seconds):";
    PALLYPOWER_OPTIONS_SCAN2 = "Poll Per Frame: ";
    PALLYPOWER_OPTIONS_FEEDBACK_CHAT = "Mostrar feedback en el chat";
    PALLYPOWER_OPTIONS_SMARTBUFFS = "Buffs menores";
    PALLYPOWER_OPTIONS_LOCK = "Bloquear todos los marcos";
    PALLYPOWER_OPTIONS_RF = "Mostrar Furia Justa en el panel de Buffs"
    PALLYPOWER_OPTIONS_AURA = "Mostrar Aura en el panel de Buffs"
    PALLYPOWER_OPTIONS_SEAL = "Mostrar Sello en el panel de Buffs"
    PALLYPOWER_OPTIONS_MINIMAP_BUTTON = "Mostrar botón en el Minimapa";
    PALLYPOWER_OPTIONS_MINIMAP_BUTTONPOS = "Posición del botón en el Minimapa";
    PALLYPOWER_OPTIONS_PLAY_SOUND = "Reproducir sonido al expirar la bendición";
    PALLYPOWER_OPTIONS_HORIZONTAL_LAYOUT = "Diseño horizontal de BuffBar";
    PALLYPOWER_OPTIONS_HIDE_BLIZZ_AURA = "Ocultar marco de aura de Blizzard";
    PALLYPOWER_OPTIONS_USE_UNITXP_SP3_LOS = "Utiliza UnitXP_SP3.dll para la comprobación de LoS";
    PALLYPOWER_OPTIONS_USE_HDICONS = "Usar iconos HD";
    PALLYPOWER_OPTIONS_TRANSPARENCY = "Transparencia global";

    PALLYPOWER_TEXT_DROPDOWN_SAVENEW = "Guardar nuevo conjunto";
    PALLYPOWER_TEXT_DROPDOWN_SAVECURRENT = "Guardar conjunto actual";
    PALLYPOWER_TEXT_DROPDOWN_DELETE = "Eliminar conjunto";
    PALLYPOWER_TEXT_DROPDOWN_SETS = "Aplicar conjunto";
    PALLYPOWER_TEXT_DROPDOWN_NONE = "No hay conjuntos";
    PALLYPOWER_TEXT_WARNING = "Advertencia";
    PALLYPOWER_TEXT_OK = "Está bien";
    PALLYPOWER_TEXT_CANCEL = "Cancelar";
    PALLYPOWER_TEXT_SAVENEW = "Guardar nuevo conjunto como";
    PALLYPOWER_TEXT_NEWNAME = "Escribe el nombre del nuevo conjunto:";
    PALLYPOWER_TEXT_ALREADYEXISTS = "Este nombre ya está siendo utilizado por otro conjunto.";
    PALLYPOWER_TEXT_MUSTENTER = "|cffff0000Debes ingresar un nombre para el nuevo conjunto.";
    PALLYPOWER_TEXT_OVERWRITE = "|cffff0000Este conjunto ya existe, ¿sobrescribirlo?";
    PALLYPOWER_TEXT_SAVING = "Conjunto de ahorro ";
    PALLYPOWER_TEXT_DELETE = "Conjunto eliminado ";

    PALLYPOWER_TEXT_WARNING_DELETE = "Estás a punto de eliminar el conjunto '|cffffffff%s|r'.\n¿Realmente quieres eliminar este conjunto?";
    PALLYPOWER_TEXT_WARNING_SAVE = "Estás a punto de guardar los cambios en la configuración '|cffffffff%s|r'";

    PALLYPOWER_MESSAGE_BB_CENTERED = "PallyPowerBuffBar centrada en la pantalla."
    PALLYPOWER_MESSAGE_BB_NOTFOUND = "No se encuentra el cuadro PallyPowerBuffBar."

    PALLYPOWER_MESSAGE_NEWVERSION = "Nueva versión de PallyPowerTW disponible"

    PALLYPOWER_FREEASSIGN = "Asignación libre"
    PALLYPOWER_FREEASSIGN_DESC = "Permite a otros cambiar tus bendiciones sin ser líder de party/raid"

    PALLYPOWER_MSG_PREFIX = "[PallyPower] "
    PALLYPOWER_MSG_NOTPALLYORRAID = "No estás en banda o no eres un paladín"
    PALLYPOWER_MSG_BARHIDDEN = "Barra oculta"
    PALLYPOWER_MSG_BARVISIBLE = "Barra visible"
    PALLYPOWER_MSG_NOTPALLY = "|cffffff00PallyPower: No eres un paladín.|r"
    PALLYPOWER_MSG_NOASSIGNMENTS = "|cffffff00PallyPower: No se encontraron asignaciones.|r"

    --PALLYPOWER_HUNTER_FEIGN_DEATH = "Fingir Muerte"
end
