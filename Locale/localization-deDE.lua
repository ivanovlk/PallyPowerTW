--[[ Dies ist nur eine Vorlage für die deutsche Sprache. Bitte übersetzen ]]

if ( GetLocale() == "deDE" ) then

    BINDING_HEADER_PALLYPOWER_HEADER = "Pally Power"
    BINDING_NAME_TOGGLE = "Buff-Leiste umschalten"
    BINDING_NAME_REPORT = "Zuweisungen melden"
    BINDING_NAME_AUTOKEY1 = "Auto Normaler Segen Schlüssel"
    BINDING_NAME_AUTOKEY2 = "Auto Großer Segen Schlüssel"
    BINDING_NAME_SEALKEY = "Siegel zaubern"

    PallyPower_BlessingID = { };
    PallyPower_BlessingID[0] = "Weisheit";
    PallyPower_BlessingID[1] = "Macht";
    PallyPower_BlessingID[2] = "Rettung";
    PallyPower_BlessingID[3] = "Licht";
    PallyPower_BlessingID[4] = "Könige";
    PallyPower_BlessingID[5] = "Refugium";
    
    PallyPower_AuraID = { };
    PallyPower_AuraID[0] = "Andacht";
    PallyPower_AuraID[1] = "Vergeltung";
    PallyPower_AuraID[2] = "Konzentration";
    PallyPower_AuraID[3] = "Schattenwiderstand";
    PallyPower_AuraID[4] = "Frostwiderstand";
    PallyPower_AuraID[5] = "Feuerwiderstand";
    PallyPower_AuraID[6] = "Heiligkeit";
    
    PallyPower_SealID = { };
    PallyPower_SealID[0] = "Weisheit";
    PallyPower_SealID[1] = "der Kreuzfahrer";
    PallyPower_SealID[2] = "Licht";
    PallyPower_SealID[3] = "Gerechtigkeit";
    PallyPower_SealID[4] = "Befehl";
    PallyPower_SealID[5] = "Rechtschaffenheit";

    PallyPower_Greater = "Großer"
    if (RegularBlessings == false) 
      then
        PallyPower_BlessingSpellSearch = "Großer Segen der (.*)";
      else
        PallyPower_BlessingSpellSearch = "Segen der (.*)";
    end
    PallyPower_AuraSpellSearch = "(.*) Aura";
    PallyPower_SealSpellSearch = "Siegel von (.*)";
    PallyPower_SealSpellPrefix = "Siegel von ";
        
    PallyPower_Rank1 = "Rang 1"
    PallyPower_RankSearch = "Rang (.*)"
    PallyPower_Symbol = "Symbol der Könige"
    
    -- _,class = UnitClass("player") returns....
    PallyPower_Paladin = "PALADIN"
    
    -- Used... ClassID .. ": Blessing of "..BlessingID
    PallyPower_BuffFrameText = ": Segen der "
    PallyPower_Have = "Haben: "
    PallyPower_Need = "Brauchen: "
    PallyPower_NotHere = "Nicht hier: "
    PallyPower_Dead = "Tot: "
    
    PallyPower_Auras = " zusätzliche Auren:"
    PallyPower_Seals = " zusätzliche Siegel:"
    
    PallyPower_BuffBarTitle = "Pally Buffs (%d)"
    
    --- By Lines... Keep People the same, feel free to add yourself in the _Credits3 line if your localizing
    --- And feel free to add a friend or two to special thanks
    PallyPower_Credits1 = "Pally Power - von ivanovlk"
    PallyPower_Credits2 = "Version "..PallyPower_Version
    PallyPower_Credits3 = ""
    PallyPower_Credits4 = "Originales Update von Hjorim / Sneakyfoot / Rake / Xerron / Azgaardian / Aznamir"
    PallyPower_Credits5 = "Aktualisierte Version für Turtle WoW einschließlich Haustiere und andere Verbesserungen von ivanovlk"
    
    -- Buff name, Class Name
    PallyPower_CouldntFind = "Konnte kein Ziel für %s auf %s finden!"
    PallyPower_BlessingsDiffer = "Kann keinen Großen Segen auf Haustiere wirken, wenn die Zuweisungen für Krieger und Haustiere unterschiedlich sind. Verwenden Sie reguläre Segnungen für Haustiere."

    -- Buff name, Class name, Person Name
    PallyPower_Casting = "Wirke %s auf %s (%s)"
    -- Reporting
    PallyPower_Assignments1 = "--- Paladin-Zuweisungen ---"
    PallyPower_Assignments2 = "--- Ende der Zuweisungen ---"
    
    PallyPower_ClassID = { };
    PallyPower_ClassID[0] = "Krieger";
    PallyPower_ClassID[1] = "Schurke";
    PallyPower_ClassID[2] = "Priester";
    PallyPower_ClassID[3] = "Druide";
    PallyPower_ClassID[4] = "Paladin";
    PallyPower_ClassID[5] = "Jäger";
    PallyPower_ClassID[6] = "Magier";
    PallyPower_ClassID[7] = "Hexenmeister";
    PallyPower_ClassID[8] = "Schamane";
    PallyPower_ClassID[9] = "Haustier";
    
    --XML
    PALLYPOWER_CLEAR = "Löschen";
    PALLYPOWER_REFRESH = "Aktualisieren";
    PALLYPOWER_RESETPOSITION = "Position zurücksetzen";
    PALLYPOWER_PRESETS = "Voreinstellungen";
    PALLYPOWER_OPTIONS = "Optionen";
    PALLYPOWER_OPTIONS_TITLE = "Pally Power Optionen";
    PALLYPOWER_OPTIONS_SCAN = "Scan-Frequenz (Sekunden):";
    PALLYPOWER_OPTIONS_SCAN2 = "Abfragen pro Frame: ";
    PALLYPOWER_OPTIONS_FEEDBACK_CHAT = "Feedback im Chat anzeigen";
    PALLYPOWER_OPTIONS_SMARTBUFFS = "Intelligente Buffs";
    PALLYPOWER_OPTIONS_LOCK = "Alle Fenster sperren";
    PALLYPOWER_OPTIONS_RF = "Zeige Rechtschaffene Wut in der Buff-Leiste";
    PALLYPOWER_OPTIONS_AURA = "Zeige Aura in der Buff-Leiste";
    PALLYPOWER_OPTIONS_SEAL = "Zeige Siegel in der Buff-Leiste";
    PALLYPOWER_OPTIONS_MINIMAP_BUTTON = "Minikarten-Schaltfläche anzeigen";
    PALLYPOWER_OPTIONS_MINIMAP_BUTTONPOS = "Position der Minikarten-Schaltfläche";
    PALLYPOWER_OPTIONS_PLAY_SOUND = "Ton abspielen, wenn Segen ablaufen";
    PALLYPOWER_OPTIONS_HORIZONTAL_LAYOUT = "Horizontales BuffBar-Layout";
    PALLYPOWER_OPTIONS_HIDE_BLIZZ_AURA = "Blizzard-Aura-Rahmen ausblenden";
    PALLYPOWER_OPTIONS_USE_UNITXP_SP3_LOS = "Verwenden Sie UnitXP_SP3.dll für die LoS-Prüfung";
    PALLYPOWER_OPTIONS_USE_HDICONS = "HD-Symbole verwenden";
    PALLYPOWER_OPTIONS_TRANSPARENCY = "Globale Transparenz";

    PALLYPOWER_TEXT_DROPDOWN_SAVENEW = "Neues Set speichern";
    PALLYPOWER_TEXT_DROPDOWN_SAVECURRENT = "Aktuelles Set speichern";
    PALLYPOWER_TEXT_DROPDOWN_DELETE = "Set löschen";
    PALLYPOWER_TEXT_DROPDOWN_SETS = "Set anwenden";
    PALLYPOWER_TEXT_DROPDOWN_NONE = "Keine Sets";
    PALLYPOWER_TEXT_WARNING = "Warnung";
    PALLYPOWER_TEXT_OK = "Okay";
    PALLYPOWER_TEXT_CANCEL = "Stornieren";
    PALLYPOWER_TEXT_SAVENEW = "Neues Set speichern als";
    PALLYPOWER_TEXT_NEWNAME = "Geben Sie den Namen des neuen Sets ein:";
    PALLYPOWER_TEXT_ALREADYEXISTS = "Dieser Name wird bereits von einem anderen Set verwendet.";
    PALLYPOWER_TEXT_MUSTENTER = "|cffff0000Sie müssen einen Namen für das neue Set eingeben.";
    PALLYPOWER_TEXT_OVERWRITE = "|cffff0000Dieses Set existiert bereits, über dieses speichern?";
    PALLYPOWER_TEXT_SAVING = "Set speichern ";
    PALLYPOWER_TEXT_DELETE = "Set löschen ";

    PALLYPOWER_TEXT_WARNING_DELETE = "Sie sind dabei, das Set zu löschen '|cffffffff%s|r'.\nMöchten Sie dieses Set wirklich löschen?";
    PALLYPOWER_TEXT_WARNING_SAVE = "Sie sind dabei, Änderungen an den Einstellungen zu speichern. '|cffffffff%s|r'";


    PALLYPOWER_MESSAGE_BB_CENTERED = "PallyPowerBuffBar zentriert auf dem Bildschirm."
    PALLYPOWER_MESSAGE_BB_NOTFOUND = "Frame PallyPowerBuffBar nicht gefunden."
  
    PALLYPOWER_MESSAGE_NEWVERSION = "Neue Version von PallyPowerTW verfügbar"

    PALLYPOWER_FREEASSIGN = "Freie Zuweisung"
    PALLYPOWER_FREEASSIGN_DESC = "Erlaube anderen, deine Segnungen zu ändern, ohne Gruppenanführer / Schlachtzugsassistent zu sein."

    PALLYPOWER_MSG_PREFIX = "[PallyPower] "
    PALLYPOWER_MSG_NOTPALLYORRAID = "Nicht im Schlachtzug oder kein Paladin"
    PALLYPOWER_MSG_BARHIDDEN = "Leiste versteckt"
    PALLYPOWER_MSG_BARVISIBLE = "Leiste sichtbar"
    PALLYPOWER_MSG_NOTPALLY = "|cffffff00PallyPower: Du bist kein Paladin.|r"
    PALLYPOWER_MSG_NOASSIGNMENTS = "|cffffff00PallyPower: Keine Zuweisungen gefunden.|r"
    
    --PALLYPOWER_HUNTER_FEIGN_DEATH = "Tod vortäuschen"
  end