class_name ModifierList extends Resource

@export var modifiers: Array[Modifier] = []

func get_index(p_modifier: Modifier) -> int:
  for i in range(modifiers.size()):
    if modifiers[i].eq(p_modifier):
      return i

  return -1