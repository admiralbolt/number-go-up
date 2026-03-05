class_name PlayerIdleState extends State

static var NAME = "idle"

var direction_name: String = "down"

func _init() -> void:
  self.state_name = NAME

func on_enter() -> void:
  direction_name = self.state_machine.player.direction_name
  self.state_machine.player.animation_player.play("PlayerAnimations/idle_%s" % direction_name)

func on_exit() -> void:
  self.state_machine.player.animation_player.stop()

func process(_delta: float) -> String:
  return State.NULL_STATE