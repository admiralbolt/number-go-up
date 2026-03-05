class_name PlayerAttackState extends State

static var NAME = "attack"

var direction_name: String = "down"
var attack_timer: float

func _init() -> void:
  self.state_name = NAME

func can_exit() -> bool:
  return attack_timer <= 0.3

func on_enter() -> void:
  self.attack_timer = 0.6
  direction_name = self.state_machine.player.direction_name
  self.state_machine.player.animation_player.play("PlayerAnimations/attack_%s" % direction_name)

func on_exit() -> void:
  self.state_machine.player.animation_player.stop()

func process(delta: float) -> String:
  self.attack_timer -= delta
  return State.NULL_STATE if self.attack_timer > 0 else PlayerWalkState.NAME