Config = {
    reportcommand = 'sendreport',

    AllowedGroups = {
        ['admin'] = true,
    },

    Webhook = '',

    replist = 'replist',

    Icons = {
        ['bug'] = 'bug',
        ['pitanje'] = 'question',
        ['prijaviig'] = 'bullhorn'
    },

    IconsColor = {
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

    Options = {
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
