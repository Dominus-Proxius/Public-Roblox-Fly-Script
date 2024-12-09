local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local flying = false
local flightSpeed = 50 -- Adjust this to change flight speed
local bodyVelocity

-- Function to create the fly button
local function createFlyButton()
    local screenGui = Instance.new("ScreenGui", player.PlayerGui)
    local flyButton = Instance.new("TextButton")
    
    flyButton.Size = UDim2.new(0, 70, 0, 30) -- Smaller size
    flyButton.Position = UDim2.new(0, 100, 0, 100)
    flyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyButton.TextSize = 18
    flyButton.Font = Enum.Font.SourceSansBold
    flyButton.Text = "Fly"  -- Initial text
    flyButton.Parent = screenGui

    -- Draggable functionality
    local dragging
    local dragInput
    local startPos

    flyButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            startPos = flyButton.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    game:GetService("UserInputService").TouchMoved:Connect(function(input)
        if dragging then
            local delta = input.Position - dragInput.Position
            flyButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    return flyButton
end

-- Function to enable flying
local function startFlying()
    flying = true

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Parent = character.HumanoidRootPart

    while flying do
        local direction = mouse.Hit.LookVector * flightSpeed
        bodyVelocity.Velocity = Vector3.new(direction.X, 50, direction.Z) -- Allow upward movement
        wait()
    end

    bodyVelocity:Destroy()
end

-- Function to stop flying
local function stopFlying()
    flying = false
end

-- Toggle flying when the button is tapped
local function toggleFly(flyButton)
    if flying then
        stopFlying()
        flyButton.Text = "Fly"  -- Change text to Fly
    else
        startFlying()
        flyButton.Text = "Unfly"  -- Change text to Unfly
    end
end

-- Create fly button and connect it to toggle flying
local flyButton = createFlyButton()

-- Connect button click to toggle flying
flyButton.MouseButton1Click:Connect(function() toggleFly(flyButton) end)
