data = {}

VorpInv = exports.vorp_inventory:vorp_inventoryApi()

local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

-- RegisterServerEvent('safelockpick')
-- AddEventHandler("safelockpick", function()
--     local _source = source
--     print('gotid')
--     local count = VORP.getItemCount(_source, "lockpick")

--     if count >= 1 then
--         VORP.subItem(_source, "lockpick", 1)

--         print('itemtaken')
        
--         TriggerClientEvent('WantedRobbing:TriggerRobbery', _source)

--         Wait(20000)

-- 		TriggerClientEvent("vorp:TipBottom", _source, "You picked the safe", 2000)
-- 	else
-- 		TriggerClientEvent("vorp:TipBottom", _source, "You do not have lockpicks", 2000)

--     end
-- end)


RegisterServerEvent("loot:add")
AddEventHandler("loot:add", function(item)
		local _item = item
		local _source = source
		local randomitem =  math.random(1,2)
		VorpInv.addItem(_source, _item, randomitem)
		-- TriggerClientEvent("vorp:TipRight", _source, _item, 3000)
		TriggerClientEvent("vorp:TipRight",_source,'Found...'.._item, 3000)
end)

RegisterServerEvent('loot:addmoney')
AddEventHandler('loot:addmoney', function(price)
	local Character = VorpCore.getUser(source).getUsedCharacter
    u_identifier = Character.identifier
    u_charid = Character.charIdentifier
    u_money = Character.money
	local _source = source
	local _price = tonumber(price)
	Character.addCurrency(0, _price)
	-- TriggerClientEvent("vorp:TipRight", _source,'$'.._price, 3000)
	TriggerClientEvent("vorp:TipRight",_source,'Found...'.._price, 3000)
end)

-- RegisterServerEvent('loot:addxp')
-- AddEventHandler('loot:addxp', function(xppay)
-- 	local _source = source
-- 	local _xppay = tonumber(xppay)
-- 	TriggerEvent("vorp:addXp", _source, xppay)
-- 	TriggerClientEvent("vorp:TipRight", _source, '+'..xppay..' XP', 3000)
-- end)

RegisterNetEvent('loot:giveItem')
AddEventHandler('loot:giveItem', function(item)
	local _item = items -- This just doesnt work?!?!
    local _source = source
	local randomitem =  math.random(0,5)
	VorpInv.addItem(_source, _item, randomitem)
	TriggerClientEvent("vorp:TipRight", _source, item, 3000)
end)