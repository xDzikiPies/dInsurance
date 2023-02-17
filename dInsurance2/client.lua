menuOpen = false 
menuopen = false
ESX = nil 
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


RegisterNetEvent('dInsurance:openInsuranceShop')
AddEventHandler('dInsurance:openInsuranceShop', function()
	OpenMainMenu()
end)


function OpenMainMenu()
	lib.registerContext({
        id = 'dInsurance_main',
        title = Config['Lang']['Title'],
        options = {
            {
                title = Config['Lang']['BuyInsurance'],
                event = 'dInsurance:buyIns'
            },
            {
                title = Config['Lang']['BuyCopy'],
                event = 'dInsurance:buyCopy'
            },
			{
                title = Config['Lang']['RemoveInsurance'],
                event = 'dInsurance:removeInsurance123'
            },
        }
    })
	lib.showContext('dInsurance_main')

end


function OpenRemoveShop()
	lib.hideContext(false)
	ESX.TriggerServerCallback("dInsurance:getDataRemove", function(vehicles)

		local options = {}

		for k, v in pairs(vehicles) do
			options[v.plate] = {
				event = 'dInsuranceRemove:yesorno',
				args = {
					plate = v.plate
				},
				arrow = true
			}
		end

		lib.registerContext({
			onExit = function()
				menuOpen = false
				menuopen = false
			end,
			id = 'dInsuranceRemove_shop',
			title = Config['Lang']['RemoveTitle2'],
			options = options
		})
		lib.showContext('dInsuranceRemove_shop')
	end)
end

AddEventHandler('dInsurance:buyIns', function()
	OpenKeyShop()
end)

AddEventHandler('dInsurance:buyCopy', function()
	OpenKeyCopy()
end)

AddEventHandler('dInsurance:removeInsurance123', function()
	OpenRemoveShop()
end)

function OpenKeyCopy()
	lib.hideContext(false)
	ESX.TriggerServerCallback("dInsurance:getDataRemove", function(vehicles)

		local options = {}

		for k, v in pairs(vehicles) do
			options[v.plate] = {
				event = 'dInsurance:yesorno',
				args = {
					plate = v.plate
				},
				arrow = true
			}
		end

		lib.registerContext({
			onExit = function()
				menuOpen = false
				menuopen = false
			end,
			id = 'dInsurance_Copy',
			title = Config['Lang']['Title2'],
			options = options
		})
		lib.showContext('dInsurance_Copy')
	end)
end



function OpenKeyShop()
	lib.hideContext(false)
	ESX.TriggerServerCallback("dInsurance:getData", function(vehicles)

		local options = {}

		for k, v in pairs(vehicles) do
			options[v.plate] = {
				event = 'dInsurance:yesorno',
				args = {
					plate = v.plate
				},
				arrow = true
			}
		end

		lib.registerContext({
			onExit = function()
				menuOpen = false
				menuopen = false
			end,
			id = 'dInsurance_shop',
			title = Config['Lang']['Title2'],
			options = options
		})
		lib.showContext('dInsurance_shop')
	end)
end


AddEventHandler('dInsurance:yesorno', function(data)
    lib.hideContext(false)
    lib.registerContext({
        id = 'dInsurance_yesorno',
        title = Config['Lang']['Title'],
        options = {
            {
                title = Config['Lang']['Accept'],
                event = 'dInsurance:buykeylol',
                args = {
                    plate = data.plate
                }
            },
            {
                title = Config['Lang']['Decline'],
                menu = 'dInsurance_shop'
            }
        }
    })
    lib.showContext('dInsurance_yesorno')
end)


AddEventHandler('dInsuranceRemove:yesorno', function(data)
    lib.hideContext(false)
    lib.registerContext({
        id = 'dInsuranceRemove_yesorno',
        title = Config['Lang']['RemoveTitle'],
        options = {
            {
                title = Config['Lang']['Accept'],
                event = 'dInsurance:removeInsurance',
                args = {
                    plate = data.plate
                }
            },
            {
                title = Config['Lang']['Decline'],
                menu = 'dInsurance_main'
            }
        }
    })
    lib.showContext('dInsuranceRemove_yesorno')
end)


AddEventHandler('dInsurance:buykeylol', function(data)
    TriggerServerEvent('dInsurance:registerNewCar', data.plate)
	menuOpen = false
	menuopen = false
end)

AddEventHandler('dInsurance:removeInsurance', function(data)
    TriggerServerEvent('dInsurance:removeInsurance', data.plate)
	menuOpen = false
	menuopen = false
end)

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
					OpenMainMenu()
				end
			else 
				menuopen = false
			end
		end
	end)
end





if Config.Target then 
	if Config.TargetName == '' then return print('You left your target name empty!') end 
	if Config.TargetName == 'ox_target' then 
		for i = 1, #Config.Targets do 
			local target = Config.Targets[i]
			exports[Config.TargetName]:addBoxZone({
				coords = vec3(target.x, target.y, target.z),
				size = vec3(target.width, target.length, 2),
				rotation = 45,
				debug = false,
				options = {
					{
						name = target.name,
						event = "dInsurance:openInsuranceShop",
						icon = "fas fa-car",
						label = target.label,
					}
				}
			})
		end
	else
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
end
	
