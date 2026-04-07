class_name DerivedStatisticDisplay extends Control

var derived_statistic: DerivedStatistic

@onready var derived_statistic_name_label: Label = $DerivedStatisticName
@onready var derived_statistic_value_label: Label = $DerivedStatisticValue

@export var display_as_int: bool = false

func _ready() -> void:
  if self.derived_statistic == null:
    # Make a fake slime :p
    var slime: Slime = Slime.new()
    self.set_derived_statistic(DerivedStatistic.make("Max Health", 100.0, {
      "constitution": 0.1,
      "strength": 0.03,
    }, slime))

  self.focus_entered.connect(self._on_focus_entered)
  self.focus_exited.connect(self._on_focus_exited)
  
func set_derived_statistic(p_derived_statistic: DerivedStatistic) -> void:
  self.derived_statistic = p_derived_statistic
  self.derived_statistic.changed.connect(self.update)
  self.derived_statistic_name_label.text = self.derived_statistic.name.capitalize()
  self.update()

func update() -> void:
  self.derived_statistic_value_label.text = str(snapped(self.derived_statistic.total_value, 0.01)) if not self.display_as_int else str(int(self.derived_statistic.total_value))

func _on_focus_entered() -> void:
  self.derived_statistic_name_label.add_theme_color_override("font_color", Color8(255, 255, 0))

func _on_focus_exited() -> void:
  self.derived_statistic_name_label.remove_theme_color_override("font_color")
