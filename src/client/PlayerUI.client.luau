local repStorage = game:GetService("ReplicatedStorage") --Gets the ReplicatedStorage.
local uis = game:GetService("UserInputService") --Gets the UserInputService.

local remotes = repStorage:WaitForChild("Remotes") --Gets the Remotes folder that stores the remote events/functions.
local levelRemote = remotes:WaitForChild("Level") --Gets the Level remote function.
local deathRemote = remotes:WaitForChild("Death") --Gets the Death remote event.
local towerRemote = remotes:WaitForChild("Tower") --Gets the Tower remote event.

local plr = game.Players.LocalPlayer --Gets the current player.
local plrGui = plr:WaitForChild("PlayerGui") --Gets the PlayerGui of the player.
local chr = plr.Character or plr.CharacterAdded:Wait() --Gets and waits for the character of the player.
local mouse = plr:GetMouse() --Gets the mouse of the player.

local towerData = require(repStorage.TowerData) --Gets the Tower Data.

--Death Gui
deathRemote.OnClientEvent:Connect(function() --Detects when a client event is fired on the deathRemote.
    plrGui.EndGui.Enabled = true --Enables the EndGui for the player.
end)

--Wave Gui
local wave = repStorage:WaitForChild("Wave") --Gets the global Wave from repStorage.
wave.Changed:Connect(function(value) --Detects when the wave value has changed.
	plrGui.WaveGui.Background.WaveText.Text = "Wave:" .. value --Updates the text with the current wave value.
end)

--Cash Gui
local cash = chr:WaitForChild("Cash") --Gets the cash from the character.
cash.Changed:Connect(function() --Detects when the cash value has changed.
    plrGui.CashGui.Background.TextLabel.Text = "Cash:"..cash.Value --Updates the text with the current cash value.
end)

--Upgrade Gui
local arcana = chr:WaitForChild("Arcana") --Gets the arcana from the character.

plrGui.UpgradeGui.Background.Upgrade.MouseButton1Click:Connect(function() --Detects when the upgrade button is pressed.
	local currentTower = plrGui.UpgradeGui.CurrentTower.Value --Sets currentTower to UpgradeGui's CurrentTower value.
	local towerName = currentTower.TowerName.Value --Sets towerName to the currentTower's TowerName value.
	local currentLevel = currentTower.Level.Value --Sets currentLevel to the currentTower's Level value.
	local upgradeData = towerData[towerName.."UpgradeData"] --Gets upgradeData related to the towerName.
	--Invokes the server from the levelRemote with the currentTower and next currentLevel for value validation.
	local validated = levelRemote:InvokeServer(currentTower,currentLevel+1)
	if validated then --If values are validated by the server, do the following:
		plrGui.UpgradeGui.Background.TowerName.Text = towerName --Sets the TowerName's text to the towerName.
		--Sets the Info text to the data related to the next currentLevel.
		plrGui.UpgradeGui.Background.Info.Text = upgradeData[towerName..currentLevel+1]["Desc"]
		--Sets the Price text to the data related to the next subsequent currentLevel.
		plrGui.UpgradeGui.Background.Price.Text = upgradeData[towerName..currentLevel+2]["Price"] or "Max"
	end
end)

--Tower Ui
local currentLevel = 0 --Sets currentLevel value as zero by default.
local currentTower = "Neutral" --Sets currentTower name as "Neutral" by default.  (To-do: Set currentTower by TowerName value in the slot)
--Gets the towerPrice value related to the currentTower and currentLevel.
local towerPrice = towerData[currentTower.."UpgradeData"][currentTower..currentLevel]["Price"]

local isSpawning = false --Sets the isSpawning variable as false by default.
local currentDecoy = nil --Sets the currentDecoy as none.

local placeable = false --Sets the placeable variable as false by default.

function towerSpawn()
    if not mouse.Target then return end --If there is no target, return
	local tower = workspace.Towers.Tower1:Clone() --Clones the Tower1 model from the Towers folderr.
	tower.Parent = workspace --Parents the tower to the workspace.
    --Moves the tower's PrimaryPart CFrame to the mouse's current position.
	tower:MoveTo(mouse.Hit.Position + Vector3.new(0,3,0))
	return tower --Returns the new tower model.
end

mouse.Move:Connect(function() --Everytime the mouse moves, detect.
    --If the player isn't currently spawning or there is no decoy, return.
	if (isSpawning == false) or (currentDecoy == nil) then return end
	if not mouse.Target then return end --If there is no target, return.

	--Sets currentDecoy's PrimaryPart CFrame at the mouse's current position with offset.
	currentDecoy:SetPrimaryPartCFrame(CFrame.new(mouse.Hit.Position) * CFrame.new(0,2.7,0))

	if (mouse.Target.Name == "Placeable") then --If the target at the mouse's position is placeable, do the following:
	    --Sets placeable to true and makes the Place object green.
		placeable = true
		currentDecoy.Place.Color = Color3.fromRGB(0, 255, 157)
	else --If the target at the mouse's position isn't placeable, do this instead:
	    --Sets placeable to false and makes the Place object red.
		placeable = false
		currentDecoy.Place.Color = Color3.fromRGB(255, 90, 8)
	end
end)

mouse.Button1Down:Connect(function()
    --If is not spawning, there is no decoy, or the position isn't placeable, returns.
	if (isSpawning) == false or (currentDecoy == nil) or (placeable == false) then return end
	currentDecoy:Destroy() --Destroys the currentDecoy.
	--Fires to the TowerPlacement on the towerRemote with the mouse position, currentLevel and currentTower.
	towerRemote:FireServer(mouse.Hit.Position,currentLevel,currentTower)

	currentDecoy = nil --Completely clears the currentDecoy.
	plrGui.TowerGui.Tower1Button.Visible = true --Makes the Tower1 spawn button visible.
	isSpawning = false --Signals that isSpawning is false.
end)

local spawnbutton = plrGui.TowerGui.Tower1Button.Activated:Connect(function() --Detects when the Tower1 spawn button is pressed.
	if (isSpawning == false) and cash.Value >= towerPrice then --If is not spawning and has enough cash, do the following:
		plrGui.TowerGui.Tower1Button.Visible = false --Makes the Tower1 spawn button not visible.
		isSpawning = true --Signals that isSpawning is true.
		currentDecoy = towerSpawn() --Sets currentDecoy as the new Tower spawned.
		mouse.TargetFilter = currentDecoy --Sets the TargetFilter to the currentdecoy.
	end
end)

uis.InputBegan:Connect(function(Input,gameProcessed) --Detects when the player initiates an input.
	if not gameProcessed then --If input is not on a Roblox process, proceed.
		if Input.UserInputType == Enum.UserInputType.Keyboard then --If input is from a keyboard, do the following:
		    if currentDecoy and currentDecoy.PrimaryPart then --If there is a currentDecoy with a PrimaryPart, do the following:
    			if Input.KeyCode == Enum.KeyCode.R then --If the key pressed was R, proceed.
                    --Rotates currentDecoy's PrimaryPartCFrame by 90 degrees.
    				currentDecoy:SetPrimaryPartCFrame(currentDecoy.PrimaryPart.CFrame * CFrame.Angles(math.rad(0),math.rad(90),math.rad(0)))
    			end
			end
		end
	end
end)
