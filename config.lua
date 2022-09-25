Config = {}

Config.Locale = 'en'

Config.useBilling = true -- OPTIONS: (true/false)
Config.useCameraSound = true -- OPTIONS: (true/false)
Config.useFlashingScreen = true -- OPTIONS: (true/false)
Config.useBlips = false -- OPTIONS: (true/false)
Config.alertPolice = false -- OPTIONS: (true/false)
Config.alertSpeed = 300 -- OPTIONS: (1-5000 KMH)

Config.defaultPrice60 = 250 -- THIS IS THE DEFAULT PRICE WITHOUT EXTRA COST FOR 60 ZONES
Config.defaultPrice80 = 350 -- THIS IS THE DEFAULT PRICE WITHOUT EXTRA COST FOR 80 ZONES
Config.defaultPrice120 = 500 -- THIS IS THE DEFAULT PRICE WITHOUT EXTRA COST FOR 120 ZONES

Config.extraZonePrice10 = 50 -- THIS IS THE EXTRA COST IF 10 KM/H ABOVE LIMIT (REQUIRES "useBilling" to be set to true)
Config.extraZonePrice20 = 150 -- THIS IS THE EXTRA COST IF 20 KM/H ABOVE LIMIT (REQUIRES "useBilling" to be set to true)
Config.extraZonePrice30 = 250 -- THIS IS THE EXTRA COST IF 30 KM/H ABOVE LIMIT (REQUIRES "useBilling" to be set to true)
Config.extraZonePrice50 = 350 -- THIS IS THE EXTRA COST IF 50 KM/H ABOVE LIMIT (REQUIRES "useBilling" to be set to true)



--Speedcamera Locations
Config.Speedcamera60Zone = {
    --{x = -524.2645,y = -1776.3569,z = 21.3384}
}

Config.Speedcamera80Zone = {
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

Config.Speedcamera120Zone = {
    {x = 1584.9281,y = -993.4557,z = 59.3923},
    {x = 2442.2006,y = -134.6004,z = 88.7765},
    {x = 2871.7951,y = 3540.5795,z = 53.0930},
	{x = -2466.3,y = -220,z = 17.21},
	{x = -2991.5,y = -414.59,z = 14.54},
	{x = -2977.05,y = 2072.94,z = 39.9},
	{x = 848.39,y = 109.64,z = 69.79}
}