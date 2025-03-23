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
local TweenService = game:GetService("TweenService")


local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FollowPlayerGui"
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 550)
mainFrame.Position = UDim2.new(0, 10, 1, -550) -- Adjusted Y position to match new height
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

-- Difficulty Dropdown frame
local difficultyDropdownFrame = Instance.new("Frame")
difficultyDropdownFrame.Name = "DifficultyDropdownFrame"
difficultyDropdownFrame.Size = UDim2.new(0.9, 0, 0, 30)
difficultyDropdownFrame.Position = UDim2.new(0.05, 0, 0.13, 0)
difficultyDropdownFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
difficultyDropdownFrame.BorderSizePixel = 0
difficultyDropdownFrame.Parent = contentFrame

-- Difficulty Dropdown text
local difficultyDropdownText = Instance.new("TextLabel")
difficultyDropdownText.Name = "DifficultyDropdownText"
difficultyDropdownText.Size = UDim2.new(1, 0, 1, 0)
difficultyDropdownText.BackgroundTransparency = 1
difficultyDropdownText.TextColor3 = Color3.fromRGB(255, 255, 255)
difficultyDropdownText.TextSize = 14
difficultyDropdownText.Font = Enum.Font.SourceSans
difficultyDropdownText.Text = "Select Difficulty"
difficultyDropdownText.Parent = difficultyDropdownFrame

-- Difficulty Dropdown button
local difficultyDropdownButton = Instance.new("TextButton")
difficultyDropdownButton.Name = "DifficultyDropdownButton"
difficultyDropdownButton.Size = UDim2.new(1, 0, 1, 0)
difficultyDropdownButton.BackgroundTransparency = 1
difficultyDropdownButton.TextTransparency = 1
difficultyDropdownButton.Text = ""
difficultyDropdownButton.Parent = difficultyDropdownFrame

-- Difficulty Dropdown list
local difficultyDropdownList = Instance.new("ScrollingFrame")
difficultyDropdownList.Name = "DifficultyDropdownList"
difficultyDropdownList.Size = UDim2.new(1, 0, 0, 100)
difficultyDropdownList.Position = UDim2.new(0, 0, -1, -100)
difficultyDropdownList.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
difficultyDropdownList.BorderSizePixel = 0
difficultyDropdownList.ScrollBarThickness = 4
difficultyDropdownList.Visible = false
difficultyDropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
difficultyDropdownList.Parent = difficultyDropdownFrame

-- Dungeon Dropdown frame
local dungeonDropdownFrame = Instance.new("Frame")
dungeonDropdownFrame.Name = "DungeonDropdownFrame"
dungeonDropdownFrame.Size = UDim2.new(0.9, 0, 0, 30)
dungeonDropdownFrame.Position = UDim2.new(0.05, 0, 0.21, 0)
dungeonDropdownFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dungeonDropdownFrame.BorderSizePixel = 0
dungeonDropdownFrame.Parent = contentFrame

-- Dungeon Dropdown text
local dungeonDropdownText = Instance.new("TextLabel")
dungeonDropdownText.Name = "DungeonDropdownText"
dungeonDropdownText.Size = UDim2.new(1, 0, 1, 0)
dungeonDropdownText.BackgroundTransparency = 1
dungeonDropdownText.TextColor3 = Color3.fromRGB(255, 255, 255)
dungeonDropdownText.TextSize = 14
dungeonDropdownText.Font = Enum.Font.SourceSans
dungeonDropdownText.Text = "Select Dungeon"
dungeonDropdownText.Parent = dungeonDropdownFrame

-- Dungeon Dropdown button
local dungeonDropdownButton = Instance.new("TextButton")
dungeonDropdownButton.Name = "DungeonDropdownButton"
dungeonDropdownButton.Size = UDim2.new(1, 0, 1, 0)
dungeonDropdownButton.BackgroundTransparency = 1
dungeonDropdownButton.TextTransparency = 1
dungeonDropdownButton.Text = ""
dungeonDropdownButton.Parent = dungeonDropdownFrame

-- Dungeon Dropdown list
local dungeonDropdownList = Instance.new("ScrollingFrame")
dungeonDropdownList.Name = "DungeonDropdownList"
dungeonDropdownList.Size = UDim2.new(1, 0, 0, 100)
dungeonDropdownList.Position = UDim2.new(0, 0, -1, -100)
dungeonDropdownList.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dungeonDropdownList.BorderSizePixel = 0
dungeonDropdownList.ScrollBarThickness = 4
dungeonDropdownList.Visible = false
dungeonDropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
dungeonDropdownList.Parent = dungeonDropdownFrame

