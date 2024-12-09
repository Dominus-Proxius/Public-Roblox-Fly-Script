local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local flying = false
local flightSpeed = 30 -- Speed of flying
local bodyGyro, bodyVelocity

-- Create UI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
local button = Instance.new("TextButton", screenGui)
local dragHandle = Instance.new("Frame", button)

-- Button properties
button.Size = UDim2.new(0, 100, 0, 50) -- Button size
button.Position = UDim2.new(0.5, -50, 0.5, -25)
button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 18
button.Font = Enum.Font.SourceSansBold
button.Text = "Fly"  -- Initial text

-- Drag handle properties
dragHandle.Size = UDim2.new(1, 0, 0, 10) -- Thin bar at the top
dragHandle.Position = UDim2.new(0, 0, 0, 0)
dragHandle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

-- Function to create flying mechanism
local function startFlying()
    flying = true
    character:WaitForChild("Humanoid").PlatformStand = true -- Disable physics
    bodyGyro = Instance.new("BodyGyro", character.HumanoidRootPart)
    bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
    bodyGyro.P = 3000
    
    bodyVelocity = Instance.new("BodyVelocity", character.HumanoidRootPart)
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)

    while flying do
        -- Move forward in the direction the character is looking when the joystick is used
        if player.PlayerScripts:FindFirstChild("Joystick") then -- Check if the joystick is available
            bodyVelocity.Velocity = character.HumanoidRootPart.CFrame.LookVector * flightSpeed
        end
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
local dragging = false
local dragInput
local startPos

dragHandle.InputBegan:Connect(function(input)
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
