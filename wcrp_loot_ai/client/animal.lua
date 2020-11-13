local collected, active = false, false
local skinnable = true
local skinPrompt , pickupPromt
local skingroup = group
local prompt, prompt2  =  false, false
killtable = {}
local cfg = false
Citizen.CreateThread(function()
	SetupskinPrompt() -- start prompts
	SetuppickupPrompt()-- start prompts

    while true do
		Wait(0)
		local player = PlayerPedId()
		local coords = GetEntityCoords(player)
		local entityHit = 0
		local shapeTest = StartShapeTestBox(coords.x, coords.y, coords.z, 2.0, 2.0, 2.0, 0.0, 0.0, 0.0, true, 10, player)
		local rtnVal, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
		local type = GetPedType(entityHit)
		local dead = IsEntityDead(entityHit)
		killtable[#killtable+1] = dead
		local PressTime = 0
		local entity = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())
		local model = GetEntityModel(entityHit)
		local quality = Citizen.InvokeNative(0x31FEF6A20F00B963, dead) --need to check the qly for better looting

		if type == 28 then 
			for i, row in pairs(Animal)do	
				if skinnable then
					if model == Animal[i]["model"] then
						PromptSetEnabled(skinPrompt, true)--turns prompt on
						PromptSetVisible(skinPrompt, true)--turns prompt on
						if PromptHasHoldModeCompleted(skinPrompt) then 
							PromptSetEnabled(skinPrompt, false)--turns prompt off
							PromptSetVisible(skinPrompt, false)--turns prompt off
							AnimLooting()
							-- TriggerServerEvent("loot:addxp", 20) -- once there is Cores this needs to be changed to DeadEye

								TriggerServerEvent("loot:add", Animal[i]["item"])
								Wait(1000)
								TriggerServerEvent("loot:add", Animal[i]["item2"])
 								--deleting for now. until I know how to change the models to the skinned Models
								SetEntityAsMissionEntity(entityHit)
								DeleteEntity(entityHit) --deleting for now. 
								carcuss = Animal[i]["carcuss"]
								Citizen.CreateThread(function()
									local object = CreateObject(carcuss, coords.x, coords.y, coords.z, true, true, false)
									PlaceObjectOnGroundProperly(object)
									Citizen.Wait(20000)
									DeleteObject(object)
								end)
								prompt,prompt2 = false, false
								
							break
							PromptSetEnabled(cskinPrompt, false)--turns prompt off
							PromptSetVisible(cskinPrompt, false)--turns prompt off

						end
					end
				end
			end	
		end
	end
end)


function AnimLooting()-- do cleaner anims 
	TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 10000, true, false, false, false)
	Wait(4000)
	TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_STAND_WAITING'), 10000, true, false, false, false)
	Wait(2000)
	ClearPedTasksImmediately(PlayerPedId())
end

function SetupskinPrompt()
	Citizen.CreateThread(function()
        local str = 'SKIN'
        skinPrompt = PromptRegisterBegin()
        PromptSetControlAction(skinPrompt, 0xDFF812F9) --[[E]]
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(skinPrompt, str)
        PromptSetEnabled(skinPrompt, false)
        PromptSetVisible(skinPrompt, false)
        PromptSetHoldMode(skinPrompt, true)
		PromptRegisterEnd(skinPrompt)
    end)
end
function SetuppickupPrompt()
	Citizen.CreateThread(function()
        local str = 'PICK-UP'
        pickupPrompt = PromptRegisterBegin()
        PromptSetControlAction(pickupPrompt, 0xE30CD707)--[[R]]
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(pickupPrompt, str)
        PromptSetEnabled(pickupPrompt, false)
        PromptSetVisible(pickupPrompt, false)
        PromptSetHoldMode(pickupPrompt, true)
        PromptRegisterEnd(pickupPrompt)
    end)
end
