-- BELOVE IS YOUR SETTINGS, CHANGE THEM TO WHATEVER YOU'D LIKE & MORE SETTINGS WILL COME IN THE FUTURE! --
local useBilling = true -- OPTIONS: (true/false)
local useCameraSound = true -- OPTIONS: (true/false)
local useFlashingScreen = true -- OPTIONS: (true/false)
local useBlips = false -- OPTIONS: (true/false)
local alertPolice = false -- OPTIONS: (true/false)
local alertSpeed = 300 -- OPTIONS: (1-5000 KMH)

local defaultPrice60 = 250 -- THIS IS THE DEFAULT PRICE WITHOUT EXTRA COST FOR 60 ZONES
local defaultPrice80 = 350 -- THIS IS THE DEFAULT PRICE WITHOUT EXTRA COST FOR 80 ZONES
local defaultPrice120 = 500 -- THIS IS THE DEFAULT PRICE WITHOUT EXTRA COST FOR 120 ZONES

local extraZonePrice10 = 50 -- THIS IS THE EXTRA COST IF 10 KM/H ABOVE LIMIT (REQUIRES "useBilling" to be set to true)
local extraZonePrice20 = 150 -- THIS IS THE EXTRA COST IF 20 KM/H ABOVE LIMIT (REQUIRES "useBilling" to be set to true)
local extraZonePrice30 = 250 -- THIS IS THE EXTRA COST IF 30 KM/H ABOVE LIMIT (REQUIRES "useBilling" to be set to true)
local extraZonePrice50 = 350
-- ABOVE IS YOUR SETTINGS, CHANGE THEM TO WHATEVER YOU'D LIKE & MORE SETTINGS WILL COME IN THE FUTURE!  --

