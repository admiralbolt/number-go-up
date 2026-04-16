extends Node

static var ABILITIES: Dictionary[String, Ability] = {
  AbilityBlast.NAME: AbilityBlast.new(),
  AbilityRupture.NAME: AbilityRupture.new()
}

func use_ability(owner: Entity, ability_name: String) -> void:
  if not ABILITIES.has(ability_name):
    return

  ABILITIES[ability_name].use(get_tree().current_scene, owner)

func _process(delta: float) -> void:
  for ability in ABILITIES.values():
    ability._process(delta)
 
