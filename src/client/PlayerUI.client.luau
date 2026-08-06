local plr = game.Players.LocalPlayer
local plrGui = plr:WaitForChild("PlayerGui")
local chr = plr.Character or plr.CharacterAdded:Wait()

local mouse = plr:GetMouse()
local uis = game:GetService("UserInputService")

local repStorage = game:GetService("ReplicatedStorage")
local remotes = repStorage:WaitForChild("Remotes")
local levelEvent = remotes:WaitForChild("Level")

local towerData = require(game.ReplicatedStorage.TowerData)

--Wave Gui
local wave = repStorage:WaitForChild("Wave")
wave.Changed:Connect(function(value)
	plrGui.WaveGui.Background.WaveText.Text = "Wave:" .. value
end)

--Cash Gui
local cash = chr:WaitForChild("Cash")
cash.Changed:Connect(function()
    plrGui.CashGui.Background.TextLabel.Text = "Cash:"..cash.Value
end)

--Upgrade Gui
local arcana = chr:WaitForChild("Arcana")

plrGui.UpgradeGui.Background.Upgrade.MouseButton1Click:Connect(function()
	local currentTower = plrGui.UpgradeGui.CurrentTower.Value
	local towerName = currentTower.TowerName.Value
	local currentLevel = currentTower.Level.Value
	local upgradeData = towerData[towerName.."UpgradeData"]
	local validated = levelEvent:InvokeServer(currentTower,currentLevel+1)
	if validated then
		plrGui.UpgradeGui.Background.TowerName.Text = towerName
		plrGui.UpgradeGui.Background.Info.Text = nextLevelData["Desc"]
		local priceData = upgradeData[towerName..currentLevel+2]
		plrGui.UpgradeGui.Background.Price.Text = priceData["Price"] or "Max"
	end
end)

--Tower Ui
local remotes = repStorage:WaitForChild("Remotes")
local towerRemote = remotes:WaitForChild("Tower")

local currentLevel = 0
local currentTower = "Neutral" --To-do: Set currentTower by TowerName value in the slot
local towerPrice = towerData[currentTower.."UpgradeData"][currentTower..currentLevel]["Price"]

local isSpawning = false
local currentDecoy = nil

local placeable = false

function towerSpawn()
	local tower = workspace.Towers.Tower1:Clone()
	tower.Parent = workspace
	tower:MoveTo(mouse.Hit.Position + Vector3.new(0,3,0))
	return tower
end

mouse.Move:Connect(function()
	if (isSpawning == false) or (currentDecoy == nil) then return end
	if not mouse.Target then return end

	currentDecoy:SetPrimaryPartCFrame(CFrame.new(mouse.Hit.Position) * CFrame.new(0,2.7,0))

	if (mouse.Target.Name == "Placeable") then
		placeable = true
		currentDecoy.Place.Color = Color3.fromRGB(0, 255, 157)
	else
		placeable = false
		currentDecoy.Place.Color = Color3.fromRGB(255, 90, 8)
	end
end)

mouse.Button1Down:Connect(function()
	if (isSpawning) == false or (currentDecoy == nil) or (placeable == false) then return end
	currentDecoy:Destroy()
	towerRemote:FireServer(mouse.Hit.Position,currentLevel,currentTower)

	currentDecoy = nil
	plrGui.TowerGui.Tower1Button.Visible = true
	isSpawning = false
end)

local spawnbutton = plrGui.TowerGui.Tower1Button.Activated:Connect(function()
	if (isSpawning == false) and cash.Value >= towerPrice then
		plrGui.TowerGui.Tower1Button.Visible = false
		isSpawning = true
		currentDecoy = towerSpawn()
		mouse.TargetFilter = currentDecoy
	end
end)

uis.InputBegan:Connect(function(Input,gameProcessed)
	if not gameProcessed then
		if Input.UserInputType == Enum.UserInputType.Keyboard then
		    if currentDecoy and currentDecoy.PrimaryPart then
    			if Input.KeyCode == Enum.KeyCode.R then
    				currentDecoy:SetPrimaryPartCFrame(currentDecoy.PrimaryPart.CFrame * CFrame.Angles(math.rad(0),math.rad(90),math.rad(0)))
    			end
			end
		end
	end
end)
