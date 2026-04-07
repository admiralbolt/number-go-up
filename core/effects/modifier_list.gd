class_name ModifierList extends Resource

@export var modifiers: Array[Modifier] = []

func get_index(p_modifier: Modifier) -> int:
  for i in range(modifiers.size()):
    if modifiers[i].eq(p_modifier):
      return i

  return -1

func _to_string() -> String:
  var modifier_strings: Array[String] = []
  for modifier in modifiers:
    modifier_strings.append(modifier._to_string())

  return "ModifierList(%s)" % ", ".join(modifier_strings)