ESX = nil
local hasBeenCaught = false
local finalBillingPrice = 0;
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('mrpx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('mrpx:playerLoaded')
AddEventHandler('mrpx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('mrpx:setJob')
AddEventHandler('mrpx:setJob', function(job)
    PlayerData.job = job
end)

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- BLIP FOR SPEEDCAMERAS
local blips = {
	-- 60KM/H ZONES
	{title="Speedcamera (60KM/H)", colour=1, id=1, x = -524.2645, y = -1776.3569, z = 21.3384}, -- 60KM/H ZONE
	
	-- 80KM/H ZONES
	{title="Speedcamera (80KM/H)", colour=1, id=1, x = 2506.0671, y = 4145.2431, z = 38.1054}, -- 80KM/H ZONE
	{title="Speedcamera (80KM/H)", colour=1, id=1, x = 1258.2006, y = 789.4199, z = 104.2190}, -- 80KM/H ZONE
	{title="Speedcamera (80KM/H)", colour=1, id=1, x = 980.9982, y = 407.4164, z = 92.2374}, -- 80KM/H ZONE
	
	-- 120KM/H ZONES
	{title="Speedcamera (120KM/H)", colour=1, id=1, x = 1584.9281, y = -993.4557, z = 59.3923}, -- 120KM/H ZONE
	{title="Speedcamera (120KM/H)", colour=1, id=1, x = 2442.2006, y = -134.6004, z = 88.7765}, -- 120KM/H ZONE
	{title="Speedcamera (120KM/H)", colour=1, id=1, x = 2871.7951, y = 3540.5795, z = 53.0930} -- 120KM/H ZONE
}

Citizen.CreateThread(function()
	for _, info in pairs(blips) do
		if useBlips == true then
			info.blip = AddBlipForCoord(info.x, info.y, info.z)
			SetBlipSprite(info.blip, info.id)
			SetBlipDisplay(info.blip, 4)
			SetBlipScale(info.blip, 0.5)
			SetBlipColour(info.blip, info.colour)
			SetBlipAsShortRange(info.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(info.title)
			EndTextCommandSetBlipName(info.blip)
		end
	end
end)

-- AREAS
local Speedcamera60Zone = {
    --{x = -524.2645,y = -1776.3569,z = 21.3384}
}

local Speedcamera80Zone = {
    {x = 2506.0671,y = 4145.2431,z = 38.1054},
    {x = 1258.2006,y = 789.4199,z = 103.2190},
    {x = 980.9982,y = 407.4164,z = 92.2374},
	{x = -94.17,y = -924.71,z = 29.34},
    {x = 329.25,y = -1049.64,z = 29.07},
	{x = -89.32,y = -1684.53,z = 29.13},
	{x = 224.73,y = -675.8,z = 37.13},
	{x = 21.86,y = -144.23,z = 55.74},
	{x = 101.85,y = -581.83,z = 43.00},
	{x = -690.71,y = -837.29, z = 23.54},
	{x = -2268.95,y = 2266.59,z = 32.37},
	{x = -940.56,y = 2755.88,z = 24.79},
	{x = 286.07,y = 2635.75,z = 44.26},
	{x = 1187.23,y = 2682.58,z = 37.46},
	{x = 2179.78,y = 3016.86,z = 45.01}
}

local Speedcamera120Zone = {
    {x = 1584.9281,y = -993.4557,z = 59.3923},
    {x = 2442.2006,y = -134.6004,z = 88.7765},
    {x = 2871.7951,y = 3540.5795,z = 53.0930},
	{x = -2466.3,y = -220,z = 17.21},
	{x = -2991.5,y = -414.59,z = 14.54},
	{x = -2977.05,y = 2072.94,z = 39.9},
	{x = 848.39,y = 109.64,z = 69.79}
}

-- ZONES
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)

		-- 60 zone
        for k in pairs(Speedcamera60Zone) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Speedcamera60Zone[k].x, Speedcamera60Zone[k].y, Speedcamera60Zone[k].z)

            if dist <= 20.0 then
				local playerPed = GetPlayerPed(-1)
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6
				local maxSpeed = 65.0 -- THIS IS THE MAX SPEED IN KM/H
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then
							if hasBeenCaught == false then
								if PlayerData.job ~= nil and not (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance') then
								-- VEHICLES ABOVE ARE BLACKLISTED
								--else
									-- ALERT POLICE (START)
									if alertPolice == true then
										if SpeedKM > alertSpeed then
											local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
											TriggerServerEvent('mlPhone:sendMessage', 'police', ' Someone passed the speed camera, above ' .. alertSpeed.. ' KMH', true, {x =x, y =y, z =z})
										end
									end
									-- ALERT POLICE (END)								
								
									-- FLASHING EFFECT (START)
									if useFlashingScreen == true then
										TriggerServerEvent('esx_speedcamera:openGUI')
									end
									
									if useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if useFlashingScreen == true then
										Citizen.Wait(200)
										TriggerServerEvent('esx_speedcamera:closeGUI')
									end
									-- FLASHING EFFECT (END)								
								
									TriggerEvent("pNotify:SendNotification", {text = "Je bent geflitst in een 60KM/H zone! Jou snelheid: " .. math.floor(SpeedKM) .. " KM/H", type = "error", timeout = 5000, layout = "centerLeft"})
									
									if useBilling == true then
										if SpeedKM >= maxSpeed + 50 then
											finalBillingPrice = defaultPrice60 + extraZonePrice50
										elseif SpeedKM >= maxSpeed + 30 then
											finalBillingPrice = defaultPrice60 + extraZonePrice30
										elseif SpeedKM >= maxSpeed + 20 then
											finalBillingPrice = defaultPrice60 + extraZonePrice20
										elseif SpeedKM >= maxSpeed + 10 then
											finalBillingPrice = defaultPrice60 + extraZonePrice10
										else
											finalBillingPrice = defaultPrice60
										end
										
										TriggerServerEvent('mrpx_billing:sendBill', GetPlayerServerId(PlayerId()), 'society_police', 'Flitser (60KM/H) - Jou snelheid: ' .. math.floor(SpeedKM) .. ' KM/H - ', finalBillingPrice) -- Sends a bill from the police
									else
										TriggerServerEvent('esx_speedcamera:PayBill60Zone')
									end
										
									hasBeenCaught = true
									Citizen.Wait(5000) -- This is here to make sure the player won't get fined over and over again by the same camera!
								end
							end
						end
					end
					
					hasBeenCaught = false
				end
            end
        end
		
		-- 80 zone
		for k in pairs(Speedcamera80Zone) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Speedcamera80Zone[k].x, Speedcamera80Zone[k].y, Speedcamera80Zone[k].z)

            if dist <= 20.0 then
				local playerPed = GetPlayerPed(-1)
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6
				local maxSpeed = 85.0 -- THIS IS THE MAX SPEED IN KM/H
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then					
							if hasBeenCaught == false then
								if PlayerData.job ~= nil and not (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance') then
									-- VEHICLES ABOVE ARE BLACKLISTED
								--else
									-- ALERT POLICE (START)
									if alertPolice == true then
										if SpeedKM > alertSpeed then
											local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
											TriggerServerEvent('mlPhone:sendMessage', 'police', ' Someone passed the speed camera, above ' .. alertSpeed.. ' KMH', true, {x =x, y =y, z =z})
										end
									end
									-- ALERT POLICE (END)								
								
									-- FLASHING EFFECT (START)
									if useFlashingScreen == true then
										TriggerServerEvent('esx_speedcamera:openGUI')
									end
									
									if useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if useFlashingScreen == true then
										Citizen.Wait(200)
										TriggerServerEvent('esx_speedcamera:closeGUI')
									end
									-- FLASHING EFFECT (END)								
								
									TriggerEvent("pNotify:SendNotification", {text = "Je bent geflitst in een 80KM/H zone! Jou snelheid:" .. math.floor(SpeedKM) .. " KM/H", type = "error", timeout = 5000, layout = "centerLeft"})
									
									if useBilling == true then
										if SpeedKM >= maxSpeed + 50 then
											finalBillingPrice = defaultPrice80 + extraZonePrice50
										elseif SpeedKM >= maxSpeed + 30 then
											finalBillingPrice = defaultPrice80 + extraZonePrice30
										elseif SpeedKM >= maxSpeed + 20 then
											finalBillingPrice = defaultPrice80 + extraZonePrice20
										elseif SpeedKM >= maxSpeed + 10 then
											finalBillingPrice = defaultPrice80 + extraZonePrice10
										else
											finalBillingPrice = defaultPrice80
										end
									
										TriggerServerEvent('mrpx_billing:sendBill', GetPlayerServerId(PlayerId()), 'society_police', 'Flitser (80KM/H) - Jou snelheid: ' .. math.floor(SpeedKM) .. ' KM/H - ', finalBillingPrice) -- Sends a bill from the police
									else
										TriggerServerEvent('esx_speedcamera:PayBill80Zone')
									end
										
									hasBeenCaught = true
									Citizen.Wait(5000) -- This is here to make sure the player won't get fined over and over again by the same camera!
								end
							end
						end
					end
					
					hasBeenCaught = false
				end
            end
        end
		
		-- 120 zone
		for k in pairs(Speedcamera120Zone) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Speedcamera120Zone[k].x, Speedcamera120Zone[k].y, Speedcamera120Zone[k].z)

            if dist <= 20.0 then
				local playerPed = GetPlayerPed(-1)
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6
				local maxSpeed = 135.0 -- THIS IS THE MAX SPEED IN KM/H
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then 
							if hasBeenCaught == false then
								if PlayerData.job ~= nil and not (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance') then
								-- VEHICLES ABOVE ARE BLACKLISTED
								--else
									-- ALERT POLICE (START)
									if alertPolice == true then
										if SpeedKM > alertSpeed then
											local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
											TriggerServerEvent('mlPhone:sendMessage', 'police', ' Someone passed the speed camera, above ' .. alertSpeed.. ' KMH', true, {x =x, y =y, z =z})
										end
									end
									-- ALERT POLICE (END)
								
									-- FLASHING EFFECT (START)
									if useFlashingScreen == true then
										TriggerServerEvent('esx_speedcamera:openGUI')
									end
									
									if useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if useFlashingScreen == true then
										Citizen.Wait(200)
										TriggerServerEvent('esx_speedcamera:closeGUI')
									end
									-- FLASHING EFFECT (END)
								
									TriggerEvent("pNotify:SendNotification", {text = "Je bent geflitst in een 130KM/H zone! Jou snelheid: " .. math.floor(SpeedKM) .. " KM/H", type = "error", timeout = 5000, layout = "centerLeft"})
									
									
									if useBilling == true then
										if SpeedKM >= maxSpeed + 50 then
											finalBillingPrice = defaultPrice120 + extraZonePrice50
										elseif SpeedKM >= maxSpeed + 30 then
											finalBillingPrice = defaultPrice120 + extraZonePrice30
										elseif SpeedKM >= maxSpeed + 20 then
											finalBillingPrice = defaultPrice120 + extraZonePrice20
										elseif SpeedKM >= maxSpeed + 10 then
											finalBillingPrice = defaultPrice120 + extraZonePrice10
										else
											finalBillingPrice = defaultPrice120
										end
									
										TriggerServerEvent('mrpx_billing:sendBill', GetPlayerServerId(PlayerId()), 'society_police', 'Flitser (130KM/H) - Jou snelheid: ' .. math.floor(SpeedKM) .. ' KM/H - ', finalBillingPrice) -- Sends a bill from the police
									else
										TriggerServerEvent('esx_speedcamera:PayBill120Zone')
									end
										
									hasBeenCaught = true
									Citizen.Wait(5000) -- This is here to make sure the player won't get fined over and over again by the same camera!
								end
							end
						end
					end
					
					hasBeenCaught = false
				end
            end
        end
    end
end)

RegisterNetEvent('esx_speedcamera:openGUI')
AddEventHandler('esx_speedcamera:openGUI', function()
    SetNuiFocus(false,false)
    SendNUIMessage({type = 'openSpeedcamera'})
end)   

RegisterNetEvent('esx_speedcamera:closeGUI')
AddEventHandler('esx_speedcamera:closeGUI', function()
    SendNUIMessage({type = 'closeSpeedcamera'})
end)