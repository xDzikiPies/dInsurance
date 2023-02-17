Config = {}

Config.Account = 'money' -- bank/money

Config.Price = 1500 -- Price of Insurance

Config.Item = 'insurance'

Config.JobName = 'police'

Config.Markers = {
	{
		coords = vector3(-1079.6155, -255.3278, 37.7633),
		color = { r = 255, g = 0, b = 0 },
		size = { x = 2.0, y = 2.0, z = 2.0 },
		helpText = 'Press ~INPUT_CONTEXT~ to open the insurance menu', -- Change 'INPUT_CONTEXT'  to the button name example ~INPUT_CONTEXT~
		button = 38 -- Change this to the button code you want to use
	},
	-- {
	-- 	coords = vector3(-1080.5, -256.2, 37.7),
	-- 	color = { r = 0, g = 255, b = 0 },
	-- 	size = { x = 2.0, y = 2.0, z = 2.0 },
	-- 	helpText = 'Press ~INPUT_CONTEXT~ to open the insurance menu', -- Change the 'INPUT_CONTEXT' to the button name example ~INPUT_CONTEXT~
	-- 	button = 38 -- Change this to the button code you want to use
	-- }
}


Config.Marker = false --true/false

Config.Target = true -- true/false

Config.TargetName = 'qtarget' -- your third eye script name (qtarget, bt-target, ox_target, etc)

Config['Targets'] = {
	{
		x = -1066.87, 
		y = -240.31, 
		z = 39.73, 
		minZ = 39, 
		maxZ = 41, 
		width = 2, 
		length = 2, 
		label = 'Option1', 
		name = 'Target1', -- This must be unique, dont use the same value
        distance = 2.0,
	},
	{
		x = -1066.87, 
		y = -240.31, 
		z = 42.73, 
		minZ = 42, 
		maxZ = 44, 
		width = 2, 
		length = 2, 
		label = 'Option2', 
		name = 'Target2', -- This must be unique, dont use the same value
        distance = 2.0,
	}
}


RegisterNetEvent('dInsurance:customNotify')
AddEventHandler('dInsurance:customNotify', function(message)
	ESX.ShowNotification(message)
end)


Config['Lang'] = {
['MissingMoney'] = 'You need more money! ',
['plate'] = 'Plate',
['Date'] = 'Issued',
['Bought'] = 'You have bought an insurance!',
['Cancelled'] = 'You have canceled buying your insurance!',
['Title'] = 'Buy insurance, price ',
['Title2'] = 'Buy insurance',
['Accept'] = 'Accept',
['Decline'] = 'Decline',
['VehicleFound'] = 'This vehicle is insured!',
['VehicleNotInsured'] = 'This vehicle is not insured!',
['VehicleNotFound'] = 'Couldnt find this vehicle in database!',
['Unauthorized'] = 'You are not allowed to use this command!',
}