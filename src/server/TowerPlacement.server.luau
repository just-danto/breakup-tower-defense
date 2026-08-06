local repStorage = game:GetService("ReplicatedStorage")
local remotes = repStorage:WaitForChild("Remotes")
local towerRemote = remotes:WaitForChild("Tower")

local towerData = require(game.ReplicatedStorage.TowerData)

towerRemote.OnServerEvent:Connect(function(plr,mouse,currentLevel,currentTower)
    local plrGui = plr:WaitForChild("PlayerGui")
    local chr = plr.Character or plr.CharacterAdded:Wait()

    local cash = chr:WaitForChild("Cash")
    local towerPrice = towerData[currentTower.."UpgradeData"][currentTower..currentLevel]["Price"]
    if towerPrice > cash.Value then return end
    cash.Value -= towerPrice

	local tower = workspace.Towers.Tower1:Clone()
	tower.Parent = workspace
	tower.Place.Transparency = 1
	tower.IsPlaced.Value = true
	tower.TowerOwner.Value = plr.Name
	tower.Range.Transparency = 1
	tower:SetPrimaryPartCFrame(CFrame.new(mouse) * CFrame.new(0,2.7,0))
	local track = Instance.new("Animation")
	track.AnimationId = "rbxassetid://8052303269"
	local anim = tower.Humanoid:LoadAnimation(track)
	anim:Play()
	tower.Attributes.Damage.Value = towerData[plrGui.TowerGui.TowerName.Value.."UpgradeData"][plrGui.TowerGui.TowerName.Value..tower.Level.Value]["Damage"]
	tower.Attributes.Range.Value = towerData[plrGui.TowerGui.TowerName.Value.."UpgradeData"][plrGui.TowerGui.TowerName.Value..tower.Level.Value]["Range"]
	tower.Attributes.AnimSpeed.Value = towerData[plrGui.TowerGui.TowerName.Value.."UpgradeData"][plrGui.TowerGui.TowerName.Value..tower.Level.Value]["AnimationSpeed"]
	tower.Attributes.AttackSpeed.Value = towerData[plrGui.TowerGui.TowerName.Value.."UpgradeData"][plrGui.TowerGui.TowerName.Value..tower.Level.Value]["AttackSpeed"]
end)
