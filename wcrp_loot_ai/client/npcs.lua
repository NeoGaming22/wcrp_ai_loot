--[[ this is Crypto's RedEM script Converted to VORP, 
I've Added a more random item loot system.
]]

local looting, collected, active = false, false, false

Citizen.CreateThread(function()

	Citizen.InvokeNative(0x4CC5F2FC1332577F, 1058184710) 
    while true do
		Wait(0)
		local player = PlayerPedId()
		local coords = GetEntityCoords(player)
		local entityHit = 0
		local shapeTest = StartShapeTestBox(coords.x, coords.y, coords.z, 2.0, 2.0, 2.0, 0.0, 0.0, 0.0, true, 8, player)
		local rtnVal, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
		local type = GetPedType(entityHit)
		local dead = IsEntityDead(entityHit)
		local PressTime = 0
		local entity = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())
		local model = GetEntityModel(entityHit)
		local quality = Citizen.InvokeNative(0x31FEF6A20F00B963, entityHit) --need to check the qly for better looting
		if IsControlJustPressed(0,1101824977) and not IsPedInAnyVehicle(player, true) and not looting then
			local shape = true
			while shape do
				Wait(0)
				if type == 4 and dead then
					local looted = Citizen.InvokeNative(0x8DE41E9902E85756, entityHit)
					if not looted then
						shape = false
						looting = true
						PressTime = GetGameTimer()
						while looting do
							Wait(0)
							if IsControlJustReleased(0,1101824977) then
								KeyHeldTime = GetGameTimer() - PressTime
								PressTime = 0
								if KeyHeldTime > 250 then
									looting = false
									Wait(500)
									local lootedcheck = Citizen.InvokeNative(0x8DE41E9902E85756, entityHit)
									if lootedcheck then
										local randomroll = math.random(1,25)
										local loot = math.random(1, 3)
										local lootpay = loot / 100
										-- local xppay = math.random(0, 2)
										TriggerServerEvent("loot:addmoney", lootpay)
										-- TriggerServerEvent("loot:addxp", xppay)
										--Soon Add Karma System
										for i, row in pairs(Loot) do
												if randomroll == Loot[i]["number"]then
													TriggerServerEvent("loot:add", Loot[i]["item"])
												end
										end	
									else
										looting = false
									end
									looting = false
								end
							end
						end	
					end	
				end
			end
		end
	end
end)

