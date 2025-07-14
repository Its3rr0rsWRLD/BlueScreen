local gameId = game.PlaceId or game.GameId

local function createDiscordPopup()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BlueScreenDiscordPopup"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 420, 0, 240)
    mainFrame.Position = UDim2.new(0.5, -210, 0.5, -120)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.ZIndex = 10
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(35, 40, 50)
    stroke.Thickness = 1
    stroke.Parent = mainFrame
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 21, 28)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 15, 22))
    }
    gradient.Rotation = 90
    gradient.Parent = mainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, -40, 0, 35)
    titleLabel.Position = UDim2.new(0, 20, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "BlueScreen"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 24
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.ZIndex = 12
    titleLabel.Parent = mainFrame
    
    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Name = "SubtitleLabel"
    subtitleLabel.Size = UDim2.new(1, -40, 0, 16)
    subtitleLabel.Position = UDim2.new(0, 20, 0, 55)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Text = "SCRIPT HUB"
    subtitleLabel.TextColor3 = Color3.fromRGB(120, 130, 140)
    subtitleLabel.TextSize = 12
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Center
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.ZIndex = 12
    subtitleLabel.Parent = mainFrame
    
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(0, 120, 0, 1)
    divider.Position = UDim2.new(0.5, -60, 0, 80)
    divider.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
    divider.BorderSizePixel = 0
    divider.ZIndex = 12
    divider.Parent = mainFrame
    
    local discordTitle = Instance.new("TextLabel")
    discordTitle.Name = "DiscordTitle"
    discordTitle.Size = UDim2.new(1, -40, 0, 24)
    discordTitle.Position = UDim2.new(0, 20, 0, 95)
    discordTitle.BackgroundTransparency = 1
    discordTitle.Text = "Join Our Community"
    discordTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordTitle.TextSize = 18
    discordTitle.TextXAlignment = Enum.TextXAlignment.Center
    discordTitle.Font = Enum.Font.GothamBold
    discordTitle.ZIndex = 12
    discordTitle.Parent = mainFrame
    
    local descriptionLabel = Instance.new("TextLabel")
    descriptionLabel.Name = "DescriptionLabel"
    descriptionLabel.Size = UDim2.new(1, -40, 0, 60)
    descriptionLabel.Position = UDim2.new(0, 20, 0, 120)
    descriptionLabel.BackgroundTransparency = 1
    descriptionLabel.Text = "We spend hours developing and maintaining this script hub. We ask that you would PLEASE join our discord. You can get early access to new features, suggest games, and be part of our community!"
    descriptionLabel.TextColor3 = Color3.fromRGB(160, 170, 180)
    descriptionLabel.TextSize = 14
    descriptionLabel.TextWrapped = true
    descriptionLabel.TextXAlignment = Enum.TextXAlignment.Center
    descriptionLabel.Font = Enum.Font.Gotham
    descriptionLabel.ZIndex = 12
    descriptionLabel.Parent = mainFrame
    
    local joinButton = Instance.new("TextButton")
    joinButton.Name = "JoinButton"
    joinButton.Size = UDim2.new(0, 160, 0, 32)
    joinButton.Position = UDim2.new(0, 30, 0, 190)
    joinButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    joinButton.BorderSizePixel = 0
    joinButton.Text = "Join Discord"
    joinButton.TextColor3 = Color3.new(1, 1, 1)
    joinButton.TextSize = 14
    joinButton.Font = Enum.Font.GothamSemibold
    joinButton.ZIndex = 12
    joinButton.Parent = mainFrame
    
    local joinCorner = Instance.new("UICorner")
    joinCorner.CornerRadius = UDim.new(0, 4)
    joinCorner.Parent = joinButton
    
    local continueButton = Instance.new("TextButton")
    continueButton.Name = "ContinueButton"
    continueButton.Size = UDim2.new(0, 160, 0, 32)
    continueButton.Position = UDim2.new(1, -190, 0, 190)
    continueButton.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
    continueButton.BorderSizePixel = 0
    continueButton.Text = "Skip"
    continueButton.TextColor3 = Color3.fromRGB(180, 190, 200)
    continueButton.TextSize = 14
    continueButton.Font = Enum.Font.GothamSemibold
    continueButton.ZIndex = 12
    continueButton.Parent = mainFrame
    
    local continueCorner = Instance.new("UICorner")
    continueCorner.CornerRadius = UDim.new(0, 4)
    continueCorner.Parent = continueButton
    
    local function animateIn()
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        mainFrame.BackgroundTransparency = 1
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0, false, 0)
        local sizeTween = TweenService:Create(mainFrame, tweenInfo, {
            Size = UDim2.new(0, 420, 0, 240),
            Position = UDim2.new(0.5, -210, 0.5, -120),
            BackgroundTransparency = 0
        })
        
        sizeTween:Play()
        
        wait(0.15)
        
        local strokeTween = TweenService:Create(stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 0
        })
        strokeTween:Play()
    end
    
    local function animateOut(callback)
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local tween = TweenService:Create(mainFrame, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        })
        
        tween:Play()
        tween.Completed:Connect(function()
            screenGui:Destroy()
            if callback then callback() end
        end)
    end
    
    local function addHoverEffect(button, hoverColor, normalColor)
        button.MouseEnter:Connect(function()
            local scaleTween = TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset + 4, button.Size.Y.Scale, button.Size.Y.Offset + 2)
            })
            scaleTween:Play()
            
            local colorTween = TweenService:Create(button, TweenInfo.new(0.15), {
                BackgroundColor3 = hoverColor
            })
            colorTween:Play()
        end)
        
        button.MouseLeave:Connect(function()
            local scaleTween = TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset - 4, button.Size.Y.Scale, button.Size.Y.Offset - 2)
            })
            scaleTween:Play()
            
            local colorTween = TweenService:Create(button, TweenInfo.new(0.15), {
                BackgroundColor3 = normalColor
            })
            colorTween:Play()
        end)
    end
    
    addHoverEffect(joinButton, Color3.fromRGB(98, 111, 252), Color3.fromRGB(88, 101, 242))
    addHoverEffect(continueButton, Color3.fromRGB(45, 50, 60), Color3.fromRGB(35, 40, 50))
    
    return {
        show = function(onJoin, onContinue)
            animateIn()
            
            joinButton.MouseButton1Click:Connect(function()
                local discordUrl = "https://discord.gg/PJSKe4MKWU"
                
                if setclipboard then
                    setclipboard(discordUrl)
                    
                    local notificationLabel = Instance.new("TextLabel")
                    notificationLabel.Name = "NotificationLabel"
                    notificationLabel.Size = UDim2.new(0, 200, 0, 30)
                    notificationLabel.Position = UDim2.new(0.5, -100, 1, -50)
                    notificationLabel.BackgroundColor3 = Color3.fromRGB(50, 55, 65)
                    notificationLabel.BorderSizePixel = 0
                    notificationLabel.Text = "Discord link copied to clipboard!"
                    notificationLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    notificationLabel.TextScaled = true
                    notificationLabel.Font = Enum.Font.Gotham
                    notificationLabel.ZIndex = 15
                    notificationLabel.Parent = mainFrame
                    
                    local notificationCorner = Instance.new("UICorner")
                    notificationCorner.CornerRadius = UDim.new(0, 6)
                    notificationCorner.Parent = notificationLabel
                    
                    spawn(function()
                        wait(2)
                        local fadeTween = TweenService:Create(notificationLabel, TweenInfo.new(0.3), {
                            BackgroundTransparency = 1,
                            TextTransparency = 1
                        })
                        fadeTween:Play()
                        fadeTween.Completed:Connect(function()
                            notificationLabel:Destroy()
                            animateOut(onJoin)
                        end)
                    end)
                else
                    animateOut(onJoin)
                end
            end)
            
            continueButton.MouseButton1Click:Connect(function()
                animateOut(onContinue)
            end)
        end
    }
