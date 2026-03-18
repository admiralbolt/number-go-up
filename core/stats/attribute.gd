class_name Attribute extends Resource

@export var name: String = ""
@export var value: float = 10.0: set = _set_value
var total_value: float = value
var entity: Entity

func _set_value(p_value: float) -> void:
  if p_value == self.value:
    return

  value = p_value
  self.compute_total()

func compute_total() -> void:
  if self.entity == null:
    self.total_value = self.value
    return

  var new_total: float = self.entity.modifier_manager.compute_total(self.name, self.value)
  if new_total == self.total_value:
    return

  self.total_value = new_total
  self.emit_changed()

func _to_string() -> String:
  return "%s: %.2f (Base: %.2f)" % [name, total_value, value]

static func make(p_name: String, p_value: float) -> Attribute:
  var attr = Attribute.new()
  attr.name = p_name
  attr.value = p_value
  return attr