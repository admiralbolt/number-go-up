class_name Enemy extends Entity

var state_machine: StateMachine
var animation_player: AnimationPlayer

var facing: Vector2 = Vector2.DOWN: set = _set_facing
var facing_name: String = "down"

func _set_facing(value: Vector2) -> void:
  facing = value
  facing_name = Directions.get_primary_direction_name(facing)

func _physics_process(_delta: float) -> void:
  self.move_and_slide()