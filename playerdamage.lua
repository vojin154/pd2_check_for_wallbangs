--This is for the local player

local old_func = PlayerDamage.damage_bullet
function PlayerDamage:damage_bullet(attack_data)
    local attacker_unit = attack_data.attacker_unit --Get the cop, that's shooting
    local player_unit = self._unit or managers.player:local_player() --Get the player

    --Check if both are valid
    if (not alive(player_unit)) or (not alive(attacker_unit)) then
        return old_func(self, attack_data) --Stop the function and let the original run
    end

    local player_pos = player_unit:movement():m_head_pos() --Cops shoot the players head
    local attacker_unit_pos = attacker_unit:movement():m_head_pos() --Cops shoot FROM their head

    --Since drawing the ray from the cop to the player doesn't register the wall and counts as a hit
    --While drawing a ray from the player registers the wall and can't shoot through it
    --Simply draw a ray from the player to the cop to check if there actually IS a wall
    --With the slot mask of world geometry to hit ONLY world stuff, such as walls
    --The "report" arg, just tells the ray to just return a boolean instead of info, as we don't need anything other than true or false
    local ray = player_unit:raycast("ray", player_pos, attacker_unit_pos, "slot_mask", managers.slot:get_mask("world_geometry"), "report")
    if ray then --If wall was hit, then stop the function and don't let the original run to cancel the damage
        return
    end

    return old_func(self, attack_data) --Run the original
end