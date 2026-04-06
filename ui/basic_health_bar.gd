extends ProgressBar

@onready var label: Label = $HealthLabel

func _ready() -> void:
  if owner is not Entity:
    visible = false
    return

  owner.derived_statistics.max_health.changed.connect(_on_max_health_changed.bind())
  _on_max_health_changed()

  owner.current_health_changed.connect(_on_current_health_changed)
  _on_current_health_changed(owner.current_health)

func _on_current_health_changed(p_current_health: float) -> void:
  self.value = p_current_health
  self.label.text = "%d / %d" % [self.value, self.max_value]

func _on_max_health_changed() -> void:
  self.max_value = owner.derived_statistics.max_health.total_value
  self.label.text = "%d / %d" % [self.value, self.max_value]
