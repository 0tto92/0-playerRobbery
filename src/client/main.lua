local SHARED = require 'src.shared'

local ANIMATION_DICT = SHARED.handsUp.anim.dict
local ANIMATION_CLIP = SHARED.handsUp.anim.clip
local PLAYER_HANDS_UP = false

local IsEntityPlayingAnim = IsEntityPlayingAnim
local IsPedDeadOrDying = IsPedDeadOrDying
local IsPedArmed = IsPedArmed

---@param entity number
local function robPlayer(entity)
    if not lib.progressCircle({
        duration = SHARED.progressbar.duration,
        label = SHARED.progressbar.label,
        position = SHARED.progressbar.position,
        useWhileDead = false,
        allowRagdoll = false,
        allowSwimming = false,
        allowCuffed = false,
        allowFalling = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
            sprint = true
        },
        anim = {
            dict = SHARED.progressbar.anim.dict,
            clip = SHARED.progressbar.anim.clip
        }
    }) then
        return
    end

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

    if not IsEntityPlayingAnim(entity, ANIMATION_DICT, ANIMATION_CLIP, 3) then
        return false
    end

    if not IsPedArmed(cache.ped, 1 | 4) then
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

if SHARED.handsUp.enabled then
    RegisterCommand('player_robbery:handsup', function()
        if IsNuiFocused() then
            return
        end
    
        if IsPedDeadOrDying(cache.ped, true) then
            return
        end
    
        if not PLAYER_HANDS_UP then
            PLAYER_HANDS_UP = true
    
            lib.playAnim(cache.ped, ANIMATION_DICT, ANIMATION_CLIP, 1.5, 1.5, -1, 50, 0, false, false, false)
            return
        end
    
        PLAYER_HANDS_UP = false
        StopAnimTask(cache.ped, ANIMATION_DICT, ANIMATION_CLIP, 1.0)
    end, false)
    
    RegisterKeyMapping('player_robbery:handsup', SHARED.handsUp.keyMapping.label, 'keyboard', SHARED.handsUp.keyMapping.key)
end
