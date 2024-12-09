local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local flying = false
local flightSpeed = 15 -- Speed of teleportation when flying
local button

-- Create a ScreenGui for the button
local screenGui = Instance.new("ScreenGui", player.PlayerGui)

-- Function to create the fly button
local function createFlyButton()
    button = Instance.new("TextButton")
    
    button.Size = UDim2.new(0, 70, 0, 30) -- Smaller size
    button.Position = UDim2.new(0, 100, 0, 100)
    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 18
    button.Font = Enum.Font.SourceSansBold
    button.Text = "Fly"  -- Initial text
    button.Parent = screenGui

    return button
end

-- Function to handle flying
local function fly()
    flying = true
    local rootPart = character:WaitForChild("HumanoidRootPart")

    while flying do
        -- Teleport the player in the direction they are looking
        local direction = mouse.Hit.LookVector
        rootPart.Position = rootPart.Position + direction * flightSpeed * 0.1 -- 0.1 to control teleportation distance
        wait(0.1) -- Adjust for smoother movement
    end
end

-- Function to toggle flying
local function toggleFly()
    if flying then
        flying = false
        button.Text = "Fly"  -- Change text back to Fly
    else
        button.Text = "Unfly"  -- Change text to Unfly
        fly() -- Start flying
    end
end

-- Create the fly button and connect it to toggle flying
createFlyButton()
button.MouseButton1Click:Connect(toggleFly)

-- Function to clean up when the player resets or leaves
player.CharacterAdded:Connect(function(newCharacter)
    if button then
        button:Destroy() -- Remove button on respawn
    end
end)
