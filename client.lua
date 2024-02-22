ESX = nil
Config.LoadESX()
local drawlines = false
local wait = 50


RegisterNetEvent("upikk_duel:ShowAcceptMenu")
AddEventHandler("upikk_duel:ShowAcceptMenu", function(name, id)
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'duels_menu',
		{
			title    = 'Gracz ' .. name .. " wysłał ci prośbę o Duela",
			align    = 'center',
			elements = {
				{label = 'Przyjmij', value = 'accept'},
				{label = 'Odrzuć', value = 'decline'},
			}
		},
		function(data, menu)
			local value = data.current.value
			if value == "accept" then
				TriggerServerEvent("upikk_duel:duelAccepted", id)
			else
				ESX.ShowNotification("~r~Odrzuciłeś prośbę o Duela!")
			end
			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end)

function cd(num)
	SetTextCentre(true)
	SetTextFont(6)
	SetTextScale(2.0, 2.0)
	SetTextColour(0, 200, 255,255)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(2, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(num)
	DrawText(0.5, 0.25)
end

RegisterNetEvent("upikk_duel:startCounting")
AddEventHandler("upikk_duel:startCounting", function()
    local ped = PlayerPedId()
    RaceCreator = false
    RaceJoined = false
    DrawCountdown = true
    SetAudioFlag("LoadMPData", true)
    FreezeEntityPosition(ped, true)
    Countdown = 3
    PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
    Wait(1000)
    Countdown = 2
    PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
    Wait(1000)
    Countdown = 1
    PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
    Wait(600)
    PlaySoundFrontend(-1, "GO", "HUD_MINI_GAME_SOUNDSET", 1)
    Wait(400)
    Countdown = "GO"
    FreezeEntityPosition(ped, false)
    Wait(1000)
    DrawCountdown = false
    DisableControlAction(0, 25, false)
end)

  
Citizen.CreateThread(function()
	while true do
      Wait(wait)
      if DrawCountdown then
          wait = 0
          DisableControlAction(0, 25, true)
          cd(tostring(Countdown))
      end
	end
end)

RegisterNetEvent("upikk_duel:updatePlayerCoords")
AddEventHandler("upikk_duel:updatePlayerCoords", function(coords)
	local pid = PlayerPedId()
	SetEntityCoords(pid, vec3(coords.x, coords.y, coords.z))
end)


RegisterNetEvent("clearlines", function()
	drawlines = false
end)

RegisterNetEvent("drawtoid", function(id)
    local secondid = nil
    Citizen.Wait(3000)
    local players = GetActivePlayers()
    for _, player in ipairs(players) do
      local playerServerId = GetPlayerServerId(player)
      if tonumber(playerServerId) == tonumber(id) then
        secondid = player
        drawlines = true
        break
      end
    end
    local ped2 = GetPlayerPed(secondid)
    while drawlines do
      Citizen.Wait(5)
      local cx, cy, cz = table.unpack(GetEntityCoords(PlayerPedId()))
      local x, y, z = table.unpack(GetEntityCoords(ped2))
      DrawLine(cx, cy, cz, x, y, z, Config.LinesColor.R, Config.LinesColor.G, Config.LinesColor.B, 255)
    end
end)