-- Existing frame/text/button/list creation code remains identical to your original script

-- Dropdown Logic (modified)
local function toggleDropdown(dropdownList)
    dropdownList.Visible = not dropdownList.Visible
end

local function createDropdownOption(parent, text, callback)
    local optionButton = Instance.new("TextButton")
    optionButton.Name = text .. "Option"
    optionButton.Size = UDim2.new(1, 0, 0, 30)
    optionButton.Position = UDim2.new(0, 0, 0, #parent:GetChildren() * 30)
    optionButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    optionButton.BorderSizePixel = 0
    optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    optionButton.TextSize = 14
    optionButton.Font = Enum.Font.SourceSans
    optionButton.Text = text
    optionButton.Parent = parent

    optionButton.MouseButton1Click:Connect(function()
        callback(text)  -- Only update text, don't close dropdown
    end)
end

-- Difficulty Dropdown
difficultyDropdownButton.MouseButton1Click:Connect(function()
    toggleDropdown(difficultyDropdownList)
    -- Close other dropdown when opening this one
    if dungeonDropdownList.Visible then
        toggleDropdown(dungeonDropdownList)
    end
end)

-- Dungeon Dropdown
dungeonDropdownButton.MouseButton1Click:Connect(function()
    toggleDropdown(dungeonDropdownList)
    -- Close other dropdown when opening this one
    if difficultyDropdownList.Visible then
        toggleDropdown(difficultyDropdownList)
    end
end)

-- Close dropdowns when clicking outside
local function handleOutsideClick(inputObject)
    if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
        local absPos = difficultyDropdownList.AbsolutePosition
        local absSize = difficultyDropdownList.AbsoluteSize
        local mousePos = inputObject.Position
        
        if not (mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X
            and mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y) then
            difficultyDropdownList.Visible = false
        end
        
        absPos = dungeonDropdownList.AbsolutePosition
        absSize = dungeonDropdownList.AbsoluteSize
        if not (mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X
            and mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y) then
            dungeonDropdownList.Visible = false
        end
    end
end

game:GetService("UserInputService").InputBegan:Connect(handleOutsideClick)

-- Example Options (unchanged)
local difficulties = {"Easy", "Medium", "Hard"}
local dungeons = {"Orc Lands", "Dungeon 2", "Dungeon 3"}

for _, difficulty in ipairs(difficulties) do
    createDropdownOption(difficultyDropdownList, difficulty, function(selected)
        difficultyDropdownText.Text = "Difficulty: " .. selected
        difficulties = selected
    end)
end

for _, dungeon in ipairs(dungeons) do
    createDropdownOption(dungeonDropdownList, dungeon, function(selected)
        dungeonDropdownText.Text = "Dungeon: " .. selected
        dungeons = selected
    end)
end

-- Distance slider label
local distanceLabel = Instance.new("TextLabel")
distanceLabel.Name = "DistanceLabel"
distanceLabel.Size = UDim2.new(0.9, 0, 0, 20)
distanceLabel.Position = UDim2.new(0.05, 0, 0.3, 0) -- Adjusted Y position
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
distanceSlider.Position = UDim2.new(0.05, 0, 0.35, 0) -- Adjusted Y position
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

-- Mob Distance slider label
local mobDistanceLabel = Instance.new("TextLabel")
mobDistanceLabel.Name = "MobDistanceLabel"
mobDistanceLabel.Size = UDim2.new(0.9, 0, 0, 20)
mobDistanceLabel.Position = UDim2.new(0.05, 0, 0.4, 0) -- Adjusted Y position
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
mobDistanceSlider.Position = UDim2.new(0.05, 0, 0.45, 0) -- Adjusted Y position
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
modeLabel.Position = UDim2.new(0.05, 0, 0.5, 0) -- Adjusted Y position
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
    button.Position = UDim2.new(0.05 + (i-1) * 0.31, 0, 0.55, 0) -- Adjusted Y position
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

-- Red Square Button with "AD" Text
local redSquareButton = Instance.new("TextButton")
redSquareButton.Name = "RedSquareButton"
redSquareButton.Size = UDim2.new(0.2, 0, 0.08, 0) -- Square size (10% of parent width and height)
redSquareButton.Position = UDim2.new(0.05, 0, 0.61, 0) -- Positioned above the Start Following button
redSquareButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red color
redSquareButton.BorderSizePixel = 0
redSquareButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
redSquareButton.TextSize = 14
redSquareButton.Font = Enum.Font.SourceSansBold
redSquareButton.Text = "AD" -- Text added
redSquareButton.TextXAlignment = Enum.TextXAlignment.Center -- Center text horizontally
redSquareButton.TextYAlignment = Enum.TextYAlignment.Center -- Center text vertically
redSquareButton.Parent = contentFrame

-- Red Square Button with "AD" Text
local redSquareButtonTwo = Instance.new("TextButton")
redSquareButtonTwo.Name = "RedSquareButton"
redSquareButtonTwo.Size = UDim2.new(0.2, 0, 0.08, 0) -- Square size (10% of parent width and height)
redSquareButtonTwo.Position = UDim2.new(0.35, 0, 0.61, 0) -- Positioned above the Start Following button
redSquareButtonTwo.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red color
redSquareButtonTwo.BorderSizePixel = 0
redSquareButtonTwo.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
redSquareButtonTwo.TextSize = 14
redSquareButtonTwo.Font = Enum.Font.SourceSansBold
redSquareButtonTwo.Text = "AB" -- Text added
redSquareButtonTwo.TextXAlignment = Enum.TextXAlignment.Center -- Center text horizontally
redSquareButtonTwo.TextYAlignment = Enum.TextYAlignment.Center -- Center text vertically
redSquareButtonTwo.Parent = contentFrame

-- Red Square Button with "AD" Text
local redSquareButtonThree = Instance.new("TextButton")
redSquareButtonThree.Name = "RedSquareButton"
redSquareButtonThree.Size = UDim2.new(0.2, 0, 0.08, 0) -- Square size (10% of parent width and height)
redSquareButtonThree.Position = UDim2.new(0.65, 0, 0.61, 0) -- Positioned above the Start Following button
redSquareButtonThree.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red color
redSquareButtonThree.BorderSizePixel = 0
redSquareButtonThree.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
redSquareButtonThree.TextSize = 14
redSquareButtonThree.Font = Enum.Font.SourceSansBold
redSquareButtonThree.Text = "CP" -- Text added
redSquareButtonThree.TextXAlignment = Enum.TextXAlignment.Center -- Center text horizontally
redSquareButtonThree.TextYAlignment = Enum.TextYAlignment.Center -- Center text vertically
redSquareButtonThree.Parent = contentFrame

-- Function to change the button color to green and run the scripts
redSquareButton.MouseButton1Click:Connect(function()
    redSquareButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green color

    -- Create dungeon group with selected values
    local args = {
    [1] = {
        ["Location"] = dungeons;
        ["GroupType"] = "Private";
        ["Difficult"] = difficulties;
        ["Invasions"] = false;
    };
}
game:GetService("ReplicatedStorage"):WaitForChild("Events", 9e9):WaitForChild("CreateDungeonGroup", 9e9):FireServer(unpack(args))

    -- Start dungeon group
  local args = {
    [1] = "Forward";
}
game:GetService("ReplicatedStorage"):WaitForChild("Events", 9e9):WaitForChild("StartDungeonGroup", 9e9):FireServer(unpack(args))
print(dungeons)
print(difficulties)
end)

local isRed = true -- Track the current state of the button
local heartbeatConnection = nil -- Connection for the second script
local isBlocking = false -- Track the blocking state

-- Function to start the second script
local function startSecondScript()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local blockingFrame = player.PlayerGui.ScreenInfo.Blocking

    local RunService = game:GetService("RunService")
    local BLOCK_RANGE = 5
    local enemiesInRange = {}

    local function invokeBlocking()
        local args = { [1] = "Blocking" }
        game:GetService("ReplicatedStorage"):WaitForChild("Events", 9e9):WaitForChild("Blocking", 9e9):InvokeServer(unpack(args))
    end

    local function invokeUnBlocking()
        local args = { [1] = "UnBlocking" }
        game:GetService("ReplicatedStorage"):WaitForChild("Events", 9e9):WaitForChild("Blocking", 9e9):InvokeServer(unpack(args))
    end

    local function cleanupEnemies()
        for enemy in pairs(enemiesInRange) do
            if not enemy.Parent or not enemy:IsDescendantOf(workspace) then
                enemiesInRange[enemy] = nil
            end
        end
    end

    local function checkEnemies()
        cleanupEnemies()
        
        local anyInRange = false
        for _, enemy in ipairs(workspace.Characters:GetChildren()) do
            if enemy ~= character and enemy:IsA("Model") then
                local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
                if enemyRoot and (rootPart.Position - enemyRoot.Position).Magnitude <= BLOCK_RANGE then
                    enemiesInRange[enemy] = true
                    anyInRange = true
                end
            end
        end
        
        if anyInRange and not isBlocking then
            invokeBlocking()
            isBlocking = true
            blockingFrame.Visible = true
        elseif not anyInRange and isBlocking then
            invokeUnBlocking()
            isBlocking = false
            blockingFrame.Visible = false
        end
    end

    heartbeatConnection = RunService.Heartbeat:Connect(checkEnemies)

    character.Destroying:Connect(function()
        if heartbeatConnection then
            heartbeatConnection:Disconnect()
        end
        if isBlocking then
            invokeUnBlocking()
        end
    end)
end

-- Function to stop the second script
local function stopSecondScript()
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
    if isBlocking then
        invokeUnBlocking()
        isBlocking = false
    end
end

-- Toggle button color and start/stop the second script
redSquareButtonTwo.MouseButton1Click:Connect(function()
    if isRed then
        redSquareButtonTwo.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Change to green
        startSecondScript() -- Start the second script
    else
        redSquareButtonTwo.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Change back to red
        stopSecondScript() -- Stop the second script
    end
    isRed = not isRed -- Toggle the state
end)



local isRedThree = true -- Track the current state of the button
local isTeleportEnabled = false -- Track whether teleportation is enabled

redSquareButtonThree.MouseButton1Click:Connect(function()
    -- Toggle button color
    isRedThree = not isRedThree
    redSquareButtonThree.BackgroundColor3 = isRedThree and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)

    -- Toggle teleportation logic
    isTeleportEnabled = not isTeleportEnabled

    -- Run the second script only if teleportation is enabled
    if isTeleportEnabled then
        local plr = game:GetService("Players").LocalPlayer
        local tween_s = game:GetService("TweenService")
        local info = TweenInfo.new(3, Enum.EasingStyle.Quad)

        local debounce = false -- Prevents multiple simultaneous tweens

        -- Enhanced tween function with completion tracking
        function tp(cframe)
            if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                warn("Character or HumanoidRootPart missing")
                return
            end
            
            local success, err = pcall(function()
                local tween = tween_s:Create(plr.Character.HumanoidRootPart, info, {CFrame = cframe})
                debounce = true
                tween.Completed:Connect(function()
                    debounce = false
                end)
                tween:Play()
            end)
            
            if not success then
                warn("Tween error: " .. err)
                debounce = false
            end
        end

        -- Main monitoring loop
        while isTeleportEnabled do
            task.wait(0.1) -- Non-blocking wait
            
            if not debounce then
                -- Check character validity
                if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                    local humanoid = plr.Character.Humanoid
                    
                    -- Health check
                    if humanoid.Health < 30 then
                        -- Find target structure
                        local target
                        local tower = workspace:FindFirstChild("Tower")
                        
                        if tower then
                            local startRoom = tower:FindFirstChild("StartRoom")
                            if startRoom then
                                local campfire = startRoom:FindFirstChild("Campfire")
                                if campfire then
                                    target = campfire:FindFirstChild("Rocks")
                                end
                            end
                        end

                        -- Tween if target found
                        if target then
                            -- Get the CFrame of the rocks and adjust it to be 10 studs higher
                            local targetCFrame = target:GetPivot()
                            local adjustedCFrame = targetCFrame + Vector3.new(0, 3, 0) -- Move 10 studs up on the Y-axis
                            tp(adjustedCFrame)
                        else
                            warn("Target rocks not found!")
                        end
                    end
                end
            end
        end
    end
end)
-- Start/Stop Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0.9, 0, 0, 30)
toggleButton.Position = UDim2.new(0.05, 0, 0.7, 0) -- Adjusted Y position
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
randomButton.Position = UDim2.new(0.05, 0, 0.76, 0) -- Slightly increased Y position
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
healthButton.Position = UDim2.new(0.05, 0, 0.82, 0) -- Slightly increased Y position
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
autoClickButton.Position = UDim2.new(0.05, 0, 0.88, 0) -- Slightly increased Y position
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
mobAutoFarmButton.Position = UDim2.new(0.05, 0, 0.94, 0) -- Slightly increased Y position
mobAutoFarmButton.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
mobAutoFarmButton.BorderSizePixel = 0
mobAutoFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mobAutoFarmButton.TextSize = 14
mobAutoFarmButton.Font = Enum.Font.SourceSansBold
mobAutoFarmButton.Text = "Mob Auto Farm"
mobAutoFarmButton.Parent = contentFrame-- Start/Stop Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0.9, 0, 0, 30)
toggleButton.Position = UDim2.new(0.05, 0, 0.7, 0) -- Adjusted Y position
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
randomButton.Position = UDim2.new(0.05, 0, 0.76, 0) -- Slightly increased Y position
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
healthButton.Position = UDim2.new(0.05, 0, 0.82, 0) -- Slightly increased Y position
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
autoClickButton.Position = UDim2.new(0.05, 0, 0.88, 0) -- Slightly increased Y position
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
mobAutoFarmButton.Position = UDim2.new(0.05, 0, 0.94, 0) -- Slightly increased Y position
mobAutoFarmButton.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
mobAutoFarmButton.BorderSizePixel = 0
mobAutoFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mobAutoFarmButton.TextSize = 14
mobAutoFarmButton.Font = Enum.Font.SourceSansBold
mobAutoFarmButton.Text = "Mob Auto Farm"
mobAutoFarmButton.Parent = contentFrame


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

