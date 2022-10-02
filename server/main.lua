ESX = nil

TriggerEvent('mrpx:getSharedObject', function(obj)
	ESX = obj
end)

-- BILLS WITHOUT ESX_BILLING (START)
RegisterServerEvent('esx_speedcamera:PayBill60Zone')
AddEventHandler('esx_speedcamera:PayBill60Zone', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	
	xPlayer.removeMoney(100)
end)

RegisterServerEvent('esx_speedcamera:PayBill80Zone')
AddEventHandler('esx_speedcamera:PayBill80Zone', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	
	xPlayer.removeMoney(300)	
end)

RegisterServerEvent('esx_speedcamera:PayBill120Zone')
AddEventHandler('esx_speedcamera:PayBill120Zone', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	
	xPlayer.removeMoney(500)
end)
-- BILLS WITHOUT ESX_BILLING (END)

-- FLASHING EFFECT (START)
RegisterServerEvent('esx_speedcamera:openGUI')
AddEventHandler('esx_speedcamera:openGUI', function()
	TriggerClientEvent('esx_speedcamera:openGUI', source)
end)

RegisterServerEvent('esx_speedcamera:closeGUI')
AddEventHandler('esx_speedcamera:closeGUI', function()
	TriggerClientEvent('esx_speedcamera:closeGUI', source)
end)
-- FLASHING EFFECT (END)

function notification(text)
	TriggerClientEvent('mrpx:showNotification', source, text)
end

--[[ Version Checker ]]--
local version = "1.1.0"

if Config.CheckForUpdates then
    AddEventHandler("onResourceStart", function(resource)
        if resource == GetCurrentResourceName() then
            CheckFrameworkVersion()
        end
    end)
end

function CheckFrameworkVersion()
    PerformHttpRequest("https://raw.githubusercontent.com/HariboInc/esx_speedcamera/main/version.txt", function(err, text, headers)
        if string.match(text, version) then
            print(" ")
            print("--------- ^4ESX_SPEEDCAMERA VERSION^7 ---------")
            print("esx_speedcamera ^2is up to date^7 and ready to go!")
            print("Running on Version: ^2" .. version .."^7")
            print("^4https://github.com/HariboInc/esx_speedcamera^7")
            print("--------------------------------------------")
            print(" ")
        else
          print(" ")
          print("--------- ^4ESX_SPEEDCAMERA VERSION^7 ---------")
          print("esx_speedcamera ^1is not up to date!^7 Please update!")
          print("Curent Version: ^1" .. version .. "^7 Latest Version: ^2" .. text .."^7")
          print("^4https://github.com/HariboInc/esx_speedcamera^7")
          print("--------------------------------------------")
          print(" ")
        end

    end, "GET", "", {})

end