local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local flying = false
local flightSpeed = 50 -- Adjust this value to change flight speed

-- Function to create the fly button
local function createFlyButton()
    local screenGui = Instance.new("ScreenGui", player.PlayerGui)
    local flyButton = Instance.new("Frame")
    
    flyButton.Size = UDim2.new(0, 50, 0, 50)
    flyButton.Position = UDim2.new(0, 100, 0, 100)
    flyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    flyButton.BorderSizePixel = 0
    flyButton.AnchorPoint = Vector2.new(0.5, 0.5)
    flyButton.Parent = screenGui

    local corner = Instance.new("UIScale")
    corner.Parent = flyButton

    -- Draggable functionality
    local dragging
    local dragInput
    local startPos = flyButton.Position

    local function updateInput(input)
        local delta = input.Position - dragInput.Position
        flyButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

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
            updateInput(input)
        end
    end)

    return flyButton
end

-- Function to enable flying
local function startFlying()
    flying = true
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = character.HumanoidRootPart

    while flying do
        bodyVelocity.Velocity = Vector3.new(mouse.Hit.LookVector.X * flightSpeed, 50, mouse.Hit.LookVector.Z * flightSpeed)
        wait()
    end

    bodyVelocity:Destroy()
end

-- Function to stop flying
local function stopFlying()
    flying = false
end

-- Toggle flying when the button is tapped
local function toggleFly()
    if flying then
        stopFlying()
    else
        startFlying()
    end
end

-- Create fly button and connect it to toggle flying
local flyButton = createFlyButton()

-- Connect button click to toggle flying
flyButton.MouseButton1Click:Connect(toggleFly)
