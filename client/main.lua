local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

local function debugPrint(...)
    if Config.Debug then
        print("[DEBUG]", ...)
    end
end

exports('startProgress', function(options, callback)
    debugPrint("startProgress called with options:", json.encode(options))

    if type(options) ~= 'table' then
        debugPrint("Invalid options type:", type(options))
        if callback then callback(false) end
        return
    end

    local playerPed = PlayerPedId()
    local duration = options.duration or 3000
    local label = options.text or 'Processing...'
    local canCancel = options.canCancel ~= false
    local freezePlayer = options.freeze or false
    local useWhileDead = options.useWhileDead or false
    local disable = options.disable or {
        move = true,
        car = true,
        combat = true,
    }

    debugPrint("Duration:", duration, "Label:", label, "CanCancel:", canCancel, "FreezePlayer:", freezePlayer)

    if disable then
        debugPrint("Disabling controls:", disable)
        CreateThread(function()
            while true do
                if disable.move then
                    DisableControlAction(0, 21, true)
                    DisableControlAction(0, 22, true)
                end
                if disable.car then
                    DisableControlAction(0, 63, true)
                    DisableControlAction(0, 64, true)
                end
                if disable.combat then
                    DisablePlayerFiring(playerPed, true)
                end
                Wait(0)
            end
        end)
    end

    if freezePlayer then
        debugPrint("Freezing player")
        FreezeEntityPosition(playerPed, true)
    end

    if options.anim and options.anim.dict and options.anim.clip then
        debugPrint("Playing animation:", options.anim.dict, options.anim.clip)
        loadAnimDict(options.anim.dict)
        TaskPlayAnim(playerPed, options.anim.dict, options.anim.clip, 8.0, -8.0, duration, 1, 0, false, false, false)
    end

    local propEntity
    if options.prop and options.prop.model then
        local model = options.prop.model
        debugPrint("Loading prop model:", model)
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(0) end

        local pos = GetEntityCoords(playerPed)
        local bone = GetPedBoneIndex(playerPed, 57005)

        propEntity = CreateObject(model, pos.x, pos.y, pos.z + 0.2, true, true, true)
        debugPrint("Created prop:", propEntity)
        AttachEntityToEntity(
            propEntity,
            playerPed,
            bone,
            options.prop.pos and options.prop.pos.x or 0.0,
            options.prop.pos and options.prop.pos.y or 0.0,
            options.prop.pos and options.prop.pos.z or 0.0,
            options.prop.rot and options.prop.rot.x or 0.0,
            options.prop.rot and options.prop.rot.y or 0.0,
            options.prop.rot and options.prop.rot.z or 0.0,
            true,
            true,
            false,
            true,
            1,
            true
        )
        debugPrint("Attached prop to player")
    end

    SendNUIMessage({
        action = "start",
        text = label,
        duration = duration
    })
    debugPrint("NUI message sent")

    local cancelled = false
    local endTime = GetGameTimer() + duration

    CreateThread(function()
        while GetGameTimer() < endTime do
            if canCancel and IsControlJustPressed(0, 202) then
                cancelled = true
                debugPrint("Progress cancelled by player")
                break
            end
            Wait(0)
        end
    end)

    Citizen.Wait(duration)

    ClearPedTasks(playerPed)
    debugPrint("Animation cleared")

    if freezePlayer then
        FreezeEntityPosition(playerPed, false)
        debugPrint("Player unfrozen")
    end

    if propEntity then
        DeleteEntity(propEntity)
        debugPrint("Prop deleted")
    end

    if not cancelled and options.notify then
        debugPrint("Sending notification")
        if Config.NotifyType == "ox" and lib and lib.notify then
            lib.notify({
                title = options.notify,
                description = options.notify2 or "",
                type = options.type or "info",
            })
        elseif Config.NotifyType == "custom" then
            TriggerEvent('Menco_progressbar:notify', options.notify, options.notify2 or "", options.type or "info")
        end
    end

    if callback then
        debugPrint("Calling callback, success:", not cancelled)
        callback(not cancelled)
    end
end)