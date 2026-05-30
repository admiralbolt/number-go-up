class_name PlayerIdleState extends PlayerState

static var NAME = "idle"

func _init() -> void:
  self.state_name = NAME

func on_enter() -> void:
  self.player.animation_player.play("PlayerAnimations/idle_%s" % self.player.facing_name)

func on_exit() -> void:
  self.player.animation_player.stop()

func process(_delta: float) -> String:
  self.player.velocity = Vector2.ZERO

  return State.NULL_STATE