-- Function to change HoldDuration of ProximityPrompts
local function changeProximityPrompts(proximityPrompt)
    -- Check if the child is a ProximityPrompt
    if proximityPrompt:IsA("ProximityPrompt") then
        -- Change HoldDuration to 0
        proximityPrompt.HoldDuration = 0
    end
end

-- Function to set up the listener for new ProximityPrompts
local function setupProximityPromptListener(tower)
    -- Loop through existing children first
    for _, child in ipairs(tower:GetDescendants()) do
        changeProximityPrompts(child)
    end

    -- Listen for new children being added
    tower.DescendantAdded:Connect(function(child)
        changeProximityPrompts(child)
    end)
end

-- Get the Tower model in workspace
local tower = workspace:FindFirstChild("Tower")

if tower then
    -- Set up the listener for new ProximityPrompts
    setupProximityPromptListener(tower)
else
    warn("Tower not found in workspace!")
end

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

-- Top-level declarations
local isRunning = false
local followConnection = nil

-- Function to stop the script
local function stopScript()
    if not isRunning then return end  -- Reversed condition
    isRunning = false
    mobAutoFarmButton.Text = "Mob Auto Farm (OFF)"
    mobAutoFarmButton.BackgroundColor3 = Color3.fromRGB(120, 40, 40)

    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
