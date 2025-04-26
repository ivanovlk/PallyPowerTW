--[[ Dies ist nur eine Vorlage für die deutsche Sprache. Bitte übersetzen ]]

if ( GetLocale() == "deDE" ) then

    BINDING_HEADER_PALLYPOWER_HEADER = "Pally Power"
    BINDING_NAME_TOGGLE = "Buff-Leiste umschalten"
    BINDING_NAME_REPORT = "Zuweisungen melden"
    BINDING_NAME_AUTOKEY1 = "Auto Normaler Segen Schlüssel"
    BINDING_NAME_AUTOKEY2 = "Auto Großer Segen Schlüssel"
    
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
    
    PallyPower_Greater = "Großer"
    if (RegularBlessings == false) 
      then
        PallyPower_BlessingSpellSearch = "Großer Segen der (.*)";
      else
        PallyPower_BlessingSpellSearch = "Segen der (.*)";
    end
    PallyPower_AuraSpellSearch = "(.*) Aura";
    
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
    PALLYPOWER_OPTIONS = "Optionen";
    PALLYPOWER_OPTIONS_TITLE = "Pally Power Optionen";
    PALLYPOWER_OPTIONS_SCAN = "Scan-Frequenz (Sekunden):";
    PALLYPOWER_OPTIONS_SCAN2 = "Abfragen pro Frame: ";
    PALLYPOWER_OPTIONS_FEEDBACK_CHAT = "Feedback im Chat anzeigen";
    PALLYPOWER_OPTIONS_SMARTBUFFS = "Intelligente Buffs";
    PALLYPOWER_OPTIONS_REGULAR = "Nur normale Segen aktivieren - KEINE GROSSEN SEGEN";
    PALLYPOWER_OPTIONS_LOCK = "Alle Fenster sperren";
    PALLYPOWER_OPTIONS_RF = "Zeige Rechtschaffene Wut in der Buff-Leiste";
    PALLYPOWER_OPTIONS_AURA = "Zeige Aura in der Buff-Leiste";
    PALLYPOWER_OPTIONS_MINIMAP_BUTTON = "Minikarten-Schaltfläche anzeigen";
    PALLYPOWER_OPTIONS_MINIMAP_BUTTONPOS = "Position der Minikarten-Schaltfläche"
    PALLYPOWER_OPTIONS_PLAY_SOUND = "Ton abspielen, wenn Segen ablaufen";
    
    PALLYPOWER_MESSAGE_BB_CENTERED = "PallyPowerBuffBar zentriert auf dem Bildschirm."
    PALLYPOWER_MESSAGE_BB_NOTFOUND = "Frame PallyPowerBuffBar nicht gefunden."
  
    PALLYPOWER_MESSAGE_NEWVERSION = "Neue Version von PallyPowerTW verfügbar"

    PALLYPOWER_FREEASSIGN = "Freie Zuweisung"
    PALLYPOWER_FREEASSIGN_DESC = "Erlaube anderen, deine Segnungen zu ändern, ohne Gruppenanführer / Schlachtzugsassistent zu sein."

    --PALLYPOWER_HUNTER_FEIGN_DEATH = "Tod vortäuschen"
  end