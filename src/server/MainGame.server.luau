local repStorage = game:GetService("ReplicatedStorage") --Gets the ReplicatedStorage.

local entityData = require(repStorage.EntityData) --Gets the Entity Data.
local waveData = require(repStorage.WaveData) --Gets the Wave Data.
local map = "Baseplate" --Sets current map's name. (To-do: Change automatically with value from server hub.)


local globalWave = Instance.new("IntValue") --Creates a global current wave value.
globalWave.Name = "Wave"
globalWave.Parent = repStorage
local remotes = Instance.new("Folder") --Creates the Remotes folder and children remote events.
remotes.Name = "Remotes"
remotes.Parent = repStorage
for _, remoteName in ipairs({"Death", "Cash", "Music", "Tower"}) do
	local remote = Instance.new("RemoteEvent")
	remote.Name = remoteName
	remote.Parent = remotes
end
local levelRemote = Instance.new("RemoteFunction") --Creates the single Level remote function.
levelRemote.Name = "Level"
levelRemote.Parent = remotes

game.Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(chr) --Creates a Cash and Arcana value on every player's character when joining server.
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

local paths = {workspace.Path} --Gets the path folder for the current map.
local speed = .05
local rotationSpeed = .2

function SpawnEnemy(path,entityname)
	local entity = game.Workspace.Dummy:Clone() --Clones the base Dummy model used for enemies.
	entity.Name = entityname
	local pathValue = Instance.new("ObjectValue",entity) --Creates a value that holds the current path object.
	pathValue.Value = path
	pathValue.Name = "Path"
	entity.Parent = workspace.Enemies --Parents entity to the map's Enemies folder after the pathValue is set.
	entity.TextGui.TextLabel.Text = entityname --Sets entity's Nametag to the entityname received.

    --Sets values based on the data related to the entityname received.
	local enemyHealth = entity:FindFirstChild("EnemyHealth") or Instance.new("IntValue") --Gets the health value or creates one if the model lacks it (never index directly: may not exist).
	if not enemyHealth.Parent then --If the value was just created, parents it to the entity.
		enemyHealth.Name = "EnemyHealth"
		enemyHealth.Parent = entity
	end
	enemyHealth.Value = entityData.Data[entity.Name]["Health"]
	entity.Torso.Color = entityData.Data[entity.Name]["Color"]
	entity.HealthGui.Background.TextLabel.Text = "HP:" .. entityData.Data[entity.Name]["Health"]

	entity:PivotTo(path.CFrame * CFrame.new(0,2,0)) --Moves entity to the current path object with set offset.
	task.wait(0.1)
	local track = Instance.new("Animation") --Creates the entity's base animation.
	track.AnimationId = entityData.Data[entity.Name]["Animation"] --Gets the animation's ID from the data related to the entity name received.
	local anim = entity.Humanoid.Animator:LoadAnimation(track) --Loads and plays the animation.
	anim:Play()
end

