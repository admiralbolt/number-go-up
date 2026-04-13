class_name Attribute extends Resource

@export var name: String = ""
@export var value: float = 10.0: set = _set_value
var total_value: float = value
var entity: Entity

func _init() -> void:
  SignalBus.modifier_changed.connect(self._on_modifier_changed)

func _set_value(p_value: float) -> void:
  if p_value == value:
    return

  value = p_value
  self.compute_total()

func _on_modifier_changed(modifier_name: String) -> void:
  if modifier_name == self.name:
    self.compute_total()

func compute_total() -> void:
  if self.entity == null:
    return

  var new_total: float = self.entity.modifier_manager.compute_total(self.name, self.value)
  if new_total == self.total_value:
    return

  self.total_value = new_total
  self.changed.emit()

func compute_total_description() -> Array[String]:
  if self.entity == null:
    return []

  return self.entity.modifier_manager.compute_total_description(self.name, self.value)

func _to_string() -> String:
  return "%s: %.2f (Base: %.2f)" % [name, total_value, value]

static func make(p_name: String, p_value: float) -> Attribute:
  var attr = Attribute.new()
  attr.name = p_name
  attr.value = p_value
  return attr