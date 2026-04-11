extends Node

@warning_ignore_start("unused_signal")

### Level Load Signals
signal level_load_started
signal level_loaded
signal tilemap_bounds_changed(bounds: Array[Vector2])

### Pause Menu Signals
signal pause_menu_opened
signal pause_menu_closed

### Level up!
signal player_level_up(new_level: int)
signal skill_level_up(skill_name: String, new_level: int)
signal skill_xp_gained(event: Skill.SkillXPEvent)

### Class Stuffs.
signal skill_node_rank_up(skill_node_name: String, new_rank: int)
signal skill_node_rank_down(skill_node_name: String, new_rank: int)

### Damage Signals, but better.
signal on_damage_pre_apply(event: Damage.DamageCalculationEvent)
signal on_player_damaged(event: Damage.FinalDamageEvent)
signal on_player_attack_landed(event: Damage.FinalDamageEvent)
signal on_player_killed_enemy(event: Damage.FinalDamageEvent)

@warning_ignore_restore("unused_signal")
