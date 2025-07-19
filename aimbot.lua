local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local tool = nil

-- Zoek jouw zwaard tool
for _, item in pairs(character:GetChildren()) do
    if item:IsA("Tool") then
        tool = item
        break
    end
end

local function getClosestEnemy()
    local closestDist = math.huge
    local closestPlayer = nil

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = plr.Character.HumanoidRootPart
            local dist = (targetRoot.Position - root.Position).Magnitude
            if dist < closestDist and dist < 15 then -- pas bereik aan indien nodig
                closestDist = dist
                closestPlayer = plr
            end
        end
    end
    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    if not tool or tool.Parent ~= character then
        -- Probeer tool opnieuw te vinden als je 'm kwijt bent
        for _, item in pairs(character:GetChildren()) do
            if item:IsA("Tool") then
                tool = item
                break
            end
        end
        if not tool then return end
    end

    local target = getClosestEnemy()
    if target and target.Character then
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            -- Draai naar target
            root.CFrame = CFrame.new(root.Position, targetRoot.Position)
            -- Activeer je zwaard aanval
            if tool.Enabled and tool.ToolEquipped then -- check of je script ready is
                tool:Activate()
            end
        end
    end
end)
