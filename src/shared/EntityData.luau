local module = {}

module.Data = { --Sets the data for every enemy by name.
    --Data includes expected speed, health, stealth state, color and animation.
	["Slow Dummy"] = {
		["Speed"] = 4,
		["Health"] = 15,
		["Stealth"] = false,
		["Color"] = Color3.fromRGB(3, 175, 255),
		["Animation"] = "rbxassetid://8044414849"
	},
	["Fast Dummy"] = {
		["Speed"] = 3,
		["Health"] = 5,
		["Stealth"] = false,
		["Color"] = Color3.fromRGB(7, 255, 143),
		["Animation"] = "rbxassetid://8044414849"
	},
	["Tough Dummy"] = {
		["Speed"] = 6,
		["Health"] = 50,
		["Stealth"] = false,
		["Color"] = Color3.fromRGB(0, 255, 64),
		["Animation"] = "rbxassetid://8044414849"
	},
	["Stealth Dummy"] = {
		["Speed"] = 4,
		["Health"] = 10,
		["Stealth"] = true,
		["Color"] = Color3.fromRGB(67, 65, 56),
		["Animation"] = "rbxassetid://8044414849"
	},
	["Rusher Dummy"] = {
		["Speed"] = 2.5,
		["Health"] = 12,
		["Stealth"] = false,
		["Color"] = Color3.fromRGB(125, 160, 255),
		["Animation"] = "rbxassetid://8044414849"
	},
	["Mega Dummy"] = {
		["Speed"] = 7,
		["Health"] = 100,
		["Stealth"] = false,
		["Color"] = Color3.fromRGB(129, 107, 255),
		["Animation"] = "rbxassetid://8044414849"
	},
	["Flashing Dummy"] = {
		["Speed"] = 2,
		["Health"] = 15,
		["Stealth"] = true,
		["Color"] = Color3.fromRGB(239, 255, 90),
		["Animation"] = "rbxassetid://8044414849"
	},
	["Ninja Dummy"] = {
		["Speed"] = 3,
		["Health"] = 20,
		["Stealth"] = true,
		["Color"] = Color3.fromRGB(255, 217, 218),
		["Animation"] = "rbxassetid://8044414849"
	},
	["Boss Dummy"] = {
		["Speed"] = 10,
		["Health"] = 500,
		["Stealth"] = false,
		["Color"] = Color3.fromRGB(65, 2, 255),
		["Animation"] = "rbxassetid://8044414849"
	},
	["Elite Dummy"] = {
		["Speed"] = 2,
		["Health"] = 70,
		["Stealth"] = false,
		["Color"] = Color3.fromRGB(255, 240, 20),
		["Animation"] = "rbxassetid://8044414849"
	},
	["Failed Dummy"] = {
		["Speed"] = 1.5,
		["Health"] = 35,
		["Stealth"] = false,
		["Color"] = Color3.fromRGB(151, 255, 107),
		["Animation"] = "rbxassetid://8044414849"
	},
	["Shadow Dummy"] = {
		["Speed"] = 2.5,
		["Health"] = 75,
		["Stealth"] = true,
		["Color"] = Color3.fromRGB(70, 71, 83),
		["Animation"] = "rbxassetid://8044414849"
	},
	["Light Dummy"] = {
		["Speed"] = 3,
		["Health"] = 125,
		["Stealth"] = false,
		["Color"] = Color3.fromRGB(255, 246, 222),
		["Animation"] = "rbxassetid://8044414849"
	},
	["Dark Dummy"] = {
		["Speed"] = 8,
		["Health"] = 450,
		["Stealth"] = true,
		["Color"] = Color3.fromRGB(8, 0, 36),
		["Animation"] = "rbxassetid://8044414849"
	},
	["Glitch Dummy"] = {
		["Speed"] = 1,
		["Health"] = 20,
		["Stealth"] = false,
		["Color"] = Color3.fromRGB(255, 2, 103),
		["Animation"] = "rbxassetid://8044414849"
	},
	["Juggernaut Dummy"] = {
		["Speed"] = 20,
		["Health"] = 3500,
		["Stealth"] = false,
		["Color"] = Color3.fromRGB(103, 19, 21),
		["Animation"] = "rbxassetid://8044414849"
	},
	["Beta Dummy"] = {
		["Speed"] = 7.5,
		["Health"] = 1000,
		["Stealth"] = false,
		["Color"] = Color3.fromRGB(1, 230, 255),
		["Animation"] = "rbxassetid://8044414849"
	},
	["Alpha Dummy"] = {
		["Speed"] = 3.5,
		["Health"] = 350,
		["Stealth"] = true,
		["Color"] = Color3.fromRGB(156, 255, 227),
		["Animation"] = "rbxassetid://8044414849"
	},
	["Z Dummy"] = {
		["Speed"] = 2,
		["Health"] = 250,
		["Stealth"] = false,
		["Color"] = Color3.fromRGB(66, 62, 115),
		["Animation"] = "rbxassetid://8044414849"
	},
	["X Dummy"] = {
		["Speed"] = 15,
		["Health"] = 7500,
		["Stealth"] = false,
		["Color"] = Color3.fromRGB(118, 19, 21),
		["Animation"] = "rbxassetid://8044414849"
	},
	["Y Dummy"] = {
		["Speed"] = 4,
		["Health"] = 2500,
		["Stealth"] = false,
		["Color"] = Color3.fromRGB(20, 255, 79),
		["Animation"] = "rbxassetid://8044414849"
	},
	["Zero Dummy"] = {
		["Speed"] = 17,
		["Health"] = 30000,
		["Stealth"] = false,
		["Color"] = Color3.fromRGB(33, 33, 98),
		["Animation"] = "rbxassetid://8044414849"
	},
}

return module
