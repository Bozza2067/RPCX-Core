-- INIT
    
-- CHAT COMMANDS

    errColor = { 221, 149, 45 }
    radColor = { 45, 136, 221 }
    successColor = { 95, 212, 68 }
    globalColor = {89, 198, 189}
    localColor = {89, 98, 198}
    icColor = {149, 210, 2353}
    bleeterColor = {87, 195, 120}
    chatColor = {200, 200, 200}
    actionRanges = 20

    RegisterCommand({ "bleet", "tweet" }, function(source, args)
        if source == 0 then return end
        if not args[1] then return SendChatMessage(source, "[bleet] Command requires input.", errColor) end

        SendChatMessage(-1, "[Bleeter] @" .. GetPlayerName(source) .. ": " .. table.concat(args, " "), bleeterColor)
    end)

    RegisterCommand("gme", function(source, args)
        if source == 0 then return end
        if not args[1] then return SendChatMessage(source, "[GMY] Command requires input.", errColor) end

        SendChatMessage(-1, "[GME] " .. GetPlayerName(source) .. " " .. table.concat(args, " "), globalColor)
    end)

    RegisterCommand("gmy", function(source, args)
        if source == 0 then return end
        if not args[1] then return SendChatMessage(source, "[gme] Command requires input.", errColor) end

        SendChatMessage(-1, "[GMY] " .. GetPlayerName(source) .. "'s " .. table.concat(args, " "), globalColor)
    end)

    RegisterCommand("gdo", function(source, args)
        if source == 0 then return end
        if not args[1] then return SendChatMessage(source, "[GDO] Command requires input.", errColor) end

        SendChatMessage(-1, "[GDO] " .. table.concat(args, " ") .. " (( " .. GetPlayerName(source) .. " ))", globalColor)
    end)

    RegisterCommand("me", function(source, args)
        if source == 0 then return end
        if not args[1] then return SendChatMessage(source, "[ME] Command requires input.", errColor) end

        SendProximityMessage(source, "[ME] " .. GetPlayerName(source) .. " " .. table.concat(args, " "), localColor, actionRanges)
    end)

    RegisterCommand("my", function(source, args)
        if source == 0 then return end
        if not args[1] then return SendChatMessage(source, "[MY] Command requires input.", errColor) end

        SendProximityMessage(source, "[MY] " .. GetPlayerName(source) .. "'s " .. table.concat(args, " "), localColor, actionRanges)
    end)

    RegisterCommand("ooc", function(source, args)
        if source == 0 then return end
        if not args[1] then return SendChatMessage(source, "[OOC] Command requires input.", errColor) end

        SendChatMessage(-1, "[OOC] " .. GetPlayerName(source) .. ": (( " .. table.concat(args, " ") .. " ))", chatColor)
    end)
    RegisterCommand("/", function(source, args)
        if source == 0 then return end
        if not args[1] then return SendChatMessage(source, "[OOC] Command requires input.", errColor) end

        SendChatMessage(-1, "[OOC] " .. GetPlayerName(source) .. ": (( " .. table.concat(args, " ") .. " ))", chatColor)
    end)

    RegisterCommand("local", function(source, args)
        if source == 0 then return end
        if not args[1] then return SendChatMessage(source, "[LOCAL OOC] Command requires input.", errColor) end

        SendProximityMessage(source, "[LOCAL OOC] " .. GetPlayerName(source) .. ": (( " .. table.concat(args, " ") .. " ))", chatColor, actionRanges)
    end)

    RegisterCommand('img', function(source, args)
        if not args[1] then return end
        TriggerClientEvent('chat:addMessage', -1, {
            args = { args[1] },
            template = "<img src=\"{0}\">"
        })
    end, true)

    RegisterCommand("do", function(source, args)
        if source == 0 then return end
        if not args[1] then return SendChatMessage(source, "[DO] Command requires input.", errColor) end

        SendProximityMessage(source, "[DO] " .. table.concat(args, " ") .. " (( " .. GetPlayerName(source) .. " ))", localColor, actionRanges)
    end)

    function SendProximityMessage(sender, message, color, dist)
        if GetConvar("onesync", "off") ~= "off" then
            local senderCoords = GetEntityCoords(GetPlayerPed(sender))
            for _, player in pairs(GetPlayers()) do
                local pCoords = GetEntityCoords(GetPlayerPed(player))
                if #(senderCoords - pCoords) <= dist then
                    SendChatMessage(player, message, color)
                end
            end
        else
            TriggerClientEvent("sendProximityMessage", -1, source, message, color, dist)
        end
    end
    
    function SendChatMessage(recipient, message, color)
        color = color or { 210, 210, 210 }
        if recipient == 0 then
            local prefix = ""
            if table.equals(color, errColor) then -- this doesn't work xd
                prefix = "^3"
            end
    
            return RconPrint(prefix .. message .. "^7")
        end
    
        TriggerClientEvent("chat:addMessage", recipient, {
            args = { message },
            color = color
        })
    end

    AddEventHandler('chatMessage', function(source, name, message)
        if string.sub(message, 1, string.len("/")) ~= "/" then
            SendProximityMessage(source, "[IC] " .. GetPlayerName(source) .. ": \"" .. message .. "\"", icColor, actionRanges)
        end
        CancelEvent()
    end)