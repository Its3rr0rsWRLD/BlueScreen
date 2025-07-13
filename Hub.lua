local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua", true))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local function getPing()
    return Player:GetNetworkPing() * 1000
end

local function convertToHMS(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

local function getGameName()
    local success, result = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    end)
    return success and result or "Unknown Game"
end

local GameName = getGameName()

local Window = Luna:CreateWindow({
    Name = "BlueScreen Hub",
    Subtitle = "Universal Script Hub",
    LogoID = nil,
    LoadingEnabled = true,
    LoadingTitle = "BlueScreen Hub",
    LoadingSubtitle = "Loading...",
    ConfigSettings = {
        RootFolder = nil,
        ConfigFolder = "BlueScreen"
    },
    KeySystem = false
})

local HomeTab = Window:CreateTab({
    Name = "Home",
    Icon = "home",
    ImageSource = "Material",
    ShowTitle = true
})

local LocalPlayerTab = Window:CreateTab({
    Name = "Local Player",
    Icon = "person",
    ImageSource = "Material",
    ShowTitle = true
})

local RenderTab = Window:CreateTab({
    Name = "Render",
    Icon = "visibility",
    ImageSource = "Material",
    ShowTitle = true
})

local SettingsTab = Window:CreateTab({
    Name = "Settings",
    Icon = "settings",
    ImageSource = "Material",
    ShowTitle = true
})

HomeTab:CreateSection("Welcome")
HomeTab:CreateLabel({
    Text = "Welcome to BlueScreen Hub, " .. Player.DisplayName,
    Style = 2
})

HomeTab:CreateDivider()

HomeTab:CreateSection("Server Information")

local PlayerCountLabel = HomeTab:CreateLabel({
    Text = "Player Count: " .. tostring(Players.NumPlayers) .. "/" .. tostring(Players.MaxPlayers),
    Style = 1
})

local PingLabel = HomeTab:CreateLabel({
    Text = "Ping: " .. tostring(math.floor(getPing())) .. "ms",
    Style = 1
})

local TimeLabel = HomeTab:CreateLabel({
    Text = "Time in Server: " .. convertToHMS(time()),
    Style = 1
})

local GameLabel = HomeTab:CreateLabel({
    Text = "Game: " .. GameName,
    Style = 1
})

HomeTab:CreateButton({
    Name = "Rejoin Server",
    Description = "Rejoin the current server",
    Callback = function()
        Luna:Notification({
            Title = "BlueScreen Hub",
            Icon = "refresh",
            ImageSource = "Material",
            Content = "Rejoining server..."
        })
        wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
    end
})

HomeTab:CreateButton({
    Name = "Server Hop",
    Description = "Join a different server",
    Callback = function()
        local success, error = pcall(function()
            local servers = HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
            for _, server in ipairs(servers) do
                if server.maxPlayers > server.playing and server.id ~= game.JobId then
                    Luna:Notification({
                        Title = "BlueScreen Hub",
                        Icon = "swap_horiz",
                        ImageSource = "Material",
                        Content = "Joining new server..."
                    })
                    wait(1)
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id)
                    return
                end
            end
        end)
        if not success then
            Luna:Notification({
                Title = "BlueScreen Hub",
                Icon = "error",
                ImageSource = "Material",
                Content = "Failed to find available servers"
            })
        end
    end
})

LocalPlayerTab:CreateSection("Movement")

local flySpeed = 50
local flying = false
local bodyVelocity, bodyGyro
local flightConnection

local function startFlying()
    if flying then return end
    flying = true

    local character = Player.Character or Player.CharacterAdded:Wait()
    character.Humanoid.PlatformStand = true

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = character.HumanoidRootPart

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    bodyGyro.CFrame = character.HumanoidRootPart.CFrame
    bodyGyro.Parent = character.HumanoidRootPart

    flightConnection = RunService.RenderStepped:Connect(function()
        if flying then
            local moveDirection = character.Humanoid.MoveDirection * flySpeed
            local camLookVector = Workspace.CurrentCamera.CFrame.LookVector

            if moveDirection.Magnitude > 0 then
                if camLookVector.Y > 0.2 then
                    moveDirection = moveDirection + Vector3.new(0, camLookVector.Y * flySpeed, 0)
                elseif camLookVector.Y < -0.2 then
                    moveDirection = moveDirection + Vector3.new(0, camLookVector.Y * flySpeed, 0)
                end
            else
                moveDirection = bodyVelocity.Velocity:Lerp(Vector3.new(0, 0, 0), 0.1)
            end
            
            bodyVelocity.Velocity = moveDirection

            local tiltAngle = 30
            local tiltFactor = moveDirection.Magnitude / flySpeed
            local targetCFrame = CFrame.new(character.HumanoidRootPart.Position, character.HumanoidRootPart.Position + camLookVector)
            bodyGyro.CFrame = bodyGyro.CFrame:Lerp(targetCFrame, 0.2)
        end
    end)
end

local function stopFlying()
    if not flying then return end
    flying = false

    local character = Player.Character or Player.CharacterAdded:Wait()
    character.Humanoid.PlatformStand = false

    if flightConnection then
        flightConnection:Disconnect()
        flightConnection = nil
    end

    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
end

local WalkSpeedSlider = LocalPlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 500},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(value)
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = value
        end
    end
}, "WalkSpeed")

local JumpPowerSlider = LocalPlayerTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 500},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(value)
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.JumpPower = value
        end
    end
}, "JumpPower")

local GravitySlider = LocalPlayerTab:CreateSlider({
    Name = "Gravity",
    Range = {0, 196.2},
    Increment = 1,
    CurrentValue = 196.2,
    Callback = function(value)
        Workspace.Gravity = value
    end
}, "Gravity")

