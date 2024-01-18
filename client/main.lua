ListOfReports = {}
local teleportBack = false
local bringBack = false

insert = function(t, v)
    t[#t + 1] = v
end

RegisterNetEvent('sarmingo-report:salji-novi-report')
AddEventHandler('sarmingo-report:salji-novi-report', function(noviReport)
    insert(ListOfReports, noviReport)
    Config.Notifications(Strings.newreport .. ' ' .. #ListOfReports)
end)

ValidOption = function(option)
    for _, v in ipairs(Config.Options) do
        if option == v.value then
            return true
        end
    end
    return false
end

removeReport = function(reportId, kategorija, opis, naslov)
    for i, report in ipairs(ListOfReports) do
        if report.id == reportId and report.kategorija == kategorija and report.opis == opis and report.naslov == naslov then
            table.remove(ListOfReports, i)
            Config.Notifications(Strings.removereport)
            break
        end
    end
end

RegisterCommand(Config.reportcommand, function()
    local input = lib.inputDialog(Strings.sendnewreport, {
        {
            type = 'select',
            label = Strings.category,
            options = Config.Options,
            required = true
        },
        { type = 'input', label = Strings.title,       required = true, min = 10, max = 30 },
        { type = 'input', label = Strings.description, required = true, min = 10, max = 255 },
    })

    if ValidOption(input[1]) then
        exports['screenshot-basic']:requestScreenshotUpload(Config.Webhook, 'files[]', {encoding = 'jpg'}, function(data)
            local resp = json.decode(data)
            local imageUrl = resp.attachments[1].url
            TriggerServerEvent('createtable', input[3], input[2], input[1], imageUrl)
        end)    
    end
end, false)


RegisterNetEvent('openmenu', function()
    local list = {}
    for i = 1, #ListOfReports do
        local v = ListOfReports[i]
        if v then
            insert(list, {
                title = 'Report #' .. v.id .. Config.Objasnjenje[v.kategorija],
                description = Strings.id .. ': ' .. v.id .. '｜' .. Strings.name .. ': ' .. v.ime .. '｜' .. Strings.time .. ': ' .. v.vrijeme,
                icon = Config.Icons[v.kategorija],
                iconColor = Config.IconsColor[v.kategorija],
                event = 'newmenu',
                args = { id = v.id, image = v.image, kategorija = v.kategorija, ime = v.ime, vrijeme = v.vrijeme, naslov = v.naslov, opis = v.opis, igime = v.igime, posao = v.posao, banka = v.banka, novac = v.novac, grupa = v.grupa, identifier = v.identifier }
            })
        end
    end

    lib.registerContext({
        id = 'reportovi',
        title = Strings.reports,
        options = list
    })

    lib.showContext('reportovi')
end)

RegisterCommand(Config.replist, function()
    TriggerEvent('openmenu')
end, false)


RegisterNetEvent('newmenu', function(args)
    lib.registerContext({
        id = 'newmenu',
        title = Strings.report .. ' #' .. args.id,
        options = {
            {
                title = Strings.readdescription,
                icon = 'book-reader',
                onSelect = function()
                    local alert = lib.alertDialog({
                        header = Strings.report .. ' #' .. args.id,
                        content = args.opis,
                        centered = true,
                        cancel = false
                    })
                    if alert == 'confirm' then
                        lib.showContext('newmenu')
                    end
                end
            },
            {
                title = Strings.getplayerinfo,
                icon = 'info-circle',
                onSelect = function()
                    local alert = lib.alertDialog({
                        header = Strings.playerinfo,
                        content = '\n' .. Strings.name .. ' - ' .. args.igime .. '\n' ..
                            '\n' .. Strings.job .. ' - ' .. args.posao .. '\n' ..
                            '\n' .. Strings.bank .. ' - $' .. args.banka .. '\n' ..
                            '\n' .. Strings.money .. ' - $' .. args.novac .. '\n' ..
                            '\n' .. Strings.group .. ' - ' .. args.grupa,
                        centered = true,
                        cancel = false
                    })
                    if alert == 'confirm' then
                        lib.showContext('newmenu')
                    end
                end
            },
            {
                title = Strings.copyidentifier,
                icon = 'copy',
                onSelect = function()
                    lib.setClipboard(args.identifier)
                end
            },
            {
                title = Strings.sendmessage,
                icon = 'message',
                onSelect = function()
                    local input = lib.inputDialog(Strings.sendmessageplayer, { Strings.message })

                    if not input then return end
                    TriggerServerEvent('posaljikeporu', args.id, input[1])
                end
            },
            {
                title = Strings.image,
                icon = 'image',
                onSelect = function()
                    TriggerEvent('show_image', args.image)
                end
            },
            {
                title = Strings.giveitem,
                icon = 'gift',
                onSelect = function()
                    local input = lib.inputDialog(Strings.giveitemtoplayer, {
                        { type = 'input',  label = Strings.nameofitem,  required = true },
                        { type = 'number', label = Strings.countofitem, required = false },
                    })
                    TriggerServerEvent('dajitem', input[1], input[2], args.id)
                    if not input then return end
                end
            },
            {
                title = Strings.givevehicle,
                icon = 'car',
                onSelect = function()
                    local input = lib.inputDialog(Strings.spawnvehicle, {
                        { type = 'input', label = Strings.nameofitem, required = true },
                    })
                    TriggerServerEvent('dajvozilo', input[1], args.id)
                    if not input then return end
                end
            },
            {
                title = Strings.fixvehicle,
                icon = 'wrench',
                onSelect = function()
                    TriggerServerEvent('fixvehicle', args.id)
                end
            },
            {
                title = Strings.teleportback,
                disabled = not teleportBack,
                icon = 'arrow-left',
                onSelect = function()
                    TriggerServerEvent('teleportback', args.id)
                    teleportBack = false
                end
            },
            {
                title = Strings.gotoplayer,
                icon = 'arrow-right',
                onSelect = function()
                    TriggerServerEvent('gotoplayer', args.id)
                    teleportBack = true
                end
            },
            {
                title = Strings.bringplayer,
                icon = 'arrow-right',
                onSelect = function()
                    TriggerServerEvent('bringplayer', args.id)
                    bringBack = true
                end
            },
            {
                title = Strings.bringback,
                disabled = not bringBack,
                icon = 'arrow-right',
                onSelect = function()
                    TriggerServerEvent('bringback', args.id)
                    bringBack = false
                end
            },
            {
                title = Strings.reviveplayer,
                icon = 'ambulance',
                onSelect = function()
                    TriggerServerEvent('revive', args.id)
                end
            },
            {
                title = Strings.heal,
                icon = 'heart',
                onSelect = function()
                    TriggerServerEvent('heal', args.id)
                end
            },
            {
                title = Strings.setjob,
                icon = 'heart',
                onSelect = function()
                    TriggerEvent('receiveJobData', args.id)
                end
            },
            {
                title = Strings.concludereport,
                icon = 'check',
                iconColor = 'green',
                onSelect = function()
                    removeReport(args.id, args.kategorija, args.opis, args.naslov)
                end
            }
        }
    })

    lib.showContext('newmenu')
end)

RegisterNetEvent('posaljiporuku', function(poruka)
    local alert = lib.alertDialog({
        header = Strings.messagefrom,
        content = poruka,
        centered = true,
        cancel = false
    })
end)

RegisterNetEvent('dajvozilo:client', function(vehicle)
    local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(playerPed, false) then
        local currentVehicle = GetVehiclePedIsIn(playerPed, false)
        DeleteVehicle(currentVehicle)
    end

    RequestModel(vehicle)
    while not HasModelLoaded(vehicle) do
        Wait(500)
    end
    local pos = GetEntityCoords(playerPed)
    local newVehicle = CreateVehicle(vehicle, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)
    TaskWarpPedIntoVehicle(playerPed, newVehicle, -1)
end)


RegisterNetEvent('fixvehicle:client', function()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        SetVehicleEngineHealth(vehicle, 1000)
        SetVehicleEngineOn(vehicle, true, true)
        SetVehicleBodyHealth(vehicle, 1000)
        SetVehicleFixed(vehicle)
    end
end)

RegisterNetEvent('receiveJobData')
AddEventHandler('receiveJobData', function(target)
    ESX.TriggerServerCallback('fetchJobData', function(jobData)
        if jobData and #jobData > 0 then
            local options = {}
            for _, job in ipairs(jobData) do
                table.insert(options, { value = job.name, label = job.label })
            end
            local input = lib.inputDialog(Strings.setjobmenu, {
                { type = 'select', label = Strings.chosejob, options = options }
            })
            if input and input[1] then
                ESX.TriggerServerCallback('fetchGradeData', function(gradeData)
                    if gradeData and #gradeData > 0 then
                        local gradeOptions = {}
                        for _, grade in ipairs(gradeData) do
                            table.insert(gradeOptions, { value = grade.grade, label = grade.label })
                        end
                        local gradeInput = lib.inputDialog(Strings.setgrademenu, {
                            { type = 'select', label = Strings.chosegrade, options = gradeOptions }
                        })
                        if gradeInput and gradeInput[1] then
                            TriggerServerEvent('setjob', input[1], gradeInput[1], target)
                            lib.showContext('newmenu')
                        else
                        end
                    else
                    end
                end, input[1])
            else
            end
        else
        end
    end)
end)

RegisterNetEvent('notification', function(poruka)
    Config.Notifications(poruka)
end)
