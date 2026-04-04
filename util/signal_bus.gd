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
signal skill_level_up(skill_name: String, new_level: int)

@warning_ignore_restore("unused_signal")
