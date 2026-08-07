local module = {}

module.GeneralData = { --Sets data used independently from maap.
	["TimeUntilSpawn"] = 1.5, --Sets time waited for enemy spawning.
	--Sets music for use on main game.
	["FirstMusic"] = "rbxassetid://1837667732", -- Tension
	["SecondMusic"] = "rbxassetid://7001023404", -- Epic
	["ThirdMusic"] = "rbxassetid://1847858557", -- End Game
	["FourthMusic"] = "rbxassetid://1008923215", -- Magical
	["FifthMusic"] = "rbxassetid://5868150622", -- Anger
	["SixthMusic"] = "rbxassetid://3143843068", -- Rebirth
	["SeventhMusic"] = "rbxassetid://1326552262", -- Mistakes
}

module.WaveData = { --Sets data for the enemy waves.
	["Baseplate"] = { --Sets enemy data in order for every wave and for this specific map.
		{"Slow Dummy","Slow Dummy","Slow Dummy"},
		{"Slow Dummy","Slow Dummy","Slow Dummy","Slow Dummy","Slow Dummy","Slow Dummy"},
		{"Slow Dummy","Slow Dummy","Slow Dummy","Fast Dummy","Fast Dummy","Fast Dummy"},
		{"Tough Dummy","Tough Dummy","Tough Dummy","Slow Dummy","Slow Dummy","Slow Dummy"},
		{"Tough Dummy","Tough Dummy","Tough Dummy","Tough Dummy","Tough Dummy","Fast Dummy", "Fast Dummy","Fast Dummy","Fast Dummy"},
		{"Tough Dummy","Tough Dummy","Tough Dummy","Stealth Dummy","Stealth Dummy","Stealth Dummy","Fast Dummy","Fast Dummy"},
		{"Tough Dummy","Tough Dummy","Tough Dummy","Tough Dummy","Stealth Dummy","Stealth Dummy","Rusher Dummy","Rusher Dummy","Rusher Dummy"},
		{"Stealth Dummy","Stealth Dummy","Stealth Dummy","Rusher Dummy","Rusher Dummy","Rusher Dummy","Rusher Dummy","Rusher Dummy"},
		{"Tough Dummy","Tough Dummy","Tough Dummy","Flashing Dummy","Flashing Dummy","Flashing Dummy","Rusher Dummy","Rusher Dummy","Stealth Dummy","Stealth Dummy"},
		{"Mega Dummy"},
		{"Flashing Dummy","Flashing Dummy","Flashing Dummy","Tough Dummy","Tough Dummy","Tough Dummy","Ninja Dummy","Ninja Dummy","Rusher Dummy"},
		{"Mega Dummy","Mega Dummy","Rusher Dummy","Rusher Dummy","Rusher Dummy","Stealth Dummy","Stealth Dummy","Stealth Dummy"},
		{"Mega Dummy","Mega Dummy","Mega Dummy","Mega Dummy","Flashing Dummy","Flashing Dummy","Flashing Dummy","Flashing Dummy","Ninja Dummy","Ninja Dummy","Ninja Dummy","Ninja Dummy"},
		{"Mega Dummy","Mega Dummy","Mega Dummy","Tough Dummy","Tough Dummy","Tough Dummy","Tough Dummy","Tough Dummy","Elite Dummy","Elite Dummy","Elite Dummy"},
		{"Flashing Dummy","Flashing Dummy","Rusher Dummy","Rusher Dummy","Rusher Dummy","Ninja Dummy","Ninja Dummy","Ninja Dummy"},
		{"Boss Dummy"},
		{"Elite Dummy","Elite Dummy","Elite Dummy","Elite Dummy","Ninja Dummy","Ninja Dummy","Ninja Dummy","Tough Dummy","Tough Dummy","Flashing Dummy","Flashing Dummy","Flashing Dummy"},
		{"Boss Dummy","Boss Dummy","Elite Dummy","Elite Dummy","Elite Dummy","Flashing Dummy","Flashing Dummy","Flashing Dummy"},
		{"Boss Dummy","Boss Dummy","Boss Dummy","Mega Dummy","Mega Dummy","Failed Dummy","Failed Dummy","Failed Dummy"},
		{"Boss Dummy","Boss Dummy","Boss Dummy","Boss Dummy","Boss Dummy","Boss Dummy","Failed Dummy","Failed Dummy","Failed Dummy","Failed Dummy","Failed Dummy","Failed Dummy","Shadow Dummy","Shadow Dummy","Shadow Dummy","Shadow Dummy"},
		{"Boss Dummy","Boss Dummy","Boss Dummy","Mega Dummy","Mega Dummy","Failed Dummy","Failed Dummy","Failed Dummy","Light Dummy","Light Dummy","Light Dummy"},
		{"Light Dummy","Light Dummy","Light Dummy","Light Dummy","Light Dummy","Light Dummy","Dark Dummy","Dark Dummy","Dark Dummy","Dark Dummy","Dark Dummy","Dark Dummy"},
		{"Glitch Dummy","Glitch Dummy","Glitch Dummy","Light Dummy","Light Dummy","Dark Dummy","Dark Dummy"},
		{"Glitch Dummy","Glitch Dummy","Glitch Dummy","Light Dummy","Light Dummy","Light Dummy","Dark Dummy","Dark Dummy","Dark Dummy","Shadow Dummy","Shadow Dummy","Shadow Dummy"},
		{"Beta Dummy","Boss Dummy","Boss Dummy","Boss Dummy","Mega Dummy","Mega Dummy","Glitch Dummy","Glitch Dummy","Glitch Dummy"},
		{"Beta Dummy","Beta Dummy","Boss Dummy","Boss Dummy","Boss Dummy","Glitch Dummy","Glitch Dummy","Glitch Dummy","Failed Dummy","Failed Dummy","Failed Dummy","Dark Dummy","Dark Dummy","Light Dummy","Light Dummy"},
		{"Alpha Dummy","Glitch Dummy","Glitch Dummy","Elite Dummy","Elite Dummy","Elite Dummy","Light Dummy","Dark Dummy"},
		{"Alpha Dummy","Beta Dummy","Glitch Dummy","Glitch Dummy","Glitch Dummy","Dark Dummy","Dark Dummy","Light Dummy","Light Dummy"},
		{"Alpha Dummy","Alpha Dummy","Beta Dummy","Beta Dummy","Juggernaut Dummy"},
		{"Z Dummy"},
		{"X Dummy"},
		{"Y Dummy"},
		{"Z Dummy","X Dummy","Y Dummy"},
		{"Z Dummy","Z Dummy","Z Dummy"},
		{"X Dummy","X Dummy","X Dummy"},
		{"Y Dummy","Y Dummy","Y Dummy"},
		{"Beta Dummy","Beta Dummy","Alpha Dummy","Alpha Dummy","Glitch Dummy","Glitch Dummy","Failed Dummy","Failed Dummy","Z Dummy"},
		{"Dark Dummy","Dark Dummy","Light Dummy","Light Dummy","Alpha Dummy","Alpha Dummy","Beta Dummy","Beta Dummy","Glitch Dummy","Glitch Dummy","Failed Dummy","Failed Dummy","X Dummy"},
		{"Juggernaut Dummy","Alpha Dummy","Beta Dummy","Dark Dummy","Dark Dummy","Light Dummy","Light Dummy","Alpha Dummy","Alpha Dummy","Beta Dummy","Beta Dummy","Glitch Dummy","Glitch Dummy","Failed Dummy","Failed Dummy","Y Dummy"},
		{"Juggernaut Dummy","Juggernaut Dummy","Z Dummy","X Dummy","Y Dummy","Alpha Dummy","Beta Dummy","Light Dummy","Dark Dummy",{"Zero Dummy",15}},
	}
}

module.CashData = { --Sets data for cash values.
	["Baseplate"] = { --Sets the cash gain value for every wave start on this map.
		{0},
		{220},
		{250},
		{300},
		{310},
		{320},
		{340},
		{370},
		{390},
		{400},
		{420},
		{440},
		{460},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
		{500},
	}
}

return module
