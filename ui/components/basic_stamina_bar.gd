extends ProgressBar

@onready var label: Label = $Label

var max_stamina: DerivedStatistic

func _ready() -> void:
  if owner is not Entity:
    visible = false
    return

  self.max_stamina = owner.derived_statistics.get(DerivedStatistics.MAX_STAMINA)

  self.max_stamina.changed.connect(_on_max_stamina_changed)
  _on_max_stamina_changed()

  self.owner.current_stamina_changed.connect(self._on_current_stamina_changed)
  _on_current_stamina_changed(owner.current_stamina)

  if owner is Player:
    SaveManager.game_loaded.connect(_on_game_loaded)

func _on_game_loaded() -> void:
  self.max_stamina.changed.disconnect(_on_max_stamina_changed)
  self.max_stamina = PlayerManager.player.derived_statistics.get(DerivedStatistics.MAX_STAMINA)
  self.max_value = PlayerManager.player.derived_statistics.max_stamina.total_value
  self.max_stamina.changed.connect(_on_max_stamina_changed)

func _on_current_stamina_changed(p_current_stamina: float) -> void:
  value = p_current_stamina
  label.text = "%d / %d" % [self.value, self.max_value]

func _on_max_stamina_changed() -> void:
  max_value = self.max_stamina.total_value
  label.text = "%d / %d" % [self.value, self.max_value]
