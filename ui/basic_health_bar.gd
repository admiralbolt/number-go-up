extends ProgressBar

func _ready() -> void:
  # Load character stats from our parent. Abort and hide if we can't.
  if not owner.get("stats"):
    visible = false
    return

  owner.stats.health_changed.connect(_on_health_changed)
  _on_health_changed(owner.stats.current_hp, owner.stats.total_max_health)


func _on_health_changed(p_health: float, p_max_health: float) -> void:
  print("updating progress bar with health: ", p_health, " and max health: ", p_max_health)
  max_value = p_max_health
  value = p_health