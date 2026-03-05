class_name PlayerWalkState extends State

static var NAME = "walk"

var direction_name: String = "down"

func _init() -> void:
  self.state_name = NAME

func on_enter() -> void:
  direction_name = self.state_machine.player.direction_name
  self._stop_and_play()

func on_exit() -> void:
  self.state_machine.player.animation_player.stop()

func _stop_and_play() -> void:
  self.state_machine.player.animation_player.stop()
  self.state_machine.player.animation_player.play("PlayerAnimations/walk_%s" % direction_name)

func process(_delta: float) -> String:
  if self.state_machine.player.direction == Vector2.ZERO or self.state_machine.player.direction_name == direction_name:
    return State.NULL_STATE

  direction_name = self.state_machine.player.direction_name
  self._stop_and_play()

  return State.NULL_STATE