end

local function loadScript(url)
    local success, result = pcall(function()
        return game:HttpGet(url, true)
    end)
    
    if success then
        local executeSuccess, executeResult = pcall(function()
            return loadstring(result)()
        end)
        
        if not executeSuccess then
            warn("BlueScreen: Failed to execute script - " .. tostring(executeResult))
        end
    else
        warn("BlueScreen: Failed to load script from " .. url .. " - " .. tostring(result))
    end
end

local function parseRedirector(data)
    local func = loadstring(data)
    if func then
        return func()
    else
        return {}
    end
end

local redirectorUrl = "https://raw.githubusercontent.com/Its3rr0rsWRLD/BlueScreen/main/Redirector.lua"
local hubUrl = "https://raw.githubusercontent.com/Its3rr0rsWRLD/BlueScreen/main/Hub.lua"

local function executeMainScript()
    local success, redirectorData = pcall(function()
        return game:HttpGet(redirectorUrl, true)
    end)

    if success then
        local games = parseRedirector(redirectorData)
        
        if games[gameId] then
            local scriptName = games[gameId]:gsub(" ", "%%20")
            local scriptUrl = "https://raw.githubusercontent.com/Its3rr0rsWRLD/BlueScreen/main/Scripts/" .. scriptName
            loadScript(scriptUrl)
        else
            loadScript(hubUrl)
        end
    else
        loadScript(hubUrl)
    end
end

local popup = createDiscordPopup()
popup.show(
    function()
        executeMainScript()
    end,
    function()
        executeMainScript()
    end
)