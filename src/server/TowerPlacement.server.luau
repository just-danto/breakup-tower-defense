local repStorage = game:GetService("ReplicatedStorage") --Gets the ReplicatedStorage.

local remotes = repStorage:WaitForChild("Remotes") --Gets the Remotes folder that stores the remote events/functions.
local towerRemote = remotes:WaitForChild("Tower") --Gets the Tower remote event.

local towerData = require(repStorage.TowerData) --Gets the Tower Data.

--Detects when a server event is fired on the towerRemote, receiving the player, mouse, and currentLevel/currentTower values.
towerRemote.OnServerEvent:Connect(function(plr,mouse,currentLevel,currentTower)
    local plrGui = plr:WaitForChild("PlayerGui") --Gets the PlayerGui from the player.
    local chr = plr.Character or plr.CharacterAdded:Wait() --Gets and waits for the player's characterr.

    local cash = chr:WaitForChild("Cash") --Gets the cash from the player's character.
    --Gets the tower's price related to the currentTower and currentLevel.
    local towerPrice = towerData[currentTower.."UpgradeData"][currentTower..currentLevel]["Price"]
    if towerPrice > cash.Value then return end --If the tower's price is higher than the available cash, return.
    cash.Value -= towerPrice --Deducts the tower's price from available cash.

	local tower = workspace.Towers.Tower1:Clone() --Clones the Tower1 model from the Towers folder.
	--Parents it to the game workspace and the Place and Range parts invisible.
	tower.Parent = workspace
	tower.Place.Transparency = 1
	tower.Range.Transparency = 1
	tower.IsPlaced.Value = true --Sets the tower's IsPlaced value to true.
	tower.TowerOwner.Value = plr.Name --Sets the tower's TowerOwner value to the player's name.
	tower:SetPrimaryPartCFrame(CFrame.new(mouse) * CFrame.new(0,2.7,0)) --Places the tower at the mouse's CFrame with offset.
	--Creats, sets the ID, loads and plays the tower's animation.
	local track = Instance.new("Animation")
	track.AnimationId = "rbxassetid://8052303269"
	local anim = tower.Humanoid:LoadAnimation(track)
	anim:Play()
	--Sets the tower's attributes values to the data related to the tower's name and level.
	tower.Attributes.Damage.Value = towerData[plrGui.TowerGui.TowerName.Value.."UpgradeData"][plrGui.TowerGui.TowerName.Value..tower.Level.Value]["Damage"]
	tower.Attributes.Range.Value = towerData[plrGui.TowerGui.TowerName.Value.."UpgradeData"][plrGui.TowerGui.TowerName.Value..tower.Level.Value]["Range"]
	tower.Attributes.AnimSpeed.Value = towerData[plrGui.TowerGui.TowerName.Value.."UpgradeData"][plrGui.TowerGui.TowerName.Value..tower.Level.Value]["AnimationSpeed"]
	tower.Attributes.AttackSpeed.Value = towerData[plrGui.TowerGui.TowerName.Value.."UpgradeData"][plrGui.TowerGui.TowerName.Value..tower.Level.Value]["AttackSpeed"]
end)
