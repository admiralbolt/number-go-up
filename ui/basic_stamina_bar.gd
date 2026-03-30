extends ProgressBar

@onready var label: Label = $Label

func _ready() -> void:
  if owner is not Entity:
    visible = false
    return

  owner.initialized.connect(_on_owner_initialized)

func _on_owner_initialized() -> void:
  self.owner.derived_statistics.max_stamina.changed.connect(self._on_max_stamina_changed.bind(self.owner.derived_statistics.max_stamina.total_value))
  _on_max_stamina_changed(self.owner.derived_statistics.max_stamina.total_value)

  self.owner.current_stamina_changed.connect(self._on_current_stamina_changed)
  _on_current_stamina_changed(owner.current_stamina)
  self.owner.initialized.disconnect(_on_owner_initialized)

func _on_current_stamina_changed(p_current_stamina: float) -> void:
  value = p_current_stamina
  label.text = "%d / %d" % [self.value, self.max_value]

func _on_max_stamina_changed(p_max_stamina: float) -> void:
  max_value = p_max_stamina
  label.text = "%d / %d" % [self.value, self.max_value]
