local plr = game.Players.LocalPlayer

local musicOn = false
local sound = Instance.new("Sound")
sound.Parent = plr
sound.Looped = true

local remotes = game.ReplicatedStorage:WaitForChild("Remotes")
local deathRemote = remotes:WaitForChild("Death")
local musicRemote = remotes:WaitForChild("Music")

deathRemote.OnClientEvent:Connect(function()
	plr.PlayerGui.EndGui.Enabled = true
end)

musicRemote.OnClientEvent:Connect(function(music)
	if musicOn == false then
		sound.SoundId = music
		sound.Volume = 1.5
		sound:Play()
		musicOn = true
	else
		sound:Stop()
		sound.SoundId = music
		sound.Volume = 1.5
		sound:Play()
	end
end)
