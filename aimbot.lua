local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local tool = nil

-- Vind je zwaard (Tool)
local function findTool()
	for _, item in pairs(character:GetChildren()) do
		if item:IsA("Tool") then
			return item
		end
	end
	return nil
end

-- Maak je moeilijker te raken
local function becomeUntouchable()
	for _, part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
			part.Transparency = 0.3
		end
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.Name = "NotAHumanoid"
	end
end

-- Zoek dichtstbijzijnde vijand
local function getClosestEnemy()
	local closestDist = math.huge
	local closestPlayer = nil

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local targetRoot = plr.Character.HumanoidRootPart
			local dist = (targetRoot.Position - root.Position).Magnitude
			if dist < closestDist and dist < 25 then
				closestDist = dist
				closestPlayer = plr
			end
		end
	end
	return closestPlayer
end

-- Teleport achter je vijand voor instant attack
local function blinkBehindTarget(targetRoot)
	local direction = (root.Position - targetRoot.Position).Unit
	local behind = targetRoot.Position - direction * 2
	root.CFrame = CFrame.new(behind, targetRoot.Position)
end

-- ⚔️ Main loop
RunService.RenderStepped:Connect(function()
	tool = tool or findTool()
	if not tool then return end

	local target = getClosestEnemy()
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		local targetRoot = target.Character.HumanoidRootPart

		-- Teleport achter hem
		blinkBehindTarget(targetRoot)

		-- Richting + aanval
		root.CFrame = CFrame.new(root.Position, targetRoot.Position)
		if tool.Enabled and tool.ToolEquipped then
			tool:Activate()
			tool:Activate() -- extra
		end
	end
end)

-- Maak jezelf moeilijk te raken
becomeUntouchable()
