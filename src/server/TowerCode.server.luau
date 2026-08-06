local repStorage = game:GetService("ReplicatedStorage")
local remotes = repStorage:WaitForChild("Remotes")
local levelEvent = remotes:WaitForChild("Level")


local towerData = require(repStorage.TowerData)

game.workspace.ChildAdded:Connect(function(child)
    if child.Name == "Tower1" then
        local level = child:WaitForChild("Level")
        local currentUpgrade = level.Value
        local hitbox = child:WaitForChild("Hitbox")
        local clickDetector = hitbox:WaitForChild("ClickDetector")
        clickDetector.MouseClick:Connect(function(plr)
            local plrGui = plr:WaitForChild("PlayerGui")
        	local upgradeGui = plrGui:WaitForChild("UpgradeGui")
           	local enabled = upgradeGui:WaitForChild("EnabledValue")
           	if plr.Name == child.TowerOwner.Value then
          		if not enabled.Value then
         			child.Range.Transparency = 0.7
         			upgradeGui.Background.Visible = true
         			upgradeGui.Background.TowerName.Text = child.TowerName.Value
         			upgradeGui.Background.Info.Text = towerData[child.TowerName.Value.."UpgradeData"][child.TowerName.Value..currentUpgrade]["Desc"]
         			upgradeGui.Background.Price.Text = towerData[child.TowerName.Value.."UpgradeData"][child.TowerName.Value..currentUpgrade+1]["Price"]
         			upgradeGui.CurrentTower.Value = child
         			enabled.Value = true
          		elseif enabled.Value then
         			child.Range.Transparency = 1
         			upgradeGui.Background.Visible = false
         			upgradeGui.CurrentTower.Value = nil
         			enabled.Value = false
          		end
           	end
        end)
        levelEvent.OnServerInvoke = function(plr,currentTower,currentLevel)
            if currentTower ~= child or plr.Name ~= child.TowerOwner.Value then
                return false
            end
            local towerName = child.TowerName.Value
            local upgradeData = towerData[towerName.."UpgradeData"]
            local levelData = upgradeData[towerName..currentLevel]
            local price = levelData["Price"]
            local chr = plr.Character
            local cash = chr and chr:FindFirstChild("Cash")
            if cash.Value < price then return false end

            cash.Value -= price
            child.Level.Value = currentLevel
            child.Attributes.Damage.Value = levelData["Damage"]
            child.Attributes.Range.Value = levelData["Range"]
            child.Attributes.AnimSpeed.Value = levelData["AnimationSpeed"]
            child.Attributes.AttackSpeed.Value = levelData["AttackSpeed"]
            return true
        end
    end
end)
