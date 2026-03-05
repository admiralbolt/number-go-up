class_name Player extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_state_machine: PlayerStateMachine = $PlayerStateMachine

var direction: Vector2 = Vector2.ZERO
var direction_name: String = "down"

var speed: float = 100.0

func _ready() -> void:
  player_state_machine.initialize2(self)
  player_state_machine.change_state(PlayerWalkState.NAME)

func _process(_delta: float) -> void:
  direction = Input.get_vector("left", "right", "up", "down")
  direction_name = Directions.get_direction_name(direction)

  if Input.is_key_pressed(Key.KEY_SPACE):
    player_state_machine.change_state(PlayerRollState.NAME)
  elif Input.is_key_pressed(Key.KEY_J):
    player_state_machine.change_state(PlayerAttackState.NAME)

func _physics_process(_delta: float) -> void:
  velocity = direction * speed
  if player_state_machine.current_state is PlayerAttackState:
    velocity *= 0.4
  elif player_state_machine.current_state is PlayerRollState:
    # We also want to ignore any direction instructions right now. So, we will
    # override the velocity to be in the direction of the roll.
    velocity = player_state_machine.current_state.roll_direction * speed
  move_and_slide()
