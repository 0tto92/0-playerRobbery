local SHARED = require 'src.shared'
local PLAYER_HANDS_UP = false

local ANIMATION_DICT = SHARED.animation.dict
local ANIMATION_NAME = SHARED.animation.name

---@param entity number
local function robPlayer(entity)
    local playerId = NetworkGetPlayerIndexFromPed(entity)
    local serverId = GetPlayerServerId(playerId)

    return exports.ox_inventory:openInventory(
        'player',
        serverId
    )
end

---@param entity number
---@return boolean
local function canRobPlayer(entity)
    if IsPedDeadOrDying(entity, true) then
        return false
    end

    if not IsEntityPlayingAnim(entity, ANIMATION_DICT, ANIMATION_NAME, 3) then
        return false
    end

    if not IsPedArmed(playerPed, 1 | 4) then
        return false
    end

    return not cache.vehicle
end

exports.ox_target:addGlobalPlayer({
    name = 'robPlayer',
    icon = SHARED.target.icon,
    label = SHARED.target.label,
    distance = SHARED.target.distance,
    onSelect = function(data)
        return robPlayer(data.entity)
    end,
    canInteract = function(entity, _, _, _, _)
        return canRobPlayer(entity)
    end
})

if SHARED.animation.enabled then
    RegisterCommand('player_robbery:handsup', function()
        if IsNuiFocused() then
            return
        end
    
        if IsPedDeadOrDying(cache.ped, true) then
            return
        end
    
        if not PLAYER_HANDS_UP then
            PLAYER_HANDS_UP = true
    
            lib.playAnim(cache.ped, ANIMATION_DICT, ANIMATION_NAME, 1.5, 1.5, -1, 50, 0, false, false, false)
            return
        end
    
        PLAYER_HANDS_UP = false
        StopAnimTask(cache.ped, ANIMATION_DICT, ANIMATION_NAME, 1.0)
    end, false)
    
    RegisterKeyMapping('player_robbery:handsup', SHARED.animation.keyMapping.label, 'keyboard', SHARED.animation.keyMapping.key)
end
