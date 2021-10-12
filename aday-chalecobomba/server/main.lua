ESX  = nil TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterUsableItem('chaleco_bomba', function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem("chaleco_bomba", 1) 
    TriggerClientEvent('chalecobomba', source)  
    TriggerClientEvent('inmolarse', source)
end)