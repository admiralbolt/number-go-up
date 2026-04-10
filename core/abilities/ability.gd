class_name Ability extends Resource

enum AbilityType {
  ACTIVE,
  TOGGLED,
  CHANNELED
}

# The name of the ability.
@export var ability_name: String
# A description of the ability.
@export var description: String
# The path to the icon for this ability.
@export var icon_path: String
# The type of ability.
@export var ability_type: AbilityType = AbilityType.ACTIVE
# The base cooldown of the ability in seconds.
@export var cooldown: float = 0.25
# The base costs of the ability.
@export var health_cost: float = 0.0
@export var mana_cost: float = 0.0
@export var stamina_cost: float = 0.0

var max_cooldown: float = cooldown
var timer = 0

func _process(delta: float) -> void:
  if timer <= 0:
    return

  timer -= delta

func can_use() -> bool:
  if timer > 0:
    return false

  return (
    PlayerManager.player.current_health > health_cost and 
    PlayerManager.player.current_mana > mana_cost and 
    PlayerManager.player.current_stamina > stamina_cost
  )

func use(_current_scene: Node) -> bool:
  """This method should be overriden in children to actually do stuff.

  Always call super.use() in the child first.
  """
  if not self.can_use():
    return false

  # Pay costs.
  PlayerManager.player.current_health -= health_cost
  PlayerManager.player.current_mana -= mana_cost
  PlayerManager.player.current_stamina -= stamina_cost

  # Set cooldown.
  self.timer = self.max_cooldown
  return true
