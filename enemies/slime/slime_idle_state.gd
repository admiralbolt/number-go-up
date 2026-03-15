class_name SlimeIdleState extends State

static var NAME = "idle"

var direction_name: String = "down"

func _init() -> void:
  self.state_name = NAME

func on_enter() -> void:
  self.state_machine.enemy.animation_player.play("idle_%s" % direction_name)

func on_exit() -> void:
  self.state_machine.enemy.animation_player.stop()

func process(_delta: float) -> String:
  return State.NULL_STATE