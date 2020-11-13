local collected, active = false, false
local skinnable = true
local cskinPrompt , cpickupPromt
local skingroup = group
local cprompt, cprompt2, prompt3 = false, false
killtable = {}

Citizen.CreateThread(function()
	SetupcskinPrompt () -- start prompts

    while true do
		Wait(0)
		local player = PlayerPedId()
		local coords = GetEntityCoords(player)
		local entityHit = 0
		local shapeTest = StartShapeTestBox(coords.x, coords.y, coords.z, 2.0, 2.0, 2.0, 0.0, 0.0, 0.0, true, 8, player)
		local rtnVal, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
		local type = GetPedType(entityHit)
		local dead = IsEntityDead(entityHit)
		killtable[#killtable+1] = dead
		local PressTime = 0
		local entity = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())
		local model = GetEntityModel(entityHit)
		local quality = Citizen.InvokeNative(0x31FEF6A20F00B963, entityHit) --need to check the qly for better looting

		if type == 28 then 
			--print(model)
			for i, row in pairs(Critter)do	
				if skinnable then
					if model == Critter[i]["model"] then
						PromptSetEnabled(cskinPrompt, true)--turns prompt on
						PromptSetVisible(cskinPrompt, true)--turns prompt on
						if PromptHasHoldModeCompleted(cskinPrompt) then 
							PromptSetEnabled(cskinPrompt, false)--turns prompt off
							PromptSetVisible(cskinPrompt, false)--turns prompt off
							AnimLooting()
							-- TriggerServerEvent("loot:addxp", 20) -- once there is Cores this needs to be changed to DeadEye
							TriggerServerEvent("loot:add", Critter[i]["item"])
 							--deleting for now. until I know how to change the models to the skinned Models
							SetEntityAsMissionEntity(entityHit)
							DeleteEntity(entityHit) --deleting for now. 
							--spawn skinned corpse
							carcuss = 94387424
							local object = CreateObject(carcuss, x, y, z, true, true, false)
							PlaceObjectOnGroundProperly(carcuss)
							prompt,prompt2 = false, false
							skinnable = false
							break
							PromptSetEnabled(cskinPrompt, false)--turns prompt off
							PromptSetVisible(cskinPrompt, false)--turns prompt off
							skinnable = false
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

function SetupcskinPrompt ()
	Citizen.CreateThread(function()
        local str = 'SKIN'
        cskinPrompt  = PromptRegisterBegin()
        PromptSetControlAction(cskinPrompt , 0xDFF812F9) --[[E]]
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(cskinPrompt , str)
        PromptSetEnabled(cskinPrompt , false)
        PromptSetVisible(cskinPrompt , false)
        PromptSetHoldMode(cskinPrompt , true)
		PromptRegisterEnd(cskinPrompt )
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