local FOVSlider = LocalPlayerTab:CreateSlider({
    Name = "Field of View",
    Range = {70, 120},
    Increment = 1,
    CurrentValue = 70,
    Callback = function(value)
        if Workspace.CurrentCamera then
            Workspace.CurrentCamera.FieldOfView = value
        end
    end
}, "FOV")

local FlightSpeedSlider = LocalPlayerTab:CreateSlider({
    Name = "Flight Speed",
    Range = {10, 100},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(value)
        flySpeed = value
    end
}, "FlightSpeed")

LocalPlayerTab:CreateButton({
    Name = "Reset Values",
    Description = "Reset all sliders to default",
    Callback = function()
        WalkSpeedSlider:Set({ CurrentValue = 16 })
        JumpPowerSlider:Set({ CurrentValue = 50 })
        GravitySlider:Set({ CurrentValue = 196.2 })
        FOVSlider:Set({ CurrentValue = 70 })
        FlightSpeedSlider:Set({ CurrentValue = 50 })
        Luna:Notification({
            Title = "BlueScreen Hub",
            Icon = "refresh",
            ImageSource = "Material",
            Content = "Values reset to default"
        })
    end
})

LocalPlayerTab:CreateDivider()

local FlightToggle = LocalPlayerTab:CreateToggle({
    Name = "Flight",
    Description = "Enable/disable flight mode",
    CurrentValue = false,
    Callback = function(value)
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            if value then
                startFlying()
            else
                stopFlying()
            end
        end
    end
}, "Flight")

local noclipEnabled = false
local noclipConnection

local NoclipToggle = LocalPlayerTab:CreateToggle({
    Name = "Noclip",
    Description = "Walk through walls",
    CurrentValue = false,
    Callback = function(value)
        noclipEnabled = value
        if noclipEnabled then
            noclipConnection = RunService.Stepped:Connect(function()
                if Player.Character then
                    for _, part in pairs(Player.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            if Player.Character then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
}, "Noclip")

RenderTab:CreateSection("ESP")

local BlueScreenESP = {}

local function createHighlight(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "BlueScreenESP"
    highlight.Adornee = player.Character
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0.5
    highlight.Parent = game.CoreGui
    BlueScreenESP[player.UserId] = highlight
end

local HighlightToggle = RenderTab:CreateToggle({
    Name = "Player Highlights",
    Description = "Highlight all players",
    CurrentValue = false,
    Callback = function(value)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player then
                if value then
                    createHighlight(player)
                else
                    if BlueScreenESP[player.UserId] then
                        BlueScreenESP[player.UserId]:Destroy()
                        BlueScreenESP[player.UserId] = nil
                    end
                end
            end
        end
    end
}, "PlayerHighlights")

local nameESP = {}
local nameESPConnection

local NameESPToggle = RenderTab:CreateToggle({
    Name = "Player Names",
    Description = "Show player names above their heads",
    CurrentValue = false,
    Callback = function(value)
        if value then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Player then
                    local gui = Instance.new("BillboardGui")
                    gui.Name = "BlueScreenNameESP"
                    gui.Adornee = player.Character and player.Character:FindFirstChild("Head")
                    gui.Size = UDim2.new(0, 200, 0, 50)
                    gui.StudsOffset = Vector3.new(0, 2, 0)
                    gui.Parent = game.CoreGui
                    
                    local label = Instance.new("TextLabel")
                    label.Name = "NameLabel"
                    label.BackgroundTransparency = 1
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.Text = player.DisplayName
                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    label.TextScaled = true
                    label.Font = Enum.Font.SourceSansBold
                    label.Parent = gui
                    
                    nameESP[player.UserId] = gui
                end
            end
        else
            for _, gui in pairs(nameESP) do
                if gui then gui:Destroy() end
            end
            nameESP = {}
        end
    end
}, "PlayerNames")

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if HighlightToggle.CurrentValue then
            createHighlight(player)
        end
        if NameESPToggle.CurrentValue then
            wait(1)
            local gui = Instance.new("BillboardGui")
            gui.Name = "BlueScreenNameESP"
            gui.Adornee = character:FindFirstChild("Head")
            gui.Size = UDim2.new(0, 200, 0, 50)
            gui.StudsOffset = Vector3.new(0, 2, 0)
            gui.Parent = game.CoreGui
            
            local label = Instance.new("TextLabel")
            label.Name = "NameLabel"
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Text = player.DisplayName
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextScaled = true
            label.Font = Enum.Font.SourceSansBold
            label.Parent = gui
            
            nameESP[player.UserId] = gui
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if BlueScreenESP[player.UserId] then
        BlueScreenESP[player.UserId]:Destroy()
        BlueScreenESP[player.UserId] = nil
    end
    if nameESP[player.UserId] then
        nameESP[player.UserId]:Destroy()
        nameESP[player.UserId] = nil
    end
end)

SettingsTab:CreateSection("Configuration")
SettingsTab:BuildConfigSection()

SettingsTab:CreateSection("Theme")
SettingsTab:BuildThemeSection()

spawn(function()
    while wait(1) do
        PlayerCountLabel:Set({
            Text = "Player Count: " .. tostring(Players.NumPlayers) .. "/" .. tostring(Players.MaxPlayers)
        })
        PingLabel:Set({
            Text = "Ping: " .. tostring(math.floor(getPing())) .. "ms"
        })
        TimeLabel:Set({
            Text = "Time in Server: " .. convertToHMS(time())
        })
    end
end)

Luna:Notification({
    Title = "BlueScreen Hub",
    Icon = "check_circle",
    ImageSource = "Material",
    Content = "BlueScreen Hub loaded successfully!"
})

Luna:LoadAutoloadConfig()