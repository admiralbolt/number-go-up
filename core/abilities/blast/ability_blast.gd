class_name AbilityBlast extends Ability

const NAME: String = "Blast"
const SCENE: PackedScene = preload("res://core/abilities/blast/AbilityBlastScene.tscn")

func _init() -> void:
  self.ability_name = NAME
  self.description = "Bllaaaaast."
  self.cooldown = 2.0
  self.mana_cost = 65.0
  self.stamina_cost = 4.0

  self.max_cooldown = self.cooldown

func use(current_scene: Node) -> bool:
  if not super.use(current_scene):
    return false

  var blast_scene = SCENE.instantiate() as AbilityBlastScene
  current_scene.add_child(blast_scene)
  blast_scene.initialize(PlayerManager.player.global_position)
  blast_scene.play()
  return true
