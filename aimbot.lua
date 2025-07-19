local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

local function becomeUntouchable()
    -- Zet alle parts van je character doorzichtig en onzichtbaar voor bots
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.Transparency = 0.5
        end
    end
    -- Optioneel: je kan ook tijdelijk je Humanoid onzichtbaar maken voor scripts
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Name = "FakeHumanoid" -- verberg je echt Humanoid
    end
    print("Je bent nu untouchable!")
end

local function blinkBehindTarget(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end

    -- Bereken positie 2 studs achter target (gebruik de lookVector van target)
    local behindPos = targetRoot.CFrame * CFrame.new(0, 0, 2) -- 2 studs achter

    -- Teleporteer jezelf naar die plek
    root.CFrame = behindPos
    print("Geblinkt achter " .. targetPlayer.Name)
end

-- Voorbeeld gebruik
becomeUntouchable()

-- Blink achter de eerste vijand die je tegenkomt
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

wait(2) -- Wacht even voor teleport

local enemy = getClosestEnemy()
if enemy then
    blinkBehindTarget(enemy)
end

