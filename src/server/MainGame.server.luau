local entityData = require(game.ReplicatedStorage.EntityData)

local wave = Instance.new("IntValue")
wave.Name = "Wave"
wave.Parent = game.ReplicatedStorage
local remotes = Instance.new("Folder")
remotes.Name = "Remotes"
remotes.Parent = game.ReplicatedStorage
for _, remoteName in ipairs({"Death", "Cash", "Music", "Tower"}) do
	local remote = Instance.new("RemoteEvent")
	remote.Name = remoteName
	remote.Parent = remotes
end
local levelRemote = Instance.new("RemoteFunction")
levelRemote.Name = "Level"
levelRemote.Parent = remotes

game.Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(chr)
        local cash = Instance.new("IntValue")
        cash.Name = "Cash"
        cash.Value = 200
        cash.Parent = chr
        local arcana = Instance.new("IntValue")
        arcana.Name = "Arcana"
        arcana.Value = 0
        arcana.Parent = chr
    end)
end)

local TweenService = game:GetService("TweenService")
local paths = {workspace.Path}

local speed = .05
local rotationSpeed = .2

function SpawnEnemy(path,entityname)
	local entity = game.Workspace.Dummy:Clone()
	entity.Name = entityname
	entity.EnemyHealth.Value = entityData.Data[entity.Name]["Health"]
	entity.Torso.Color = entityData.Data[entity.Name]["Color"]
	entity.TextGui.TextLabel.Text = entityname
	local pathValue = Instance.new("ObjectValue",entity)
	pathValue.Value = path
	pathValue.Name = "Path"
	entity:PivotTo(path.CFrame * CFrame.new(0,2,0))
	entity.Parent = workspace.Enemies
	entity.HealthGui.Background.TextLabel.Text = "HP:" .. entityData.Data[entity.Name]["Health"]
	wait(0.1)
	local track = Instance.new("Animation")
	track.AnimationId = entityData.Data[entity.Name]["Animation"]
	local anim = entity.Humanoid.Animator:LoadAnimation(track)
	anim:Play()
end

function MoveEnemy(entity)
	local reachedend = false
	local node = entity.Path.Value
	local entityspeed = entityData.Data[entity.Name]["Speed"]
	local dmg = entityData.Data[entity.Name]["Health"]

	while reachedend == false do
		local nextnodes = node:GetChildren()
		if (#nextnodes > 0) then
			node = nextnodes[math.random(1,#nextnodes)]
			local parentnode = node.Parent
			local distance = (parentnode.Position-node.Position).Magnitude

			local cframedata = CFrame.new(parentnode.Position,node.Position)

			local entityPrimary
			if entity then
				entityPrimary = entity.PrimaryPart
			end

			local rotationTween
			local movementTween
            if entityPrimary then
                rotationTween = TweenService:Create(entityPrimary, TweenInfo.new(rotationSpeed,Enum.EasingStyle.Linear), {CFrame = cframedata})
			    movementTween = TweenService:Create(entityPrimary, TweenInfo.new(distance*speed*entityspeed, Enum.EasingStyle.Linear), {CFrame = node.CFrame})

			    rotationTween:Play()
			    rotationTween.Completed:Wait()
			    movementTween:Play()
			    movementTween.Completed:Wait()
            end

			if entity:FindFirstChild("EnemyHealth") then
				entity.EnemyHealth.Changed:Connect(function()
					if entity.EnemyHealth.Value == 0 then
						rotationTween:Stop()
						movementTween:Stop()
					end
				end)
			end

			if (#nextnodes == 0) then
				rotationtween:Stop()
				movementtween:Stop()
			end

		elseif (#nextnodes == 0) then
			reachedend = true
			entity:Destroy()
			workspace.PlrBase.Health.Value -= dmg
		end
	end
end

game.Workspace.Enemies.ChildAdded:Connect(function(entity)
	MoveEnemy(entity)
end)

wait(5)
print("The gamemode has started.")

local waveData = require(game.ReplicatedStorage.WaveData)
local map = "Baseplate"
local defaultWait = waveData.GeneralData.TimeUntilSpawn
local waves = #waveData.WaveData[map]

local folder = workspace.Enemies
local count = 0

folder.ChildAdded:Connect(function()
	count += 1
end)

folder.ChildRemoved:Connect(function()
	count -= 1
end)

workspace.PlrBase.Health.Changed:Connect(function()
	if workspace.PlrBase.Health.Value <= 0 then
		game.ReplicatedStorage.Remotes.Death:FireAllClients("Death")
	end
end)

for wave=1, waves do
	if workspace.PlrBase.Health.Value == 0 then return end
	game.ReplicatedStorage.Wave.Value = wave

		local moneyGain = waveData.MoneyData[map][wave][1]
		for _, plr in game.Players:GetPlayers() do
			local chr = plr.Character
			if chr then
				local cash = chr:WaitForChild("Cash")
				if cash then
					cash.Value += moneyGain
				end
			end
		end

	local function music()
		if wave == 5 then
			remotes.Music:FireAllClients(waveData.GeneralData.FirstMusic)
		elseif wave == 10 then
			remotes.Music:FireAllClients(waveData.GeneralData.FourthMusic)
		elseif wave == 15 then
			remotes.Music:FireAllClients(waveData.GeneralData.SeventhMusic)
		elseif wave == 25 then
			remotes.Music:FireAllClients(waveData.GeneralData.FifthMusic)
		elseif wave == 35 then
			remotes.Music:FireAllClients(waveData.GeneralData.ThirdMusic)
		elseif wave == 40 then
			remotes.Music:FireAllClients(waveData.GeneralData.SecondMusic)
		end
	end
	music()

	for i=1, #waveData.WaveData[map][wave] do
		if workspace.PlrBase.Health.Value == 0 then return end
		if (type(waveData.WaveData[map][wave][i]) == "table") then
			local entityName = waveData.WaveData[map][wave][1]
			local path = paths[1]
			wait(waveData.WaveData[map][wave][2])
			SpawnEnemy(path,entityName)
		else
			local entityName = waveData.WaveData[map][wave][i]
			local path = paths[1]
			SpawnEnemy(path,entityName)
			wait(defaultWait)
		end
	end
	repeat wait() until count == 0
end
