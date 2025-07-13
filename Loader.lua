local gameId = game.PlaceId or game.GameId

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