local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local selectedPlayer = nil
local isFollowing = false
local isRandomMode = false
local isHealthMode = false
local followConnection = nil
local randomModeTimer = nil
local healthModeTimer = nil

local followMode = "Behind" -- Default follow mode
local isAutoClicking = false
local autoClickConnection = nil
local lastPosition = nil
local isRunning = false
local followConnection = nil
local lastPosition = nil
local isFollowing = false
local followConnection = nil
local followDistance = 5 -- Distance to follow behind the mob
local MobfollowDistance = 5 -- 


local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FollowPlayerGui"
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 550)
mainFrame.Position = UDim2.new(0, 10, 1, -450) -- Adjusted Y position to match new height
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

-- Minimize
local isMinimized = false
local originalSize = mainFrame.Size
local minimizedSize = UDim2.new(0, 250, 0, 30)

-- Title
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "Follow Player"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -30, 0, 0)
minimizeButton.BackgroundTransparency = 1
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 20
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.Text = "-"
minimizeButton.Parent = titleBar

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Dropdown frame
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Name = "DropdownFrame"
dropdownFrame.Size = UDim2.new(0.9, 0, 0, 30)
dropdownFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.Parent = contentFrame

-- Dropdown text
local dropdownText = Instance.new("TextLabel")
dropdownText.Name = "DropdownText"
dropdownText.Size = UDim2.new(1, 0, 1, 0)
dropdownText.BackgroundTransparency = 1
dropdownText.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdownText.TextSize = 14
dropdownText.Font = Enum.Font.SourceSans
dropdownText.Text = "Select Player"
dropdownText.Parent = dropdownFrame

-- Dropdown button
local dropdownButton = Instance.new("TextButton")
dropdownButton.Name = "DropdownButton"
dropdownButton.Size = UDim2.new(1, 0, 1, 0)
dropdownButton.BackgroundTransparency = 1
dropdownButton.TextTransparency = 1
dropdownButton.Text = ""
dropdownButton.Parent = dropdownFrame

-- Dropdown list (position now above the dropdown)
local dropdownList = Instance.new("ScrollingFrame")
dropdownList.Name = "DropdownList"
dropdownList.Size = UDim2.new(1, 0, 0, 100)
dropdownList.Position = UDim2.new(0, 0, -1, -100)
dropdownList.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dropdownList.BorderSizePixel = 0
dropdownList.ScrollBarThickness = 4
dropdownList.Visible = false
dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
dropdownList.Parent = dropdownFrame

-- Distance slider label
local distanceLabel = Instance.new("TextLabel")
distanceLabel.Name = "DistanceLabel"
distanceLabel.Size = UDim2.new(0.9, 0, 0, 20)
distanceLabel.Position = UDim2.new(0.05, 0, 0.13, 0)
distanceLabel.BackgroundTransparency = 1
distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
distanceLabel.TextSize = 14
distanceLabel.Font = Enum.Font.SourceSans
distanceLabel.Text = "Distance: 5 studs"
distanceLabel.TextXAlignment = Enum.TextXAlignment.Left
distanceLabel.Parent = contentFrame

-- Distance slider
local distanceSlider = Instance.new("Frame")
distanceSlider.Name = "DistanceSlider"
distanceSlider.Size = UDim2.new(0.9, 0, 0, 20)
distanceSlider.Position = UDim2.new(0.05, 0, 0.18, 0) -- Adjusted Y position to move it up
distanceSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
distanceSlider.BorderSizePixel = 0
distanceSlider.Parent = contentFrame

