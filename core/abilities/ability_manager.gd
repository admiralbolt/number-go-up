extends Node

static var ABILITIES: Dictionary[String, Ability] = {
  AbilityBlast.NAME: AbilityBlast.new(),
  AbilityRupture.NAME: AbilityRupture.new()
}

func use_ability(activator: Entity, ability_name: String) -> void:
  if not ABILITIES.has(ability_name):
    return

  ABILITIES[ability_name].use(get_tree().current_scene, activator)

func _process(delta: float) -> void:
  for ability in ABILITIES.values():
    ability._process(delta)
 
