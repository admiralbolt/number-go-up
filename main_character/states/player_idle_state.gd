class_name PlayerIdleState extends PlayerState

static var NAME = "idle"

var direction_name: String = "down"

func _init() -> void:
  self.state_name = NAME

func on_enter() -> void:
  direction_name = self.player.direction_name
  self.player.animation_player.play("PlayerAnimations/idle_%s" % direction_name)

func on_exit() -> void:
  self.player.animation_player.stop()

func process(_delta: float) -> String:
  self.player.velocity = Vector2.ZERO

  return State.NULL_STATE