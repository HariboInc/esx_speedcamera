ESX = nil
local hasBeenCaught = false
local finalBillingPrice = 0;
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
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
	{title=('camera') ('km'), colour=1, id=1, x = -524.2645, y = -1776.3569, z = 21.3384}, -- 60KM/H ZONE
	
	-- 80KM/H ZONES
	{title=('camera') ('km'), colour=1, id=1, x = 2506.0671, y = 4145.2431, z = 38.1054}, -- 80KM/H ZONE
	{title=('camera') ('km'), colour=1, id=1, x = 1258.2006, y = 789.4199, z = 104.2190}, -- 80KM/H ZONE
	{title=('camera') ('km'), colour=1, id=1, x = 980.9982, y = 407.4164, z = 92.2374}, -- 80KM/H ZONE
	
	-- 120KM/H ZONES
	{title=('camera') ('km'), colour=1, id=1, x = 1584.9281, y = -993.4557, z = 59.3923}, -- 120KM/H ZONE
	{title=('camera') ('km'), colour=1, id=1, x = 2442.2006, y = -134.6004, z = 88.7765}, -- 120KM/H ZONE
	{title=('camera') ('km'), colour=1, id=1, x = 2871.7951, y = 3540.5795, z = 53.0930} -- 120KM/H ZONE
}
-- To be made dynamic.

Citizen.CreateThread(function()
	for _, info in pairs(blips) do
		if Config.useBlips == true then
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

-- ZONES
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)

		-- 60 zone
        for k in pairs(Config.Speedcamera60Zone) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Speedcamera60Zone[k].x, Config.Speedcamera60Zone[k].y, Config.Speedcamera60Zone[k].z)

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
									if Config.alertPolice == true then
										if SpeedKM > Config.alertSpeed then
											local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
											TriggerServerEvent('mlPhone:sendMessage', 'police', ('passed') .. Config.alertSpeed.. ('km'), true, {x =x, y =y, z =z})
										end
									end
									-- ALERT POLICE (END)								
								
									-- FLASHING EFFECT (START)
									if Config.useFlashingScreen == true then
										TriggerServerEvent('esx_speedcamera:openGUI')
									end
									
									if Config.useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if Config.useFlashingScreen == true then
										Citizen.Wait(200)
										TriggerServerEvent('esx_speedcamera:closeGUI')
									end
									-- FLASHING EFFECT (END)								
								
									TriggerEvent("pNotify:SendNotification", {text = 'caught60' .. math.floor(SpeedKM) .. 'km', type = "error", timeout = 5000, layout = "centerLeft"})
									
									if Config.useBilling == true then
										if SpeedKM >= maxSpeed + 50 then
											finalBillingPrice = Config.defaultPrice60 + Config.extraZonePrice50
										elseif SpeedKM >= maxSpeed + 30 then
											finalBillingPrice = Config.defaultPrice60 + Config.extraZonePrice30
										elseif SpeedKM >= maxSpeed + 20 then
											finalBillingPrice = Config.defaultPrice60 + Config.extraZonePrice20
										elseif SpeedKM >= maxSpeed + 10 then
											finalBillingPrice = Config.defaultPrice60 + Config.extraZonePrice10
										else
											finalBillingPrice = Config.defaultPrice60
										end
										
										TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(PlayerId()), 'society_police', ('ticket60') .. math.floor(SpeedKM) .. ('km'), finalBillingPrice) -- Sends a bill from the police
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
		for k in pairs(Config.Speedcamera80Zone) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Speedcamera80Zone[k].x, Config.Speedcamera80Zone[k].y, Config.Speedcamera80Zone[k].z)

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
									if Config.alertPolice == true then
										if SpeedKM > Config.alertSpeed then
											local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
											TriggerServerEvent('mlPhone:sendMessage', 'police', ('passed') .. Config.alertSpeed.. ('km'), true, {x =x, y =y, z =z})
										end
									end
									-- ALERT POLICE (END)								
								
									-- FLASHING EFFECT (START)
									if Config.useFlashingScreen == true then
										TriggerServerEvent('esx_speedcamera:openGUI')
									end
									
									if Config.useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if Config.useFlashingScreen == true then
										Citizen.Wait(200)
										TriggerServerEvent('esx_speedcamera:closeGUI')
									end
									-- FLASHING EFFECT (END)								
								
									TriggerEvent("pNotify:SendNotification", {text = 'caught80' .. math.floor(SpeedKM) .. 'km', type = "error", timeout = 5000, layout = "centerLeft"})
									
									if Config.useBilling == true then
										if SpeedKM >= maxSpeed + 50 then
											finalBillingPrice = Config.defaultPrice80 + Config.extraZonePrice50
										elseif SpeedKM >= maxSpeed + 30 then
											finalBillingPrice = Config.defaultPrice80 + Config.extraZonePrice30
										elseif SpeedKM >= maxSpeed + 20 then
											finalBillingPrice = Config.defaultPrice80 + Config.extraZonePrice20
										elseif SpeedKM >= maxSpeed + 10 then
											finalBillingPrice = Config.defaultPrice80 + Config.extraZonePrice10
										else
											finalBillingPrice = Config.defaultPrice80
										end
									
										TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(PlayerId()), 'society_police', ('ticket80') .. math.floor(SpeedKM) .. ('km'), finalBillingPrice) -- Sends a bill from the police
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
		for k in pairs(Config.Speedcamera120Zone) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Speedcamera120Zone[k].x, Config.Speedcamera120Zone[k].y, Config.Speedcamera120Zone[k].z)

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
									if Config.alertPolice == true then
										if SpeedKM > Config.alertSpeed then
											local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
											TriggerServerEvent('mlPhone:sendMessage', 'police', ('passed') .. Config.alertSpeed.. ('km'), true, {x =x, y =y, z =z})
										end
									end
									-- ALERT POLICE (END)
								
									-- FLASHING EFFECT (START)
									if Config.useFlashingScreen == true then
										TriggerServerEvent('esx_speedcamera:openGUI')
									end
									
									if Config.useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if Config.useFlashingScreen == true then
										Citizen.Wait(200)
										TriggerServerEvent('esx_speedcamera:closeGUI')
									end
									-- FLASHING EFFECT (END)
								
									TriggerEvent("pNotify:SendNotification", {text = 'caught120' .. math.floor(SpeedKM) .. 'km', type = "error", timeout = 5000, layout = "centerLeft"})
									
									
									if Config.useBilling == true then
										if SpeedKM >= maxSpeed + 50 then
											finalBillingPrice = Config.defaultPrice120 + Config.extraZonePrice50
										elseif SpeedKM >= maxSpeed + 30 then
											finalBillingPrice = Config.defaultPrice120 + Config.extraZonePrice30
										elseif SpeedKM >= maxSpeed + 20 then
											finalBillingPrice = Config.defaultPrice120 + Config.extraZonePrice20
										elseif SpeedKM >= maxSpeed + 10 then
											finalBillingPrice = Config.defaultPrice120 + Config.extraZonePrice10
										else
											finalBillingPrice = Config.defaultPrice120
										end
									
										TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(PlayerId()), 'society_police', ('ticket120') .. math.floor(SpeedKM) .. ('km'), finalBillingPrice) -- Sends a bill from the police
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