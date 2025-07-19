local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local tool = nil

-- Zoek het zwaard in je character
for _, item in pairs(character:GetChildren()) do
	if item:IsA("Tool") then
		tool = item
		break
	end
end

-- Kill iedereen behalve jezelf
local function killAllPlayers()
	for _, targetPlayer in pairs(Players:GetPlayers()) do
		if targetPlayer ~= player and targetPlayer.Character then
			local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.Health = 0
			end
		end
	end
end

-- Als je zwaard 1x slaat, voer uit
if tool then
	tool.Activated:Connect(function()
		killAllPlayers()
	end)
else
	warn("Geen zwaard gevonden!")
end

