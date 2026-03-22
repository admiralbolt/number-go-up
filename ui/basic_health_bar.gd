extends ProgressBar

@onready var label: Label = $HealthLabel

func _ready() -> void:
  if owner is not Entity:
    visible = false
    return

  owner.initialized.connect(_on_owner_initialized)

func _on_owner_initialized() -> void:
  owner.derived_statistics.max_health.value_changed.connect(_on_max_health_changed)
  _on_max_health_changed(owner.derived_statistics.max_health.total_value)

  owner.current_health_changed.connect(_on_current_health_changed)
  _on_current_health_changed(owner.current_health)

func _on_current_health_changed(p_current_health: float) -> void:
  value = p_current_health
  label.text = "%d / %d" % [self.value, self.max_value]

func _on_max_health_changed(p_max_health: float) -> void:
  max_value = p_max_health
  label.text = "%d / %d" % [self.value, self.max_value]
