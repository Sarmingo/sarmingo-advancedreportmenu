Config = {
    reportcommand = 'sendreport',

    DozvoljeneAdminGrupe = {
        ['admin'] = true,
    },

    replist = 'replist',

    Ikonice = {
        ['bug'] = 'bug',
        ['pitanje'] = 'question',
        ['prijaviig'] = 'bullhorn'
    },

    IkoniceBoja = {
        ['bug'] = '#Ee5026',
        ['pitanje'] = '#1dc978',
        ['prijaviig'] = '#Ee9b26'
    },

    Notifications = function(message)
        lib.notify({
            title = '',
            description = message,
            position = 'bottom-right',
            type = 'success'
        })
    end,

    Opcije = {
        {
            value = 'pitanje',
            label = 'Question'
        },
        {
            value = 'prijaviig',
            label = 'Player Report'
        },
        {
            value = 'bug',
            label = 'Bug'
        }
    },

    Objasnjenje = {
        ['bug'] = ' [This is bug]',
        ['pitanje'] = ' [This is question]',
        ['prijaviig'] = ' [This is player report]'
    }

}
