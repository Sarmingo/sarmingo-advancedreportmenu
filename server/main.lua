ListaReportova    = {}
local savedCoords = {}

insert            = function(t, v)
    t[#t + 1] = v
end

RegisterNetEvent('napravitabelu', function(opis, naslov, kategorija)
    local xPlayer = ESX.GetPlayerFromId(source)

    local noviReport = {
        ime = GetPlayerName(source),
        opis = opis,
        naslov = naslov,
        kategorija = kategorija,
        id = source,
        vrijeme = os.date("%H:%M:%S", os.time()),
        igime = xPlayer.getName(),
        posao = xPlayer.getJob().label .. ' - ' .. xPlayer.getJob().grade_label,
        banka = xPlayer.getAccount('bank').money,
        novac = xPlayer.getMoney(),
        grupa = xPlayer.getGroup(),
        identifier = xPlayer.identifier
    }

    local jelpostoji = false
    for _, report in pairs(ListaReportova) do
        if report.id == noviReport.id and
            report.opis == noviReport.opis and
            report.kategorija == noviReport.kategorija and
            report.naslov == noviReport.naslov then
            jelpostoji = true
            break
        end
    end

    if not jelpostoji then
        insert(ListaReportova, noviReport)

        local xPlayers = ESX.GetPlayers()
        for i = 1, #xPlayers, 1 do
            local admin = ESX.GetPlayerFromId(xPlayers[i])
            if Config.DozvoljeneAdminGrupe[admin.getGroup()] then
                TriggerClientEvent("sarmingo-report:salji-novi-report", admin.source, noviReport)
            end
        end
    end
end)

RegisterNetEvent('posaljikeporu', function(id, poruka)
    TriggerClientEvent('posaljiporuku', id, poruka)
end)

RegisterNetEvent('dajitem', function(item, count, target)
    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    local xPlayer = ESX.GetPlayerFromId(source)
    if Config.DozvoljeneAdminGrupe[xPlayer.getGroup()] then
        xTarget.addInventoryItem(item, tonumber(count) or 1)
    end
end)

RegisterNetEvent('dajvozilo', function(vehicle, target)
    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    local xPlayer = ESX.GetPlayerFromId(source)
    if Config.DozvoljeneAdminGrupe[xPlayer.getGroup()] then
        TriggerClientEvent('dajvozilo:client', xTarget.source, vehicle)
    end
end)

RegisterNetEvent('fixvehicle', function(target)
    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    local xPlayer = ESX.GetPlayerFromId(source)
    if Config.DozvoljeneAdminGrupe[xPlayer.getGroup()] then
        TriggerClientEvent('fixvehicle:client', xTarget.source)
    end
end)

RegisterNetEvent('gotoplayer', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)
    if Config.DozvoljeneAdminGrupe[xPlayer.getGroup()] then
        if xTarget then
            local targetCoords = xTarget.getCoords()
            local playerCoords = xPlayer.getCoords()
            savedCoords[target] = targetCoords
            xTarget.setCoords(playerCoords)
        end
    end
end)

RegisterNetEvent('teleportback', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)
    if Config.DozvoljeneAdminGrupe[xPlayer.getGroup()] then
        if xTarget then
            local playerCoords = savedCoords[target]
            if playerCoords then
                xTarget.setCoords(playerCoords)
                savedCoords[target] = nil
            end
        end
    end
end)


RegisterNetEvent('bringplayer', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)
    if Config.DozvoljeneAdminGrupe[xPlayer.getGroup()] then
        if xTarget then
            local targetCoords = xTarget.getCoords()
            local playerCoords = xPlayer.getCoords()
            savedCoords[target] = targetCoords
            xTarget.setCoords(playerCoords)
        else
        end
    end
end)

RegisterNetEvent('bringback', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)
    if Config.DozvoljeneAdminGrupe[xPlayer.getGroup()] then
        if xTarget then
            local playerCoords = savedCoords[target]
            if playerCoords then
                xTarget.setCoords(playerCoords)
                savedCoords[target] = nil
            else
            end
        else
        end
    end
end)

RegisterNetEvent('revive', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if Config.DozvoljeneAdminGrupe[xPlayer.getGroup()] then
        TriggerClientEvent('esx_ambulancejob:revive', target)
    end
end)

ESX.RegisterServerCallback('fetchJobData', function(source, cb)
    MySQL.Async.fetchAll("SELECT name, label FROM jobs", {}, function(jobData)
        cb(jobData)
    end)
end)

ESX.RegisterServerCallback('fetchGradeData', function(source, cb, jobName)
    MySQL.Async.fetchAll("SELECT grade, label FROM job_grades WHERE job_name = @jobName", { ["@jobName"] = jobName }, function(gradeData)
        cb(gradeData)
    end)
end)


RegisterNetEvent('heal', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if Config.DozvoljeneAdminGrupe[xPlayer.getGroup()] then
        TriggerClientEvent('esx_basicneeds:healPlayer', target)
    end
end)

RegisterServerEvent('setjob', function(job, grade, target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if Config.DozvoljeneAdminGrupe[xPlayer.getGroup()] then
        local xTarget = ESX.GetPlayerFromId(target)
        xTarget.setJob(job, grade)
        TriggerClientEvent('notification', target,
            xTarget.getJob().label .. ' - ' .. xTarget.getJob().grade_label .. ' ' .. Strings.hasbeen)
    end
end)
