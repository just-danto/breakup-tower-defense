local repStorage = game:GetService("ReplicatedStorage") --Gets the ReplicatedStorage.

local remotes = repStorage:WaitForChild("Remotes") --Gets the Remotes folder that stores the remote events/functions
local musicRemote = remotes:WaitForChild("Music") --Gets the Music remote event.

local plr = game.Players.LocalPlayer --Gets the current player.

local musicOn = false --Sets musicOn as false.

local music = Instance.new("Sound") --Creates a looped Sound instance that is parented to the player.
music.Parent = plr
music.Looped = true

musicRemote.OnClientEvent:Connect(function(music) --Detects when a client event is fired on the musicRemote, receiving the variable music(SoundID).
	if musicOn == false then --If musicOn is false, do the following:
	    --Sets the SoundID and plays the music, setting musicOn to true.
		music.SoundId = music
		music.Volume = 1.5
		music:Play()
		musicOn = true
	else --If musicOn is true, do the following:
	    --Stops the previous music and plays again with the updated SoundId.
		music:Stop()
		music.SoundId = music
		music.Volume = 1.5
		music:Play()
	end
end)
