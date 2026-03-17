class_name PlayerRollState extends PlayerState

static var NAME = "roll"

var roll_direction: Vector2
var roll_timer: float

func _init() -> void:
  self.state_name = NAME

func can_exit(next_state: State) -> bool:
  if roll_timer <= 0:
    return true

  return roll_timer <= (PlayerAnimator.ANIMATION_DURATION["roll"] * 0.4) and next_state.state_name in [PlayerAttackState.NAME]

func on_enter() -> void:
  self.roll_timer = PlayerAnimator.ANIMATION_DURATION["roll"]
  # Lock the direction for the duration of the roll.
  self.roll_direction = self.player.facing
  self.player.animation_player.play("PlayerAnimations/roll_%s" % self.player.direction_name)

func on_exit() -> void:
  self.player.animation_player.stop()


func process(delta: float) -> String:
  self.roll_timer -= delta
  if self.roll_timer > 0:
    return State.NULL_STATE

  # If the player is still holding a direction, transition to walk, otherwise
  # we want to go to idle.
  if self.player.held_direction != Vector2.ZERO:
    return PlayerWalkState.NAME

  return PlayerIdleState.NAME
