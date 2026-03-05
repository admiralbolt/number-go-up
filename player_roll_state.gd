class_name PlayerRollState extends State

static var NAME = "roll"

var roll_direction: Vector2
var roll_timer: float

func _init() -> void:
  self.state_name = NAME

func can_exit() -> bool:
  return roll_timer <= 0.3

func on_enter() -> void:
  self.roll_timer = 0.6
  # Lock the direction for the duration of the roll.
  self.roll_direction = self.state_machine.player.direction
  self.state_machine.player.animation_player.play("PlayerAnimations/roll_%s" % self.state_machine.player.direction_name)

func on_exit() -> void:
  self.state_machine.player.animation_player.stop()

func process(delta: float) -> String:
  self.roll_timer -= delta
  return State.NULL_STATE if self.roll_timer > 0 else PlayerWalkState.NAME