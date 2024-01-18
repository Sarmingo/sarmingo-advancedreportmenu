Config = {
    reportcommand = 'sendreport',

    AllowedGroups = {
        ['admin'] = true,
    },

    Webhook = 'https://discord.com/api/webhooks/1138152491138170903/017z47vRl-qHwX_bX0rZ8OJe_0yO7PuNOS098P83VbHld6CcgY-8BvvjpwrLA32lCLZh',

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
