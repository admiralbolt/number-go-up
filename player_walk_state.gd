class_name PlayerWalkState extends State

var direction_name: String = "down"

func _init() -> void:
  self.state_name = "walk"

func on_enter() -> void:
  direction_name = self.state_machine.player.direction_name
  self._stop_and_play()

func _stop_and_play() -> void:
  print("Calling stop and play for direction: %s" % direction_name)
  self.state_machine.player.animation_player.stop()
  self.state_machine.player.animation_player.play("PlayerAnimations/walk_%s" % direction_name)

func process(_delta: float) -> State:
  if self.state_machine.player.direction == Vector2.ZERO or self.state_machine.player.direction_name == direction_name:
    return null

  direction_name = self.state_machine.player.direction_name
  self._stop_and_play()

  return null