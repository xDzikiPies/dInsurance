menuOpen = false 
menuopen = false
RegisterNetEvent('dInsurance:openInsuranceShop')
AddEventHandler('dInsurance:openInsuranceShop', function()
	OpenKeyShopMenu()
end)

function OpenKeyShopMenu()
	local playerPed  = PlayerPedId()
	local elements = {}
	
	ESX.TriggerServerCallback("dInsurance:getData", function(vehicles)
		
        for k, v in pairs(vehicles) do
            table.insert(elements, {label = v.plate, ins = v.insurance})
        end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), "shop_main_menu",
			{
				title    = Config['Lang']['Title2'],
				align    = "center",
				elements = elements
			},
		function(data, menu)
			menu.close()
			OpenRegisterCarMenu(data.current.label, data.current.ins)
		end, function(data, menu)
			menu.close()
			ESX.UI.Menu.CloseAll()
			menuopen = false
			menuOpen = false
		end)
	end)
end

-- Function to confirm registering a new key
function OpenRegisterCarMenu(plate)	
	local elements = {
		{ label = Config['Lang']['Accept'], value = "reg_accept" },
		{ label = Config['Lang']['Decline'], value = "reg_decline" },
	}
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "register_car_confirm",
		{
			title    = Config['Lang']['Title']..tostring(Config.Price),
			align    = "center",
			elements = elements
		},
	function(data, menu)
		if(data.current.value == 'reg_accept') then
			TriggerServerEvent('dInsurance:registerNewCar', plate)
			menuopen = false
			menu.close()
			ESX.UI.Menu.CloseAll()
			menuOpen = false
		end
		if(data.current.value == 'reg_decline') then
			menu.close()
			TriggerEvent('dInsurance:customNotify', Config['Lang']['Cancelled'])
			OpenKeyShopMenu()
		end
		menu.close()
	end, function(data, menu)
		menu.close()
		OpenKeyShopMenu()
	end)
end


if Config.Marker then 
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			local ped = PlayerPedId()
			local playerCoords = GetEntityCoords(ped)
			local isInMarker = false
			local markerIndex = 0
			for i = 1, #Config.Markers do
				local marker = Config.Markers[i]
				local distance = #(playerCoords - marker.coords)
				if distance < 10.0 then
					DrawMarker(23, marker.coords.x, marker.coords.y, marker.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, marker.size.x, marker.size.y, marker.size.z, marker.color.r, marker.color.g, marker.color.b, 50, false, true, 2, nil, nil, false)
					if distance < 2.0 then
						isInMarker = true
						markerIndex = i
					end
				end
			end

			if isInMarker and not menuopen then
				ESX.ShowHelpNotification(Config.Markers[markerIndex].helpText, false, true, 5000)
				if IsControlJustPressed(0, Config.Markers[markerIndex].button) then
					menuopen = true 
					OpenKeyShopMenu()
				end
			else 
				menuopen = false
			end
		end
	end)
end



if Config.Target then 
	if Config.TargetName == '' then return print('You left your target name empty!') end 
	for i = 1, #Config.Targets do
		local target = Config.Targets[i]
		exports[Config.TargetName]:AddBoxZone(target.name, vector3(target.x, target.y, target.z), target.width, target.length, {
			name=target.name,
			heading=0.0,
			debugPoly=false,
			minZ=target.minZ,
			maxZ=target.maxZ,
		}, {
			options = {
				{
					event = "dInsurance:openInsuranceShop",
					icon = "fas fa-car",
					label = target.label,
					job = 'all',
				},
			},
			distance = target.distance
		})
	end
end
	
