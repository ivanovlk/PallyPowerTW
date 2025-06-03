PALLYPOWER_SMALLBLESSING = 0
PALLYPOWER_GREATERBLESSING = 1

-- Mana cost table: [blessing][regular/greater] = { [level] = manaCost }
PallyPower_ManaCostTable = {
    [0] = { -- Wisdom
        [0] = { [14] = 30, [24] = 45, [34] = 65, [44] = 90, [54] = 115, [60] = 125 },
        [1] = { [54] = 230, [60] = 250 },
    },
    [1] = { -- Might
        [0] = { [4] = 20, [12] = 30, [22] = 45, [32] = 60, [42] = 85, [52] = 110, [60] = 130 },
        [1] = { [52] = 220, [60] = 260 },
    },
    [2] = { -- Salvation
        [0] = { [26] = 120 },
        [1] = { [60] = 241 },
    },
    [3] = { -- Light
        [0] = { [40] = 85, [50] = 110, [60] = 135 },
        [1] = { [60] = 260 },
    },
    [4] = { -- Kings
        [0] = { [20] = 120 },
        [1] = { [60] = 226 },
    },
    [5] = { -- Sanctuary
        [0] = { [20] = 60, [40] = 85, [50] = 110, [60] = 135 },
        [1] = { [60] = 241 },
    },
}

-- Function to get mana cost by blessing and type
function PallyPower_HasEnoughMana(blessing, type)
    local level = UnitLevel("player")
    local currentMana = UnitMana("player")
    local types = PallyPower_ManaCostTable[blessing]
    if not types or not types[type] then return true end
    local costTable = types[type]
    local manaCost = 0
    for lvl, cost in pairs(costTable) do
        if level >= lvl and cost > manaCost then
            manaCost = cost
        end
    end
    if currentMana and manaCost > currentMana then
        return false -- Not enough mana
    else 
        return true -- Enough mana or no currentMana provided
    end
end
