MySQL.ready(function()
    MySQL.Async.fetchAll("SHOW COLUMNS FROM owned_vehicles LIKE 'insurance'", {}, function(columns)
        if #columns == 0 then
            MySQL.Async.execute("ALTER TABLE owned_vehicles ADD COLUMN insurance INT NOT NULL DEFAULT 0", {})
        end
    end)
end)

ESX.RegisterServerCallback('dInsurance:getData', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    local cars = {}
    MySQL.Async.fetchAll("SELECT plate, insurance FROM owned_vehicles WHERE owner = @owner AND insurance = 0", {
        ['@owner'] = xPlayer.identifier,
    }, function(result)
        for _, v in pairs(result) do
            table.insert(cars, {plate = v.plate, ins = v.insurance})
        end
        cb(cars)
    end)
end)

RegisterServerEvent('dInsurance:registerNewCar')
AddEventHandler('dInsurance:registerNewCar', function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = os.date('*t')
    if not xPlayer then return end 
    if xPlayer.getAccount(Config.Account).money >= Config.Price then 
        MySQL.Async.execute("UPDATE owned_vehicles SET insurance = 1 WHERE plate = @plate", {
            ['@plate'] = plate,
        }, function()
        end) 
        xPlayer.removeAccountMoney(Config.Account, Config.Price)
        TriggerClientEvent('dInsurance:customNotify', source, Config['Lang']['Bought'])
        exports.ox_inventory:AddItem(xPlayer.source, Config.Item, 1, {
            description = Config['Lang']['plate'].." "..plate.."\n\n"..Config['Lang']['Date'].." "..data.day.."/"..data.month.."/"..data.year.." - "..data.hour..":"..data.min..""
        })
    else 
        local missingmoney = Config.Price - xPlayer.getAccount('money').money 
        TriggerClientEvent('dInsurance:customNotify', source,  Config['Lang']['MissingMoney']..missingmoney.."$")
    end
end)




