class_name DerivedStatistic extends Resource

@export var base_value: float = 0.0: set = _set_base_value

var name: String = ""
var pretty_name: String = ""
var weights: Dictionary[String, float] = {}
var attr_references: Dictionary[String, Attribute] = {}
var entity: Entity
var total_value: float = base_value

func _set_base_value(p_base_value: float) -> void:
  if p_base_value == base_value:
    return
  
  base_value = p_base_value
  # We only want to trigger a recompute if the statistic has been initialized
  # with an entity.
  if entity != null:
    compute_total()

func initialize(p_entity: Entity) -> void:
  # This is being done separate from the constructor because the attribute
  # reference may not be valid at the time of construction.
  self.entity = p_entity
  for attr_name in self.weights.keys():
    var attribute: Attribute = p_entity.attributes.get(attr_name)
    self.attr_references[attr_name] = attribute
    # When any of the attributes that affect this statistic change, we need to
    # recompute the total value.
    attribute.changed.connect(self.compute_total)
  self.compute_total()

func compute_total() -> void:
  var val = self.base_value
  for attr_name in self.weights.keys():
    var attribute = self.attr_references[attr_name]
    var weight = self.weights[attr_name]
    val += attribute.total_value * weight

  var new_total: float = self.entity.modifier_manager.compute_total(self.name, val)
  if new_total == self.total_value:
    return

  self.total_value = new_total
  self.changed.emit()

func compute_total_description() -> Array[String]:
  var builder: Array[String] = []
  var val = self.base_value
  for attr_name in self.weights.keys():
    var attribute: Attribute = self.attr_references[attr_name]
    var weight: float = self.weights[attr_name]
    var new_val: float = val + attribute.total_value * weight

    builder.append("%s (%s%%):\n\t%.2f -> %.2f" % [attr_name.capitalize(), weight * 100, val, new_val])

    val = new_val

  for line in self.entity.modifier_manager.compute_total_description(self.name, val):
    builder.append(line)

  return builder

func _to_string() -> String:
  return "%s: %.2f (base: %.2f)" % [self.name, self.total_value, self.base_value]

static func make(p_name: String, p_pretty_name: String, p_base_value: float, p_weights: Dictionary[String, float], p_entity: Entity) -> DerivedStatistic:
  var ds = DerivedStatistic.new()
  ds.name = p_name
  ds.pretty_name = p_pretty_name
  ds.base_value = p_base_value
  ds.weights = p_weights
  ds.initialize(p_entity)
  return ds
