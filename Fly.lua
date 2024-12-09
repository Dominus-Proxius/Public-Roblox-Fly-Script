local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local flying = false
local flightSpeed = 30 -- Speed of teleportation while flying
local bodyGyro, bodyVelocity

-- Create UI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
local button = Instance.new("TextButton", screenGui)

button.Size = UDim2.new(0, 100, 0, 50) -- Adjust size for easier tapping
button.Position = UDim2.new(0.5, -50, 0.5, -25)
button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 18
button.Font = Enum.Font.SourceSansBold
button.Text = "Fly"  -- Initial text

-- Function to create flying mechanism
local function startFlying()
    flying = true
    character:WaitForChild("Humanoid").PlatformStand = true -- Disable physics
    bodyGyro = Instance.new("BodyGyro", character.HumanoidRootPart)
    bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
    bodyGyro.P = 3000
    
    bodyVelocity = Instance.new("BodyVelocity", character.HumanoidRootPart)
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)

    while flying do
        local direction = mouse.Hit.LookVector
        bodyVelocity.Velocity = Vector3.new(direction.X * flightSpeed, direction.Y * flightSpeed, direction.Z * flightSpeed)
        bodyGyro.CFrame = CFrame.new(character.HumanoidRootPart.Position, character.HumanoidRootPart.Position + direction)
        wait(0.1) -- Adjust for smoother movement
    end

    bodyGyro:Destroy()
    bodyVelocity:Destroy()
    character.Humanoid.PlatformStand = false -- Re-enable physics
end

-- Function to stop flying
local function stopFlying()
    flying = false
end

-- Function to toggle flight state
local function toggleFly()
    if flying then
        stopFlying()
        button.Text = "Fly"  -- Change text back to Fly
    else
        button.Text = "Unfly"  -- Change text to Unfly
        startFlying()
    end
end

-- Mobile-friendly button dragging functionality
local dragging
local dragInput
local startPos

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragInput = input
        startPos = button.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

-- Move button while dragging
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragInput.Position
        button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

button.MouseButton1Click:Connect(toggleFly)

-- Reset button on character respawn
player.CharacterAdded:Connect(function(newCharacter)
    if button then
        button:Destroy() -- Remove button on respawn
    end
end)
