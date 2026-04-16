class_name AbilityRupture extends Ability

const NAME: String = "Rupture"
const SCENE: PackedScene = preload("res://core/abilities/rupture/AbilityRuptureScene.tscn")

func _init() -> void:
  self.ability_name = NAME
  self.description = "A short-range piercing attack, inflicting damage based on your equipped weapon and bleed."
  self.cooldown = 0.5
  self.governing_skill_name = SkillSwords.NAME

  self.mana_cost = 5.0
  self.stamina_cost = 5.0

  self.max_cooldown = self.cooldown

func use(current_scene: Node, owner: Entity) -> bool:
  if not super.use(current_scene, owner):
    return false

  var rupture_scene = SCENE.instantiate() as AbilityRuptureScene
  current_scene.add_child(rupture_scene)
  rupture_scene.initialize(owner)
  rupture_scene.play()
  return true