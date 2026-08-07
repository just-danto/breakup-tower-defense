local repStorage = game:GetService("ReplicatedStorage") --Gets the ReplicatedStorage.

local remotes = repStorage:WaitForChild("Remotes") --Gets the Remotes folder that stores the remote events/functions.
local levelEvent = remotes:WaitForChild("Level") --Gets the Level remote function.

local towerData = require(repStorage.TowerData) --Gets the Tower Data.

game.workspace.ChildAdded:Connect(function(child) --Detects when something is added to the game worskpace.
    if child.Name == "Tower1" then --If the object added is a tower, do the following: (To-do: Detect if object is a tower by value inside and not by name.)
        local hitbox = child:WaitForChild("Hitbox") --Gets the hitbox inside of the tower.
        local clickDetector = hitbox:WaitForChild("ClickDetector") --Gets the ClickDetector of the Hitbox.

        local towerName = child.TowerName.Value --Gets the tower's name.
        local currentEnemy = nil --Holds the enemy currently being attacked.
        local enabled = false --Controls the attack cycle.

        --Gets the upgrade data related to the tower's name and CURRENT level (reads it live, so upgrades apply).
        local function getUpgradeData()
            local level = child.Level.Value
            return towerData[towerName.."UpgradeData"][towerName..level]
        end

        local track = Instance.new("Animation") --Creates the tower's attack animation.
        track.AnimationId = "rbxassetid://8145914004"
        local animation = child.Humanoid.Animator:LoadAnimation(track) --Loads the animation into the tower's Animator.

        --Applies the tower's damage every time the animation reaches one of its damage markers.
        for _, marker in ipairs({"Dmg1", "Dmg2", "Dmg3"}) do
            animation:GetMarkerReachedSignal(marker):Connect(function()
                if currentEnemy == nil then return end --If there is no target, return.
                local enemyHealth = currentEnemy:FindFirstChild("EnemyHealth") --Gets the enemy's health value (never index directly: may not exist).
                if not enemyHealth then return end --If the enemy has no health value, return.
                enemyHealth.Value -= getUpgradeData()["Damage"] --Deducts the tower's damage from the enemy's health.
            end)
        end

        --Runs the attack loop on its own thread so it doesn't block the click/upgrade connections below.
        task.spawn(function()
            while true do --Keeps the tower scanning for enemies.
                task.wait()
                if not child.Parent then return end --If the tower was removed from the workspace, stops the loop.
                if not child.IsPlaced.Value or enabled then continue end --If unplaced or already attacking, skips this cycle.
                enabled = true --Signals that the tower is attacking.

                --Searches for the first enemy inside the tower's current range.
                for _, unit in pairs(workspace.Enemies:GetChildren()) do
                    --Gets the distance between the enemy and the tower.
                    local distance = (unit.HumanoidRootPart.Position - child.HumanoidRootPart.Position).Magnitude
                    if distance <= getUpgradeData()["Range"] then --If the enemy is inside the range, attacks it.
                        currentEnemy = unit --Locks the enemy as the target.
                        --Rotates the tower to face the target.
                        child.PrimaryPart.CFrame = CFrame.new(child.PrimaryPart.Position, unit.HumanoidRootPart.Position)
                        animation:AdjustSpeed(getUpgradeData()["AnimationSpeed"]) --Applies the current animation speed.
                        animation:Play() --Plays the attack animation.
                        break --Only one target per attack cycle.
                    end
                end

                task.wait(getUpgradeData()["AttackSpeed"]) --Waits the attack cooldown.
                currentEnemy = nil --Releases the target.
                enabled = false --Signals that the tower can attack again.
            end
        end)
        clickDetector.MouseClick:Connect(function(plr) --Detects when a player clicks on the ClickDetector.
            local plrGui = plr:WaitForChild("PlayerGui") --Gets the PlayerGui of the player.
        	local upgradeGui = plrGui:WaitForChild("UpgradeGui") --Gets the UpgradeGui inside of the PlayerGui.
           	local enabled = upgradeGui:WaitForChild("EnabledValue") --Gets the EnabledValue inside of the UpgradeGui.
           	if plr.Name == child.TowerOwner.Value then --If the player's name equals to the TowerOwner string value, do the following:
          		if not enabled.Value then --If ui is not enabled, do the following:
         			child.Range.Transparency = 0.7 --Shows the tower's visible range object.
         			upgradeGui.Background.Visible = true --Makes the UpgradeUi visible.
         			upgradeGui.Background.TowerName.Text = child.TowerName.Value --Sets the TowerName's text in ui to the current selected tower's name.
                    --Sets Info and Price's text to the data related to the current tower's name and current upgrade level.
         			upgradeGui.Background.Info.Text = towerData[child.TowerName.Value.."UpgradeData"][child.TowerName.Value..child.Level.Value]["Desc"]
         			upgradeGui.Background.Price.Text = towerData[child.TowerName.Value.."UpgradeData"][child.TowerName.Value..child.Level.Value+1]["Price"]
         			upgradeGui.CurrentTower.Value = child --Sets CurrentTower value to the selected tower.
         			enabled.Value = true --Signals that the ui is enabled.
          		elseif enabled.Value then --If ui is already enabled, do the following:
         			child.Range.Transparency = 1 --Hides the tower's visible range object.
         			upgradeGui.Background.Visible = false --Makes the UpgradeUi invisible.
         			upgradeGui.CurrentTower.Value = nil --Clears the CurrentTower value.
         			enabled.Value = false --Signaals that the ui is disabled.
          		end
           	end
        end)
        --Sets a function for server invoke of the Level remote function, receiving the player and currentTower/currentLevel values.
        levelEvent.OnServerInvoke = function(plr,currentTower,currentLevel)
            --If received currentTower isn't equal to the current object or the player's name isn't equal to the tower's TowerOwner value, return.
            if currentTower ~= child or plr.Name ~= child.TowerOwner.Value then
                return false
            end
            local towerName = child.TowerName.Value --Sets towerName to the tower's TowerName value.
            --Sets upgradeData and levelData related to the towerName and currentLevel.
            local upgradeData = towerData[towerName.."UpgradeData"] --Gets the upgrade data for the tower.
            if not upgradeData then return false end --If the tower has no upgrade data, return.
            local levelData = upgradeData[towerName..currentLevel] --Gets the data for the requested level.
            if not levelData then return false end --If the level doesn't exist, return.
            local price = levelData["Price"] --Gets the price value from levelData.
            if type(price) ~= "number" then return false end --If the price isn't valid, return.
            local chr = plr.Character
            local cash = chr and chr:FindFirstChild("Cash") --Gets the cash from the player's character.
            if not cash or cash.Value < price then return false end --If the player has no cash or it's lower than the price, return.
            cash.Value -= price --Deducts the price from the cash.
            child.Level.Value = currentLevel --Sets the tower's Level value to currentLevel.
            --Sets all the tower's attributes to the new values related to the currentLevel.
            child.Attributes.Damage.Value = levelData["Damage"]
            child.Attributes.Range.Value = levelData["Range"]
            child.Attributes.AnimSpeed.Value = levelData["AnimationSpeed"]
            child.Attributes.AttackSpeed.Value = levelData["AttackSpeed"]
            return true
        end
    end
end)
