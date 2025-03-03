return {
    target = {
        icon = 'fa-solid fa-gun',
        label = 'Rob player',
        distance = 1.5
    },

    progressbar = {
        duration = 4000,
        label = 'Searching pockets',
        position = 'middle',
        anim = {
            dict = 'anim@gangops@facility@servers@bodysearch@',
            clip = 'player_search'
        }
    },

    handsUp = {
        enabled = true,
        anim = {
            dict = 'missminuteman_1ig_2',
            clip = 'handsup_base',
        },
        keyMapping = {
            label = 'Hands up',
            key = 'z'
        }
    }
}