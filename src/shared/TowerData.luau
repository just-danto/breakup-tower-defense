local module = {}

module.NeutralUpgradeData = { --Sets the upgrade data for the tower "Neutral" by upgrade level.
    --Data includes expected damage, range, attack speed, animation speed, price, ui description and hidden enemy detection.
	["Neutral0"] = {
		["Damage"] = 5,
		["Range"] = 15,
		["AttackSpeed"] = 1.5,
		["AnimationSpeed"] = 1.5,
		["Price"] = 200,
		["Desc"] = "Faster attack speed, and more damage.",
		["HiddenDetection"] = false,
	},
	["Neutral1"] = {
		["Damage"] = 10,
		["Range"] = 17,
		["AttackSpeed"] = 1.4,
		["AnimationSpeed"] = 1.6,
		["Price"] = 600,
		["Desc"] = "Attacks much faster, has more range and damage.",
		["HiddenDetection"] = false,
	},
	["Neutral2"] = {
		["Damage"] = 15,
		["Range"] = 20,
		["AttackSpeed"] = 1.3,
		["AnimationSpeed"] = 1.7,
		["Price"] = 1200,
		["Desc"] = "Gets able to attack hidden enemies, more damage and attack speed.",
		["HiddenDetection"] = true,
	},
	["Neutral3"] = {
		["Damage"] = 20,
		["Range"] = 20,
		["AttackSpeed"] = 1.2,
		["AnimationSpeed"] = 1.8,
		["Price"] = 2500,
		["Desc"] = "Extreme punching.",
		["HiddenDetection"] = true,
	},
	["Neutral4"] = {
		["Damage"] = 35,
		["Range"] = 20,
		["AttackSpeed"] = 0.8,
		["AnimationSpeed"] = 2.2,
		["Price"] = 4000,
		["Desc"] = "Maxed!",
		["HiddenDetection"] = true,
	}
}

return module
