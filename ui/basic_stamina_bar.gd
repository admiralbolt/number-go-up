extends ProgressBar

@onready var label: Label = $Label

func _ready() -> void:
  if owner is not Entity:
    visible = false
    return

  self.owner.derived_statistics.max_stamina.changed.connect(self._on_max_stamina_changed)
  _on_max_stamina_changed()

  self.owner.current_stamina_changed.connect(self._on_current_stamina_changed)
  _on_current_stamina_changed(owner.current_stamina)

func _on_current_stamina_changed(p_current_stamina: float) -> void:
  value = p_current_stamina
  label.text = "%d / %d" % [self.value, self.max_value]

func _on_max_stamina_changed() -> void:
  max_value = self.owner.derived_statistics.max_stamina.total_value
  label.text = "%d / %d" % [self.value, self.max_value]
