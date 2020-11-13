local collected = false
Active = {}

Citizen.CreateThread(function()
    while true do
		Wait(0)
		local player = PlayerPedId()
		local coords = GetEntityCoords(player)
		for i, row in pairs(Collectable) do --looks for table
			Active[row] = {}
		end
		Citizen.Wait(5000)
	end
end)

