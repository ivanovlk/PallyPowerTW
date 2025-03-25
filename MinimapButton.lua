function PallyPower_MinimapButton_OnClick(mouseBtn)
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