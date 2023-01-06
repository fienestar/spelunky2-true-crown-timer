meta.name = 'True Crown Timer'
meta.version = '1.0'
meta.description = 'Set the warning seconds before teleporting(0 to disable)'
meta.author = 'fienestar'
meta.online_safe = true

local WARNING_SOUND = get_sound(VANILLA_SOUND.MENU_CHARSEL_SELECTION)
local need_warning = false

register_option_float('first', 'First warning', '', 5.0, 0.0, 21.0)
register_option_float('second', 'Second warnig', '', 2.5, 0.0, 21.0)
register_option_float('third', 'Third warning', '', 1.0, 0.0, 21.0)

-- I think math.floor is heavy operation(even if this is lua script) so I cache it on ON.LEVEL
local first = 0
local second = 0
local third = 0

set_callback(function()
    -- powerup_truecrown.timer is frame count
    -- interval = 22s = 1320 frames(always 60fps)
    first = 1320 - math.floor(options.first * 60)
    second = 1320 - math.floor(options.second * 60)
    third = 1320 - math.floor(options.third * 60)

    if first == 1320 then
        first = -1
    end
    if second == 1320 then
        second = -1
    end
    if third == 1320 then
        third = -1
    end
end, ON.LEVEL)

function check_need_warning()
    local powerups = get_entities_by_type(ENT_TYPE.ITEM_POWERUP_TRUECROWN)
    for _, powerup in ipairs(powerups) do
        local timer = get_entity(powerup).timer
        if timer == first or timer == second or timer == third then
            return true
        end
    end
    return false
end

set_callback(function ()
    need_warning = check_need_warning()
end, ON.FRAME)

set_callback(function()
    if state.pause == 0 and need_warning then
        WARNING_SOUND:play()
    end
end, ON.GUIFRAME)

set_callback(function ()
    need_warning = false
end, ON.SCREEN)