end

-- Function to start the script
local function startScript()
    if isRunning then return end
    isRunning = true
    mobAutoFarmButton.Text = "Mob Auto Farm (ON)"
    mobAutoFarmButton.BackgroundColor3 = Color3.fromRGB(40, 120, 40)

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")

    local function isMobAlive(mob)
        local humanoid = mob:FindFirstChildOfClass("Humanoid")
        return humanoid and humanoid.Health > 0
    end

    local function getClosestCharacter()
        local closestCharacter = nil
        local closestDistance = math.huge
        
        for _, otherCharacter in ipairs(workspace.Characters:GetChildren()) do
            if otherCharacter ~= character then
                local targetRootPart = otherCharacter:FindFirstChild("HumanoidRootPart")
                if targetRootPart then
                    local distance = (humanoidRootPart.Position - targetRootPart.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestCharacter = otherCharacter
                    end
                end
            end
        end
        
        return closestCharacter
    end

    local function calculateFollowPosition(targetCFrame)
        local position
        local lookDirection

        if followMode == "Behind" then
            position = targetCFrame.Position - (targetCFrame.LookVector * MobfollowDistance)
            lookDirection = targetCFrame.Position
        elseif followMode == "Above" then
            position = targetCFrame.Position + Vector3.new(0, MobfollowDistance, 0)
            lookDirection = targetCFrame.Position
        elseif followMode == "Below" then
            position = targetCFrame.Position - Vector3.new(0, MobfollowDistance, 0)
            lookDirection = targetCFrame.Position
        end

        return position, lookDirection
    end

    local function followCharacter(targetCharacter)
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
        
        if targetCharacter and isRunning then
            followConnection = RunService.RenderStepped:Connect(function()
                if not isRunning then return end  -- Added check
                local targetRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
                if targetRootPart then
                    local followPosition, lookTarget = calculateFollowPosition(targetRootPart.CFrame)
                    local lookVector = (lookTarget - followPosition).Unit
                    local newCFrame = CFrame.new(followPosition, lookTarget)
                    
                    humanoidRootPart.CFrame = newCFrame
                end
            end)
        end
    end

    local function moveToNextCharacter()
        while isRunning do  -- Added condition check
            local targetCharacter = getClosestCharacter()
            if targetCharacter then
                followCharacter(targetCharacter)
                while targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") and isRunning do
                    task.wait(0.1)
                end
            else
                task.wait(1)
            end
        end
    end

    moveToNextCharacter()
end

-- Toggle the script
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
