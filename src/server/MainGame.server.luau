local entitydata = require(game.ReplicatedStorage.EntityData)

local wave = Instance.new("IntValue")
wave.Name = "Wave"
wave.Parent = game.ReplicatedStorage
local remotes = Instance.new("Folder")
remotes.Name = "Remotes"
remotes.Parent = game.ReplicatedStorage
for _, remoteName in ipairs({"Death", "Cash", "Music"}) do
	local remote = Instance.new("RemoteEvent")
	remote.Name = remoteName
	remote.Parent = remotes
end

game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c)
        local cash = Instance.new("IntValue")
        cash.Name = "Cash"
        cash.Value = 200
        cash.Parent = c
        local arcana = Instance.new("IntValue")
        arcana.Name = "Arcana"
        arcana.Value = 0
        arcana.Parent = c
    end)
end)

local TweenService = game:GetService("TweenService")
local paths = {workspace.Path}

local speed = .05
local rotationSpeed = .2

function SpawnEnemy(path,entityname)
	local entity = game.Workspace.Dummy:Clone()
	entity.Name = entityname
	entity.EnemyHealth.Value = entitydata.Data[entity.Name]["Health"]
	entity.Torso.Color = entitydata.Data[entity.Name]["Color"]
	entity.TextGui.TextLabel.Text = entityname
	local pathvalue = Instance.new("ObjectValue",entity)
	pathvalue.Value = path
	pathvalue.Name = "Path"
	entity:PivotTo(path.CFrame * CFrame.new(0,2,0))
	entity.Parent = workspace.Enemies
	entity.HealthGui.Background.TextLabel.Text = "HP:" .. entitydata.Data[entity.Name]["Health"]
	wait(0.1)
	local track = Instance.new("Animation")
	track.AnimationId = entitydata.Data[entity.Name]["Animation"]
	local anim = entity.Humanoid.Animator:LoadAnimation(track)
	anim:Play()
end

function MoveEnemy(entity)
	local reachedend = false
	local node = entity.Path.Value
	local entityspeed = entitydata.Data[entity.Name]["Speed"]
	local dmg = entitydata.Data[entity.Name]["Health"]

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

			local rotationtween = TweenService:Create(entityPrimary, TweenInfo.new(rotationSpeed,Enum.EasingStyle.Linear), {CFrame = cframedata})
			local movementtween = TweenService:Create(entityPrimary, TweenInfo.new(distance*speed*entityspeed, Enum.EasingStyle.Linear), {CFrame = node.CFrame})

			rotationtween:Play()
			rotationtween.Completed:Wait()

			movementtween:Play()
			movementtween.Completed:Wait()

			if entity:FindFirstChild("EnemyHealth") then
				entity.EnemyHealth.Changed:Connect(function()
					if entity.EnemyHealth.Value == 0 then
						rotationtween:Stop()
						movementtween:Stop()
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
			print("BaseDmg:"..dmg)
			workspace.PlrBase.Health.Value -= dmg
		end
	end
end

game.Workspace.Enemies.ChildAdded:Connect(function(entity)
	MoveEnemy(entity)
end)

wait(5)
print("start")

local wavedata = require(game.ReplicatedStorage.WaveData)
local map = "Baseplate"
local defaultwait = wavedata.GeneralData.TimeUntilSpawn
local waves = #wavedata.WaveData[map]

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

	remotes.Cash:FireAllClients(wavedata.MoneyData[map][wave])

	local function music()
		if wave == 5 then
			remotes.Music:FireAllClients(wavedata.GeneralData.FirstMusic)
		elseif wave == 10 then
			remotes.Music:FireAllClients(wavedata.GeneralData.FourthMusic)
		elseif wave == 15 then
			remotes.Music:FireAllClients(wavedata.GeneralData.SeventhMusic)
		elseif wave == 25 then
			remotes.Music:FireAllClients(wavedata.GeneralData.FifthMusic)
		elseif wave == 35 then
			remotes.Music:FireAllClients(wavedata.GeneralData.ThirdMusic)
		elseif wave == 40 then
			remotes.Music:FireAllClients(wavedata.GeneralData.SecondMusic)
		end
	end
	music()

	for i=1, #wavedata.WaveData[map][wave] do
		if workspace.PlrBase.Health.Value == 0 then return end
		if (type(wavedata.WaveData[map][wave][i]) == "table") then
			local entityname = wavedata.WaveData[map][wave][1]
			local path = paths[1]
			wait(wavedata.WaveData[map][wave][2])
			SpawnEnemy(path,entityname)
		else
			local entityname = wavedata.WaveData[map][wave][i]
			local path = paths[1]
			SpawnEnemy(path,entityname)
			wait(defaultwait)
		end
	end
	repeat wait() until count == 0
end


--while true do
	--local path = paths[math.random(1,#paths)]
	--SpawnEnemy(path)
	--wait(2)
--end
