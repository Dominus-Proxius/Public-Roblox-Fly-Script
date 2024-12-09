local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local flying = false
local flightSpeed = 30 -- Speed of flying
local bodyGyro, bodyVelocity

-- Create UI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
local button = Instance.new("TextButton", screenGui)
local joystick = Instance.new("Frame", screenGui) -- This will act as the joystick area
local dragHandle = Instance.new("Frame", joystick)

-- Button properties
button.Size = UDim2.new(0, 100, 0, 50)
button.Position = UDim2.new(0.5, -50, 0.5, -25)
button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 18
button.Font = Enum.Font.SourceSansBold
button.Text = "Fly"

-- Joystick properties
joystick.Size = UDim2.new(0, 200, 0, 200)
joystick.Position = UDim2.new(0.1, 0, 0.7, 0)
joystick.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

-- Drag handle properties (this is the actual joystick)
dragHandle.Size = UDim2.new(0, 100, 0, 100)
dragHandle.Position = UDim2.new(0.5, -50, 0.5, -50)
dragHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

-- Function to start flying
local function startFlying()
    flying = true
    character:WaitForChild("Humanoid").PlatformStand = true

    bodyGyro = Instance.new("BodyGyro", character.HumanoidRootPart)
    bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
    bodyGyro.P = 3000
    
    bodyVelocity = Instance.new("BodyVelocity", character.HumanoidRootPart)
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)

    while flying do
        -- Control the direction based on joystick position
        local joystickPos = dragHandle.Position
        local joystickX = (joystickPos.X.Scale * joystick.AbsoluteSize.X) + (joystickPos.X.Offset + (dragHandle.Size.X.Offset/2))
        local joystickY = (joystickPos.Y.Scale * joystick.AbsoluteSize.Y) + (joystickPos.Y.Offset + (dragHandle.Size.Y.Offset/2))

        local center = Vector2.new(joystick.AbsolutePosition.X + (joystick.AbsoluteSize.X / 2), joystick.AbsolutePosition.Y + (joystick.AbsoluteSize.Y / 2))
        local direction = Vector2.new(joystickX - center.X, joystickY - center.Y)

        -- Calculate directional velocity
        local moveDirection = Vector3.new(direction.X, 0, direction.Y).Unit

        -- Set velocity
        bodyVelocity.Velocity = moveDirection * flightSpeed

        -- Set character to face the moving direction
        bodyGyro.CFrame = CFrame.new(character.HumanoidRootPart.Position, character.HumanoidRootPart.Position + moveDirection)

        wait(0.1)
    end

    bodyGyro:Destroy()
    bodyVelocity:Destroy()
    character.Humanoid.PlatformStand = false 
end

-- Function to stop flying
local function stopFlying()
    flying = false
end

-- Toggle flying when the button is clicked
button.MouseButton1Click:Connect(function()
    if flying then
        stopFlying()
        button.Text = "Fly"
    else
        startFlying()
        button.Text = "Unfly"
    end
end)

-- Joystick touch handling
local dragging = false
local startPosition = nil

dragHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        startPosition = input.Position
    end
end)

dragHandle.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - startPosition
        local newPosition = UDim2.new(0.5, delta.X, 0.5, delta.Y)
        dragHandle.Position = newPosition

        -- Constrain dragHandle to stay within the joystick area
        if newPosition.X.Offset < -100 then
            dragHandle.Position = UDim2.new(0, -100, 0, dragHandle.Position.Y.Offset)
        elseif newPosition.X.Offset > 100 then
            dragHandle.Position = UDim2.new(0, 100, 0, dragHandle.Position.Y.Offset)
        end
        if newPosition.Y.Offset < -100 then
            dragHandle.Position = UDim2.new(dragHandle.Position.X.Offset, 0, 0, -100)
        elseif newPosition.Y.Offset > 100 then
            dragHandle.Position = UDim2.new(dragHandle.Position.X.Offset, 0, 0, 100)
        end
    end
end)

dragHandle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        dragHandle.Position = UDim2.new(0.5, -50, 0.5, -50) -- Reset position after release
    end
end)

-- Reset button on character respawn
player.CharacterAdded:Connect(function(newCharacter)
    if button then
        button:Destroy() -- Remove button on respawn
    end
end)
