-- YOU CAN CHANGE HERE ZONES --

local zones = {
	{ ['x'] = 2329.767, ['y'] = 2571.442, ['z'] = 46.66882 },
	{ ['x'] = 2220.198, ['y'] = 5585.75, ['z'] = 53.83008 }
}

-- DONT TOUCH ANYTHING OF YOU DONT KNOW WHAT ARE YOU DOING --

local notifIn = false
local notifOut = false
local closestZone = 1

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Wait(0)
	end
	
	while true do
		local playerPed = GetPlayerPed(-1)
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
		local minDistance = 100000
		for i = 1, #zones, 1 do
			dist = Vdist(zones[i].x, zones[i].y, zones[i].z, x, y, z)
			if dist < minDistance then
				minDistance = dist
				closestZone = i
			end
		end
		Wait(15000)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Wait(0)
	end
	
	while true do
		Wait(0)
		local player = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(player, true))
		local dist = Vdist(zones[closestZone].x, zones[closestZone].y, zones[closestZone].z, x, y, z)
	
		if dist <= 50.0 then
			if not notifIn then
				NetworkSetFriendlyFireOption(false)
				TriggerEvent("pNotify:SendNotification",{
					text = "<b style='color:#ff0000'>You just entered OpenFire Zone</b>",
					type = "error",
					timeout = (3000),
					layout = "center",
					queue = "global"
				})
				notifIn = true
				notifOut = false
			end
		else
			if not notifOut then
				NetworkSetFriendlyFireOption(true)
				TriggerEvent("pNotify:SendNotification",{
					text = "<b style='color:#ff0000'>You just exited OpenFire Zone</b>",
					type = "error",
					timeout = (3000),
					layout = "center",
					queue = "global"
				})
				notifOut = true
				notifIn = false
			end
		end
	end
end)