function MoveEnemy(entity)
	local reachedend = false
	local node = entity:FindFirstChild("Path").Value --Gets current path object from the ObjectValue within the entity.
	--Gets values based on the data related to the entity's name.
	local entityspeed = entityData.Data[entity.Name]["Speed"]
	local dmg = entityData.Data[entity.Name]["Health"]

	if entity:FindFirstChild("EnemyHealth") then --Gets the entity's health value.
		entity.EnemyHealth.Changed:Connect(function() --When health changes, detect.
			if entity.EnemyHealth.Value <= 0 and entity.Parent then --If entity is dead, destroys its model (fires ChildRemoved, which updates the wave's enemy count).
				entity:Destroy() --Removes the entity from the game.
			end
		end)
	end

	while reachedend == false do --If there is still path available, do the following:
		if not entity.Parent then return end --If the entity was destroyed (e.g. killed by a tower), stops moving it.
		local nextnodes = node:GetChildren() --Gets all of the next path objects.
		if (#nextnodes > 0) then --If there is still available path objects to move towards, starts movement.
			node = nextnodes[math.random(1,#nextnodes)] --Sets current node to the next path object.
			local parentnode = node.Parent --Sets parentnode to the previous path object.
			local distance = (parentnode.Position-node.Position).Magnitude --Gets the distance in Magnitude between the previous and next path objects.

			local cframedata = CFrame.new(parentnode.Position,node.Position) --Creates CFrame data based on the current and

			local entityPrimary --Sets variable outside of if statement.
			if entity then --If entity's model still exists, sets PrimaryPart onto variable.
				entityPrimary = entity.PrimaryPart
			end

            --Sets both variables outside of the if statement.
			local rotationTween
			local movementTween
            if entityPrimary then --If the entity still exists, do the following:
                --Creates the movement and rotation tweens towards the next node's CFrame.
                rotationTween = TweenService:Create(entityPrimary, TweenInfo.new(rotationSpeed,Enum.EasingStyle.Linear), {CFrame = cframedata})
			    movementTween = TweenService:Create(entityPrimary, TweenInfo.new(distance*speed*entityspeed, Enum.EasingStyle.Linear), {CFrame = node.CFrame})

                --Plays and waits until completion of both rotation and movement respectively.
			    rotationTween:Play()
			    rotationTween.Completed:Wait()
			    movementTween:Play()
			    movementTween.Completed:Wait()
            end
		elseif (#nextnodes == 0) then --If the end of the nodes has been reached, do the following:
			reachedend = true --Sets value that signals that no path is available.
			entity:Destroy() --Destroys the entity's model.
			workspace.PlrBase.Health.Value -= dmg --Deducts the damage from the player's base's health.
		end
	end
end

task.wait(5) --Waits for player loading.
print("The gamemode has started.") --Signals the start of the main game script.
local defaultWait = waveData.GeneralData.TimeUntilSpawn --Gets the wait value set on Wave Data.
local waves = #waveData.WaveData[map] --Gets every single wave's data related to the current map.

local enemyFolder = workspace.Enemies --Gets the enemy folder on current map.
local count = 0

enemyFolder.ChildAdded:Connect(function(entity) --Detects when an enemy is added to the enemy folder.
	MoveEnemy(entity) --Immediately starts the movement function with the entity model.
	count += 1 --Adds one to the current enemy count.
end)
enemyFolder.ChildRemoved:Connect(function() --Detects when an enemy is removed from the enemy folder.
	count -= 1 --Deducts one from the current enemy count.
end)

for wave=1, waves do --For every wave starting from one, do the following:
	if workspace.PlrBase.Health.Value == 0 then return end --If the player's base is dead, return.
	globalWave.Value = wave --Sets the globalWave value to current wave.

		local cashGain = waveData.CashData[map][wave][1] --Gets the cash gain related to the current wave.
		for _, plr in game.Players:GetPlayers() do --Adds the cash gain to every player's cash.
			local chr = plr.Character
			if chr then
				local cash = chr:WaitForChild("Cash")
				if cash then
					cash.Value += cashGain
				end
			end
		end

	local function music() --Changes music based on the music ID related to the current wave.
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

	for i=1, #waveData.WaveData[map][wave] do --For every data related to map and current wave, do the following:
		if workspace.PlrBase.Health.Value == 0 then return end --If the player's base is dead, return.
		local data = waveData.WaveData[map][wave][i] --Gets the current enemy's data in the order related to map and current wave.
		if (type(data) == "table") then --If current enemy data is a table, do the following:
			local entityName = data[1] --Sets entityName to the first value of the enemy data.
			local path = paths[1] --Gets the first available path object.
			task.wait(data[2]) --Waits the second value of the enemy data before spawning.
			SpawnEnemy(path,entityName) --Starts the spawn function with the path and entityName values.
		else --If current enemy data isn't a table, do the following:
			local entityName = data --Sets entityName to the current enemy data.
			local path = paths[1] --Gets the first available path object.
			task.wait(defaultWait) --Waits the default time between spawns.
			SpawnEnemy(path,entityName) --Starts the spawn function with the path and entityName values.
		end
	end
	repeat task.wait() until count == 0 --Repeats until the enemy count is zero.
end

workspace.PlrBase.Health.Changed:Connect(function() --Detects when player's base's health value changes.
	if workspace.PlrBase.Health.Value <= 0 then --If player's base's health value is minus or equal to 0, do the following:
		repStorage.Remotes.Death:FireAllClients("Death") --Signals the base's death to every player.
	end
end)
