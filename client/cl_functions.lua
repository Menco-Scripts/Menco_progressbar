RegisterNetEvent('Menco_progressbar:notify')
AddEventHandler('Menco_progressbar:notify', function(title, description, ntype)
    print(title, description, ntype)
end)