ESX = nil
Config.LoadESX()
local inDuel = {}
local oldCoords = {}
local dueloff = {}

RegisterCommand("duel", function(src, args)
    local xPlayer = ESX.GetPlayerFromId(src)
    local tPlayer = ESX.GetPlayerFromId(args[1])
    if tPlayer then
        local tPlayer = ESX.GetPlayerFromId(args[1])
        if xPlayer.source == tPlayer.source then
            return Config.Notify(xPlayer.source, "~r~Nie możesz wysłać Duela do Siebie!")
        elseif xPlayer.source == args[1] then
            return Config.Notify(xPlayer.source, "~r~Nie możesz wysłać Duela do Samego Siebie!")
        elseif inDuel[src] then
            return Config.Notify(xPlayer.source, "~r~Jesteś już w Duelu!")
        elseif inDuel[tonumber(args[1])] then
            return Config.Notify(xPlayer.source, "~r~Osoba jest już w Duelu!")
        elseif dueloff[tonumber(args[1])] then
            return Config.Notify(xPlayer.source, "~r~Ta osoba posiada Wyłączone Duele!")
        end
        Config.Notify(xPlayer.source, "~g~Wysłano prośbę o Duela!")
        TriggerClientEvent("upikk_duel:ShowAcceptMenu", args[1], xPlayer.name, src)
    else
        Config.Notify(xPlayer.source, "~r~Podano nieprawidłowe ID!")
    end
end)

RegisterCommand("toggleduel", function(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if dueloff[src] then
        dueloff[src] = nil
        Config.Notify(xPlayer.source, "~g~Włączono powiadomienia o Duelu!")
    else
        dueloff[src] = true
        Config.Notify(xPlayer.source, "~g~Wyłączono powiadomienia o Duelu!")
    end
end)

RegisterServerEvent("upikk_duel:duelAccepted")
AddEventHandler("upikk_duel:duelAccepted", function(id)
    local randi = math.random(1, #Config.Locations)
    local sender = ESX.GetPlayerFromId(id)
    local receiver = ESX.GetPlayerFromId(source)
    Config.Notify(id, "~g~Wylosowano Mapę: " .. Config.Locations[randi].name)
    Config.Notify(source, "~g~Wylosowano Mapę: " .. Config.Locations[randi].name)
    local randomBucketNumer = math.random(3914, 15190612)
    oldCoords[sender.source] = sender.getCoords()
    oldCoords[receiver.source] = receiver.getCoords()
    inDuel[sender.source] = {sender.source, receiver.source, randomBucketNumer}
    inDuel[receiver.source] = {sender.source, receiver.source, randomBucketNumer}
    Config.TeleportPlayer(id, Config.Locations[randi].firstplayerlocation)
    Config.TeleportPlayer(source, Config.Locations[randi].secondplayerlocation)
    Config.SetBucket(sender.source, randomBucketNumer)
    Config.SetBucket(receiver.source, randomBucketNumer)
    Config.StartCounting(sender.source, receiver.source)
    Config.DrawLines(sender.source, receiver.source)
end)

RegisterNetEvent(Config.AmbulanceJobStatusEvent)
AddEventHandler(Config.AmbulanceJobStatusEvent, function(status)
    if status then
        if inDuel[source] then
            local xPlayer = ESX.GetPlayerFromId(source)
            local tPlayer
            if xPlayer.source == inDuel[source][2] then
                tPlayer = ESX.GetPlayerFromId(inDuel[source][1])
            else
                tPlayer = ESX.GetPlayerFromId(inDuel[source][2])
            end
            Config.SetBucket(xPlayer.source, 0)
            Config.SetBucket(tPlayer.source, 0)
            Config.StopDrawingLines(xPlayer.source)
            Config.StopDrawingLines(tPlayer.source)
            Config.TeleportPlayer(xPlayer.source, oldCoords[xPlayer.source])
            Config.TeleportPlayer(tPlayer.source, oldCoords[tPlayer.source])
            Config.RevivePlayer(xPlayer.source, tPlayer.source)
            oldCoords[xPlayer.source] = nil
            oldCoords[tPlayer.source] = nil
            inDuel[xPlayer.source] = nil
            inDuel[tPlayer.source] = nil
            Config.WinDuel(tPlayer.identifier)
            Config.Notify(tPlayer.source, "~g~Gratulacje! Wygrałeś Duela.")
            Config.Notify(xPlayer.source, "~r~Przegrałeś Duela, następnym razem będzie lepiej!")
        end
    end
end)

AddEventHandler('playerDropped', function()
    if inDuel[source] then
        if inDuel[source][1] ~= nil then
            local Player =  ESX.GetPlayerFromId(inDuel[source][1])
            local SecondPlayer = inDuel[source][1]
            Config.Notify(Player.source, "~r~Przeciwnik Opuścił Grę! Przyznano Ci Wygraną")
            Config.SetBucket(inDuel[source][1], 0)
            Config.TeleportPlayer(SecondPlayer, oldCoords[SecondPlayer])
            Config.StopDrawingLines(Player.source)
            Config.WinDuel(Player.identifier)
        end
        if inDuel[source][2] ~= nil then
            local Player =  ESX.GetPlayerFromId(inDuel[source][2])
            Config.Notify(Player.source, "~r~Przeciwnik Opuścił Grę! Przyznano Ci Wygraną")
            local SecondPlayer = inDuel[source][2]
            Config.SetBucket(inDuel[source][2], 0)
            Config.TeleportPlayer(SecondPlayer, oldCoords[SecondPlayer])
            Config.StopDrawingLines(Player.source)
            Config.WinDuel(Player.identifier)
        end
        inDuel[source] = nil
        oldCoords[source] = nil
    end
end)