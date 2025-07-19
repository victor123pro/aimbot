local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

local function becomeUntouchable()
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.Transparency = 0.5
        end
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Name = "FakeHumanoid"
    end
    print("Je bent nu untouchable!")
end

local function destroyHumanoid()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:Destroy()
        print("Humanoid verwijderd, je kan niet doodgaan!")
    end
end

local function blinkBehindTarget(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end

    local behindPos = targetRoot.CFrame * CFrame.new(0, 0, -2) -- 2 studs achter target
    root.CFrame = behindPos
    print("Geblinkt achter " .. targetPlayer.Name)
end

-- Houd onkwetsbaarheid actief en vernietig humanoid zodra character laadt
RunService.Heartbeat:Connect(function()
    if character and character.Parent then
        becomeUntouchable()
        destroyHumanoid()
    end
end)

wait(2)
local function getClosestEnemy()
    local closestDist = math.huge
    local closestPlayer = nil

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closestPlayer = plr
            end
        end
    end
    return closestPlayer
end

local enemy = getClosestEnemy()
if enemy then
    blinkBehindTarget(enemy)
end
