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

### Class Stuffs.
signal skill_node_rank_up(skill_node_name: String, new_rank: int)
signal skill_node_rank_down(skill_node_name: String, new_rank: int)

### Damage Signals
signal on_player_damaged(target: Entity, hit_box: HitBox, total_damage: float)
signal on_player_attack_landed(target: Entity, hit_box: HitBox, total_damage: float)
signal on_player_killed_enemy(target: Entity, hit_box: HitBox, total_damage: float)

@warning_ignore_restore("unused_signal")
