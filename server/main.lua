ListOfReports    = {}
local savedCoords = {}

insert            = function(t, v)
    t[#t + 1] = v
end

RegisterNetEvent('createtable', function(opis, naslov, kategorija, image)
    local xPlayer = ESX.GetPlayerFromId(source)
    local newReport = {
        ime = GetPlayerName(source),
        opis = opis,
        naslov = naslov,
        kategorija = kategorija,
        id = source,
        image = image,
        vrijeme = os.date("%H:%M:%S", os.time()),
        igime = xPlayer.getName(),
        posao = xPlayer.getJob().label .. ' - ' .. xPlayer.getJob().grade_label,
        banka = xPlayer.getAccount('bank').money,
        novac = xPlayer.getMoney(),
        grupa = xPlayer.getGroup(),
        identifier = xPlayer.identifier
    }

    local alreadyexists = false
    for _, report in pairs(ListOfReports) do
        if report.id == newReport.id and
            report.opis == newReport.opis and
            report.kategorija == newReport.kategorija and
            report.naslov == newReport.naslov then
            alreadyexists = true
            break
        end
    end

    if not alreadyexists then
        insert(ListOfReports, newReport)

        local xPlayers = ESX.GetPlayers()
        for i = 1, #xPlayers, 1 do
            local admin = ESX.GetPlayerFromId(xPlayers[i])
            if Config.AllowedGroups[admin.getGroup()] then
                TriggerClientEvent("sarmingo-report:salji-novi-report", admin.source, newReport)
                logs('Send Report', 'Name: ' ..GetPlayerName(source).. '\nDescription: ' ..opis.. '\nTitle: ' ..naslov.. '\nCategory: ' ..kategorija.. '\nTime: ' ..os.date("%H:%M:%S", os.time()).. '\nIG Name: ' ..xPlayer.getName().. '\nJob: ' ..xPlayer.getJob().label .. ' - ' .. xPlayer.getJob().grade_label.. '\nBank: ' ..xPlayer.getAccount('bank').money.. '\nMoney: ' ..xPlayer.getMoney().. '\nGrupa: ' ..xPlayer.getGroup().. '\nIdentifier: ' ..xPlayer.identifier, image)
            end
        end
    end
end)

RegisterNetEvent('posaljikeporu', function(id, poruka)
    TriggerClientEvent('posaljiporuku', id, poruka)
    logs('Send Message', GetPlayerName(source).. " sent a message " ..poruka.. " to the player " ..GetPlayerName(target))
end)

RegisterNetEvent('dajitem', function(item, count, target)
    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    local xPlayer = ESX.GetPlayerFromId(source)
    if Config.AllowedGroups[xPlayer.getGroup()] then
        xTarget.addInventoryItem(item, tonumber(count) or 1)
        logs('Give Item', GetPlayerName(source).. " gave the item " ..item.. " " ..count.. "x to the player " ..GetPlayerName(target))
    end
end)

RegisterNetEvent('dajvozilo', function(vehicle, target)
    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    local xPlayer = ESX.GetPlayerFromId(source)
    if Config.AllowedGroups[xPlayer.getGroup()] then
        TriggerClientEvent('dajvozilo:client', xTarget.source, vehicle)
        logs('Give Vehicle', GetPlayerName(source).. " gave the vehicle to the player " ..GetPlayerName(target))
    end
end)

RegisterNetEvent('fixvehicle', function(target)
    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    local xPlayer = ESX.GetPlayerFromId(source)
    if Config.AllowedGroups[xPlayer.getGroup()] then
        TriggerClientEvent('fixvehicle:client', xTarget.source)
        logs('Fix Vehicle', GetPlayerName(source).. " repaired the player's vehicle " ..GetPlayerName(target))
    end
end)

RegisterNetEvent('gotoplayer', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)
    if Config.AllowedGroups[xPlayer.getGroup()] then
        if xTarget then
            local targetCoords = xTarget.getCoords()
            savedCoords[target] = targetCoords
            xPlayer.setCoords(targetCoords)
            logs('Goto Player', GetPlayerName(source).. " went the player " ..GetPlayerName(target))
        end
    end
end)

RegisterNetEvent('teleportback', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)
    if Config.AllowedGroups[xPlayer.getGroup()] then
        if xTarget then
            local playerCoords = savedCoords[target]
            if playerCoords then
                xTarget.setCoords(playerCoords)
                logs('Teleport Player Back', GetPlayerName(source).. ' has returned itself to its last location ')
                savedCoords[target] = nil
            end
        end
    end
end)


RegisterNetEvent('bringplayer', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)
    if Config.AllowedGroups[xPlayer.getGroup()] then
        if xTarget then
            local targetCoords = xTarget.getCoords()
            local playerCoords = xPlayer.getCoords()
            savedCoords[target] = targetCoords
            xTarget.setCoords(playerCoords)
            logs('Bring Player', GetPlayerName(source).. ' brought the player to him ' ..GetPlayerName(target))
        else
        end
    end
end)

RegisterNetEvent('bringback', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)
    if Config.AllowedGroups[xPlayer.getGroup()] then
        if xTarget then
            local playerCoords = savedCoords[target]
            if playerCoords then
                xTarget.setCoords(playerCoords)
                logs('Bring Back', GetPlayerName(source).. ' returned the player to his last location ' ..GetPlayerName(target))
                savedCoords[target] = nil
            else
            end
        else
        end
    end
end)

RegisterNetEvent('revive', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if Config.AllowedGroups[xPlayer.getGroup()] then
        TriggerClientEvent('esx_ambulancejob:revive', target)
        logs('Revive', GetPlayerName(source).. ' has revived the player ' ..GetPlayerName(target))
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
    if Config.AllowedGroups[xPlayer.getGroup()] then
        TriggerClientEvent('esx_basicneeds:healPlayer', target)
        logs('Heal', GetPlayerName(source).. ' has healed the player ' ..GetPlayerName(target))
    end
end)

RegisterNetEvent('setjob', function(job, grade, target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if Config.AllowedGroups[xPlayer.getGroup()] then
        local xTarget = ESX.GetPlayerFromId(target)
        xTarget.setJob(job, grade)
        TriggerClientEvent('notification', target, xTarget.getJob().label .. ' - ' .. xTarget.getJob().grade_label .. ' ' .. Strings.hasbeen)
        logs('Set Job', GetPlayerName(source).. ' gave the job ' ..xTarget.getJob().label .. ' - ' .. xTarget.getJob().grade_label .. ' to the player ' ..GetPlayerName(target))
    end
end)


function logs(name, message, image)
    local vrijeme = os.date('*t')
        local poruka = {
            {
                ["color"] = 0,--
                ["title"] = "".. name .."",
                ["description"] = message,
                ['image'] = {
                    ['url'] = image or ""
                }
            }
          }
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({username = "Logovi", embeds = poruka, avatar_url = ""}), { ['Content-Type'] = 'application/json' })
  end