local sliderFill = Instance.new("Frame")
sliderFill.Name = "SliderFill"
sliderFill.Size = UDim2.new(followDistance/20, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = distanceSlider

local sliderButton = Instance.new("TextButton")
sliderButton.Name = "SliderButton"
sliderButton.Size = UDim2.new(1, 0, 1, 0)
sliderButton.BackgroundTransparency = 1
sliderButton.Text = ""
sliderButton.Parent = distanceSlider


--  Distance slider label
local DistanceLabel = Instance.new("TextLabel")
DistanceLabel.Name = "MobDistanceLabel"
mobDistanceLabel.Size = UDim2.new(0.9, 0, 0, 20)
mobDistanceLabel.Position = UDim2.new(0.05, 0, 0.23, 0) -- Adjusted Y position
mobDistanceLabel.BackgroundTransparency = 1
mobDistanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
mobDistanceLabel.TextSize = 14
mobDistanceLabel.Font = Enum.Font.SourceSans
mobDistanceLabel.Text = "Mob Distance: 5 studs"
mobDistanceLabel.TextXAlignment = Enum.TextXAlignment.Left
mobDistanceLabel.Parent = contentFrame

-- Mob Distance slider
local mobDistanceSlider = Instance.new("Frame")
mobDistanceSlider.Name = "MobDistanceSlider"
mobDistanceSlider.Size = UDim2.new(0.9, 0, 0, 20)
mobDistanceSlider.Position = UDim2.new(0.05, 0, 0.28, 0) -- Adjusted Y position
mobDistanceSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
mobDistanceSlider.BorderSizePixel = 0
mobDistanceSlider.Parent = contentFrame

local mobSliderFill = Instance.new("Frame")
mobSliderFill.Name = "SliderFill"
mobSliderFill.Size = UDim2.new(MobfollowDistance/20, 0, 1, 0)
mobSliderFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
mobSliderFill.BorderSizePixel = 0
mobSliderFill.Parent = mobDistanceSlider

local mobSliderButton = Instance.new("TextButton")
mobSliderButton.Name = "SliderButton"
mobSliderButton.Size = UDim2.new(1, 0, 1, 0)
mobSliderButton.BackgroundTransparency = 1
mobSliderButton.Text = ""
mobSliderButton.Parent = mobDistanceSlider


-- Follow mode label
local modeLabel = Instance.new("TextLabel")
modeLabel.Name = "ModeLabel"
modeLabel.Size = UDim2.new(0.9, 0, 0, 20)
modeLabel.Position = UDim2.new(0.05, 0, 0.35, 0)
modeLabel.BackgroundTransparency = 1
modeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
modeLabel.TextSize = 14
modeLabel.Font = Enum.Font.SourceSans
modeLabel.Text = "Follow Mode:"
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Parent = contentFrame

-- Modes
local modes = {"Behind", "Above", "Below"}
local modeButtons = {}

for i, mode in ipairs(modes) do
    local button = Instance.new("TextButton")
    button.Name = mode.."Button"
    button.Size = UDim2.new(0.28, 0, 0, 25)
    button.Position = UDim2.new(0.05 + (i-1) * 0.31, 0, 0.42, 0)
    if mode == followMode then
        button.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    else
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end
    button.BorderSizePixel = 0
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.SourceSans
    button.Text = mode
    button.Parent = contentFrame
    
    button.MouseButton1Click:Connect(function()
        followMode = mode
        
        -- Update button colors
        for _, btn in ipairs(modeButtons) do
            if btn == button then
                btn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
            else
                btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            end
        end
        
        -- FIXED: Immediately update follow position when mode changes
        if isFollowing and selectedPlayer then
            followPlayer(selectedPlayer)
        end
    end)
    
    table.insert(modeButtons, button)
end

-- Start/Stop Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0.9, 0, 0, 30)
toggleButton.Position = UDim2.new(0.05, 0, 0.55, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
toggleButton.BorderSizePixel = 0
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 14
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Text = "Start Following"
toggleButton.Parent = contentFrame

-- Random Player Button
local randomButton = Instance.new("TextButton")
randomButton.Name = "RandomButton"
randomButton.Size = UDim2.new(0.9, 0, 0, 30)
randomButton.Position = UDim2.new(0.05, 0, 0.68, 0)
randomButton.BackgroundColor3 = Color3.fromRGB(120, 40, 120)
randomButton.BorderSizePixel = 0
randomButton.TextColor3 = Color3.fromRGB(255, 255, 255)
randomButton.TextSize = 14
randomButton.Font = Enum.Font.SourceSansBold
randomButton.Text = "Random Player Mode"
randomButton.Parent = contentFrame

-- Lowest Health Button
local healthButton = Instance.new("TextButton")
healthButton.Name = "HealthButton"
healthButton.Size = UDim2.new(0.9, 0, 0, 30)
healthButton.Position = UDim2.new(0.05, 0, 0.81, 0)
healthButton.BackgroundColor3 = Color3.fromRGB(180, 120, 40)
healthButton.BorderSizePixel = 0
healthButton.TextColor3 = Color3.fromRGB(255, 255, 255)
healthButton.TextSize = 14
healthButton.Font = Enum.Font.SourceSansBold
healthButton.Text = "Lowest Health Mode"
healthButton.Parent = contentFrame

-- Auto Click Button
local autoClickButton = Instance.new("TextButton")
autoClickButton.Name = "AutoClickButton"
autoClickButton.Size = UDim2.new(0.9, 0, 0, 30)
autoClickButton.Position = UDim2.new(0.05, 0, 0.94, 0)
autoClickButton.BackgroundColor3 = Color3.fromRGB(40, 40, 120)
autoClickButton.BorderSizePixel = 0
autoClickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoClickButton.TextSize = 14
autoClickButton.Font = Enum.Font.SourceSansBold
autoClickButton.Text = "Auto Click [V]"
autoClickButton.Parent = contentFrame

-- Mob Auto Farm Button
local mobAutoFarmButton = Instance.new("TextButton")
mobAutoFarmButton.Name = "MobAutoFarmButton"
mobAutoFarmButton.Size = UDim2.new(0.9, 0, 0, 30)
mobAutoFarmButton.Position = UDim2.new(0.05, 0, 0.81, 0) -- Adjusted position to avoid overlap
mobAutoFarmButton.BackgroundColor3 = Color3.fromRGB(120, 40, 40)  -- Adjusted color for distinction
mobAutoFarmButton.BorderSizePixel = 0
mobAutoFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mobAutoFarmButton.TextSize = 14
mobAutoFarmButton.Font = Enum.Font.SourceSansBold
mobAutoFarmButton.Text = "Mob Auto Farm"
mobAutoFarmButton.Parent = contentFrame
local dragging = false
local dragInput
local dragStart
local startPos

local function updateSlider(input)
    local relativeX = input.Position.X - distanceSlider.AbsolutePosition.X
    local percentage = math.clamp(relativeX / distanceSlider.AbsoluteSize.X, 0, 1)
    sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    followDistance = math.floor(percentage * 20)
    if followDistance < 1 then followDistance = 1 end
    distanceLabel.Text = "Distance: "..followDistance.." studs"
    
    if isFollowing and selectedPlayer then
        followPlayer(selectedPlayer)
    end
end

local function updateDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

-- slider handling
sliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        updateSlider(input)
        
        local connection
        connection = UserInputService.InputChanged:Connect(function(changedInput)
            if changedInput.UserInputType == Enum.UserInputType.MouseMovement and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                updateSlider(changedInput)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(endedInput)
            if endedInput.UserInputType == Enum.UserInputType.MouseButton1 then
                if connection then
                    connection:Disconnect()
                end
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Minimize
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        contentFrame.Visible = false
        mainFrame.Size = minimizedSize
        minimizeButton.Text = "+"
    else
        contentFrame.Visible = true
        mainFrame.Size = originalSize
        minimizeButton.Text = "-"
    end
end)

local function updateSlider(input)
    local relativeX = input.Position.X - mobDistanceSlider.AbsolutePosition.X
    local percentage = math.clamp(relativeX / mobDistanceSlider.AbsoluteSize.X, 0, 1)
    mobSliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    MobfollowDistance = math.floor(percentage * 20)
    if MobfollowDistance < 1 then MobfollowDistance = 1 end
    mobDistanceLabel.Text = "Mob Distance: "..MobfollowDistance.." studs"
    
    if isFollowing and selectedPlayer then
        followPlayer(selectedPlayer)
    end
end

local function updateDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

-- Mob slider handling
mobSliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        updateSlider(input)
        
        local connection
        connection = UserInputService.InputChanged:Connect(function(changedInput)
            if changedInput.UserInputType == Enum.UserInputType.MouseMovement and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                updateSlider(changedInput)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(endedInput)
            if endedInput.UserInputType == Enum.UserInputType.MouseButton1 then
                if connection then
                    connection:Disconnect()
                end
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Minimize
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        contentFrame.Visible = false
        mainFrame.Size = minimizedSize
        minimizeButton.Text = "+"
    else
        contentFrame.Visible = true
        mainFrame.Size = originalSize
        minimizeButton.Text = "-"
    end
end)



-- update player list
local function updatePlayerList()
    -- clear existing list
    for _, child in ipairs(dropdownList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- get all players and sort alphabetically
    local playersList = Players:GetPlayers()
    table.sort(playersList, function(a, b)
        return a.Name < b.Name
    end)
    
    -- create list items
    local listHeight = 0
    for i, player in ipairs(playersList) do
        if player ~= localPlayer then
            local listItem = Instance.new("TextButton")
            listItem.Name = player.Name
            listItem.Size = UDim2.new(1, -8, 0, 25)
            listItem.Position = UDim2.new(0, 4, 0, (i - 1) * 25)
            listItem.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            listItem.BorderSizePixel = 0
            listItem.TextColor3 = Color3.fromRGB(255, 255, 255)
            listItem.TextSize = 14
            listItem.Font = Enum.Font.SourceSans
            listItem.Text = player.Name
            listItem.Parent = dropdownList
            
            listItem.MouseButton1Click:Connect(function()
                selectedPlayer = player
                dropdownText.Text = player.Name
                dropdownList.Visible = false
                
                -- Disable other modes when manual selection is made
                if isRandomMode then
                    toggleRandomMode(false)
                end
                
                if isHealthMode then
                    toggleHealthMode(false)
                end
                
                if isFollowing then
                    followPlayer(player)
                end
            end)
            
            listHeight = listHeight + 25
        end
    end
    
    dropdownList.CanvasSize = UDim2.new(0, 0, 0, listHeight)
end

dropdownButton.MouseButton1Click:Connect(function()
    updatePlayerList()
    dropdownList.Visible = not dropdownList.Visible
end)

-- random player
local function getRandomPlayer()
    local playersList = Players:GetPlayers()
    local validPlayers = {}
    
    for _, player in ipairs(playersList) do
        if player ~= localPlayer then
            table.insert(validPlayers, player)
        end
    end
    
    if #validPlayers > 0 then
        return validPlayers[math.random(1, #validPlayers)]
    else
        return nil
    end
end

-- Get the player with lowest health (above 0)
local function getLowestHealthPlayer()
    local playersList = Players:GetPlayers()
    local lowestPlayer = nil
    local lowestHealth = math.huge
    
    for _, player in ipairs(playersList) do
        if player ~= localPlayer then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 and humanoid.Health < lowestHealth then
                    lowestHealth = humanoid.Health
                    lowestPlayer = player
                end
            end
        end
    end
    
    return lowestPlayer
end

local function calculateFollowPosition(targetCFrame)
    local position
    local lookDirection
    
    if followMode == "Behind" then
        position = targetCFrame.Position - (targetCFrame.LookVector * followDistance)
        lookDirection = targetCFrame.Position
    elseif followMode == "Above" then
        position = targetCFrame.Position + Vector3.new(0, followDistance, 0)
        lookDirection = targetCFrame.Position 
    elseif followMode == "Below" then
        position = targetCFrame.Position - Vector3.new(0, followDistance, 0)
        lookDirection = targetCFrame.Position
    end
    
    return position, lookDirection
end


local function followPlayer(player)
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    
    if player and isFollowing then
        followConnection = RunService.RenderStepped:Connect(function()
            local character = localPlayer.Character
            local targetCharacter = player.Character
            
            if character and targetCharacter then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                local targetRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
                
                if humanoidRootPart and targetRootPart then
                    local followPosition, lookTarget = calculateFollowPosition(targetRootPart.CFrame)
                    
                    lastPosition = humanoidRootPart.Position
                    
                    local lookVector = (lookTarget - followPosition).Unit
                    local newCFrame = CFrame.new(followPosition, lookTarget)
                    
                    humanoidRootPart.CFrame = newCFrame
                end
            end
        end)
    else
        if lastPosition and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        end
    end
end

-- Toggle random mode
local function toggleRandomMode(enable)
    isRandomMode = enable
    
    if isRandomMode then
        randomButton.Text = "Stop Random Mode"
        randomButton.BackgroundColor3 = Color3.fromRGB(180, 40, 180)
        
        -- Disable manual selection and health mode
        if not isFollowing then
            toggleButton.MouseButton1Click:Fire()
        end
        
        if isHealthMode then
            toggleHealthMode(false)
        end
        
        -- Start random player timer
        randomModeTimer = coroutine.wrap(function()
            while isRandomMode and isFollowing do
                local randomPlayer = getRandomPlayer()
                if randomPlayer then
                    selectedPlayer = randomPlayer
                    dropdownText.Text = randomPlayer.Name
                    followPlayer(randomPlayer)
                end
                wait(3) -- Wait 3 seconds before switching
            end
        end)
        randomModeTimer()
    else
        randomButton.Text = "Random Player Mode"
        randomButton.BackgroundColor3 = Color3.fromRGB(120, 40, 120)
        -- Random mode timer will stop naturally in its next iteration
    end
end

-- Toggle health mode
local function toggleHealthMode(enable)
    isHealthMode = enable
    
    if isHealthMode then
        healthButton.Text = "Stop Health Mode"
        healthButton.BackgroundColor3 = Color3.fromRGB(220, 120, 40)
        
        -- Disable manual selection and random mode
        if not isFollowing then
            toggleButton.MouseButton1Click:Fire()
        end
        
        if isRandomMode then
            toggleRandomMode(false)
        end
        
        -- Start health mode timer
        healthModeTimer = coroutine.wrap(function()
            while isHealthMode and isFollowing do
                local lowestPlayer = getLowestHealthPlayer()
                if lowestPlayer then
                    selectedPlayer = lowestPlayer
                    dropdownText.Text = lowestPlayer.Name.. " (Lowest HP)"
                    followPlayer(lowestPlayer)
                end
                wait(1) -- Check more frequently
            end
        end)
        healthModeTimer()
    else
        healthButton.Text = "Lowest Health Mode"
        healthButton.BackgroundColor3 = Color3.fromRGB(180, 120, 40)
        -- Health mode timer will stop naturally in its next iteration
    end
end

-- Auto Click function
local function toggleAutoClick(enable)
    isAutoClicking = enable
    
    if isAutoClicking then
        autoClickButton.Text = "Stop Auto Click [V]"
        autoClickButton.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
        
        -- Start auto clicking
        autoClickConnection = RunService.RenderStepped:Connect(function()
            if isAutoClicking then
                mouse1press()
                wait(0.1) -- Click delay
                mouse1release()
                wait(0.1) -- Release delay
            end
        end)
    else
        autoClickButton.Text = "Auto Click [V]"
        autoClickButton.BackgroundColor3 = Color3.fromRGB(40, 40, 120)
        
        -- Stop auto clicking
        if autoClickConnection then
            autoClickConnection:Disconnect()
            autoClickConnection = nil
        end
    end
end

local function stopScript()
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    isRunning = false
    mobAutoFarmButton.Text = "Mob Auto Farm (OFF)"
    mobAutoFarmButton.BackgroundColor3 = Color3.fromRGB(120, 40, 40)  -- Reddish color for OFF state
end


-- Function to start the script
local function startScript()
    if isRunning then return end
    isRunning = true
    mobAutoFarmButton.Text = "Mob Auto Farm (ON)"
    mobAutoFarmButton.BackgroundColor3 = Color3.fromRGB(40, 120, 40)  -- Greenish color for ON state

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local RunService = game:GetService("RunService")
    local HIT_RANGE = 10


    local function isMobAlive(mob)
        local humanoid = mob:FindFirstChildOfClass("Humanoid")
        return humanoid and humanoid.Health > 0
    end

     for _, target in ipairs(workspace.Characters:GetChildren()) do
        -- Ensure the target is not the player's own character
        if target ~= character and target:IsA("Model") and target:FindFirstChild("HumanoidRootPart") and isTargetAlive(target) then
            local dist = (target.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
            if dist < closestDistance then
                closestDistance = dist
                closestTarget = target
            end
        end
    end

    return closestTarget
end

    local function calculateFollowPosition(targetCFrame)
        local position
        local lookDirection

        if followMode == "Behind" then
            -- Position behind the mob
            position = targetCFrame.Position - (targetCFrame.LookVector * MobfollowDistance)
            lookDirection = targetCFrame.Position
        elseif followMode == "Above" then
            -- Position above the mob
            position = targetCFrame.Position + Vector3.new(0, MobfollowDistance, 0)
            lookDirection = targetCFrame.Position
        elseif followMode == "Below" then
            -- Position below the mob
            position = targetCFrame.Position - Vector3.new(0, MobfollowDistance, 0)
            lookDirection = targetCFrame.Position
        end

        return position, lookDirection
    end

    local function followMob(mob)
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end

    if mob and isRunning then
        followConnection = RunService.RenderStepped:Connect(function()
            local character = player.Character
            local targetCharacter = mob

            if character and targetCharacter then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                local targetRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")

                if humanoidRootPart and targetRootPart then
                    -- Calculate the follow position and look direction
                    local followPosition, lookTarget = calculateFollowPosition(targetRootPart.CFrame)

                    -- Prevent glitching under the map
                    if followPosition.Y < 0 then
                        followPosition = Vector3.new(followPosition.X, 10, followPosition.Z)
                    end

                    -- Smoothly move the player to the new position using Lerp
                    local newCFrame = CFrame.new(followPosition, lookTarget)
                    humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(newCFrame, 0.1) -- Adjust the Lerp weight (0.1) for smoother movement
                end
            end
        end)
    end
end

    local function moveToNextMob()
        while isRunning do
            local mob = getClosestMob()
            if mob then
                if (mob.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude > HIT_RANGE then
                    followMob(mob)
                end
                while mob and isMobAlive(mob) do
                    task.wait(0.1)
                end
            else
                print("No mobs found! Retrying in 5 seconds...")
                task.wait(2)
            end
        end
    end

    -- Start the process
    moveToNextMob()
end

-- Toggle the script on button click
mobAutoFarmButton.MouseButton1Click:Connect(function()
    if isRunning then
        stopScript()
    else
        startScript()
    end
end)










-- Toggle button functionality
toggleButton.MouseButton1Click:Connect(function()
    if not selectedPlayer and not isRandomMode and not isHealthMode then
        dropdownText.Text = "Please select a player"
        return
    end
    
    isFollowing = not isFollowing
    
    if isFollowing then
        toggleButton.Text = "Stop Following"
        toggleButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        followPlayer(selectedPlayer)
        
        -- Restart mode timers if they were active
        if isRandomMode then
            toggleRandomMode(true)
        end
        
        if isHealthMode then
            toggleHealthMode(true)
        end
    else
        toggleButton.Text = "Start Following"
        toggleButton.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
        followPlayer(nil)
    end
end)

randomButton.MouseButton1Click:Connect(function()
    toggleRandomMode(not isRandomMode)
end)

healthButton.MouseButton1Click:Connect(function()
    toggleHealthMode(not isHealthMode)
end)

autoClickButton.MouseButton1Click:Connect(function()
    toggleAutoClick(not isAutoClicking)
end)

-- KEYBIND AUTO CLICK
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.V then
        toggleAutoClick(not isAutoClicking)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if player == selectedPlayer and not isRandomMode and not isHealthMode then
        isFollowing = false
        selectedPlayer = nil
        dropdownText.Text = "Select Player"
        toggleButton.Text = "Start Following"
        toggleButton.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
        followPlayer(nil)
    end
    
    updatePlayerList()
end)

Players.PlayerAdded:Connect(function()
    updatePlayerList()
end)

updatePlayerList()

if game:GetService("RunService"):IsStudio() then
    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
else
    screenGui.Parent = game:GetService("CoreGui")
end
