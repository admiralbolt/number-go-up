extends ProgressBar

@onready var label: Label = $ManaLabel

var max_mana: DerivedStatistic

func _ready() -> void:
  if owner is not Entity:
    visible = false
    return

  self.max_mana = owner.derived_statistics.get(DerivedStatistics.MAX_MANA)

  self.max_mana.changed.connect(_on_max_mana_changed)
  _on_max_mana_changed()

  owner.current_mana_changed.connect(_on_current_mana_changed)
  _on_current_mana_changed(owner.current_mana)

  if owner is Player:
    SaveManager.game_loaded.connect(_on_game_loaded)

func _on_game_loaded() -> void:
  self.max_mana.changed.disconnect(_on_max_mana_changed)
  self.max_mana = PlayerManager.player.derived_statistics.get(DerivedStatistics.MAX_MANA)
  self.max_value = PlayerManager.player.derived_statistics.max_mana.total_value
  self.max_mana.changed.connect(_on_max_mana_changed)

func _on_current_mana_changed(p_current_mana: float) -> void:
  self.value = p_current_mana
  self.label.text = "%d / %d" % [self.value, self.max_value]

func _on_max_mana_changed() -> void:
  self.max_value = self.max_mana.total_value
  self.label.text = "%d / %d" % [self.value, self.max_value]