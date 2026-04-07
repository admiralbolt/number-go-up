extends ProgressBar

@onready var label: Label = $HealthLabel

var max_health: DerivedStatistic

func _ready() -> void:
  if owner is not Entity:
    visible = false
    return

  self.max_health = owner.derived_statistics.get(DerivedStatistics.MAX_HEALTH)

  self.max_health.changed.connect(_on_max_health_changed)
  _on_max_health_changed()

  owner.current_health_changed.connect(_on_current_health_changed)
  _on_current_health_changed(owner.current_health)

  if owner is Player:
    SaveManager.game_loaded.connect(_on_game_loaded)

func _on_game_loaded() -> void:
  self.max_health.changed.disconnect(_on_max_health_changed)
  self.max_health = PlayerManager.player.derived_statistics.get(DerivedStatistics.MAX_HEALTH)
  self.max_value = PlayerManager.player.derived_statistics.max_health.total_value
  self.max_health.changed.connect(_on_max_health_changed)

func _on_current_health_changed(p_current_health: float) -> void:
  self.value = p_current_health
  self.label.text = "%d / %d" % [self.value, self.max_value]

func _on_max_health_changed() -> void:
  self.max_value = self.max_health.total_value
  self.label.text = "%d / %d" % [self.value, self.max_value]