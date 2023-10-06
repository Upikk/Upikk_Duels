Config = {}

Config.LoadESX = function()
    ESX = exports["es_extended"]:getSharedObject()
end

if IsDuplicityVersion() then -- SERVER CONFIG
    Config.AmbulanceJobStatusEvent = "esx_ambulancejob:setDeathStatus"

    Config.RevivePlayer = function(firstplayerid, secondplayerid)
        TriggerClientEvent("esx_ambulancejob:revive", firstplayerid)
        TriggerClientEvent("esx_ambulancejob:revive", secondplayerid)
    end

    Config.Notify = function(id, msg)
        local player = ESX.GetPlayerFromId(id)
        player.showNotification(msg)
    end

    Config.TeleportPlayer = function(id, coords)
        TriggerClientEvent("upikk_duel:updatePlayerCoords", id, coords)
    end

    Config.SetBucket = function(id, bucket)
        SetPlayerRoutingBucket(id, bucket)
    end

    Config.StartCounting = function(id, id2)
        TriggerClientEvent("upikk_duel:startCounting", id)
        TriggerClientEvent("upikk_duel:startCounting", id2)
    end

    Config.DrawLines = function(id, id2)
        TriggerClientEvent("drawtoid", id, id2)
        TriggerClientEvent("drawtoid", id2, id)
    end

    Config.StopDrawingLines = function(id)
        TriggerClientEvent("clearlines", id)
    end

    Config.WinDuel = function(identifier)
        MySQL.Async.fetchAll("SELECT * FROM duels WHERE identifier = @identifier", {
            ["@identifier"] = identifier
        }, function(res)
            if res and res[1] then
                MySQL.Async.execute("UPDATE duels SET wins = wins + 1 WHERE identifier = @identifier", {
                    ["@identifier"] = identifier
                })
            else
                MySQL.Async.execute("INSERT INTO duels (identifier, wins) VALUES (@identifier, @wins)", {
                    ["@identifier"] = identifier,
                    ["@wins"] = 1
                })
            end
        end)
    end

    Config.Locations = {
        [1] = {
            ["name"] = "Doki",
            ["firstplayerlocation"] = {x = -299.31549072266, y = -2716.9636230469, z = 6.0002913475037-0.95, heading = 320.0},
            ["secondplayerlocation"] = {x = -328.71759033203, y = -2689.986328125, z = 6.0312962532043-0.95, heading = 320.0},
        },
        [2] = {
            ["name"] = "Lotnia",
            ["firstplayerlocation"] = {x = 1474.1544189453, y = 3189.4721679688, z = 40.414073944092-0.95, heading = 100.0},
            ["secondplayerlocation"] = {x = 1406.3635253906, y = 3172.4731445312, z = 40.414073944092-0.95, heading = 285.0}
        }
    }
else -- CLIENT CONFIG
    Config.LinesColor = {
        ["R"] = 255,
        ["G"] = 0,
        ["B"] = 0
    }
end