local p = game.Players.LocalPlayer

local musicOn = false
local sound = Instance.new("Sound")
sound.Parent = p
sound.Looped = true

local remotes = game.ReplicatedStorage.Remotes

remotes.Death.OnClientEvent:Connect(function()
	p.PlayerGui.EndGui.Enabled = true
end)

remotes.Cash.OnClientEvent:Connect(function(value)
	p.Character.Cash.Value += unpack(value)
end)

remotes.Music.OnClientEvent:Connect(function(music)
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
