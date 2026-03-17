class_name Player extends CharacterBody2D

@onready var player_animator: PlayerAnimator = $PlayerAnimator
@onready var animation_player: AnimationPlayer = player_animator.animator
@onready var weapon_renderer: WeaponRenderer = $WeaponRenderer
@onready var main_player_state_machine: MainPlayerStateMachine = $MainPlayerStateMachine

@export_category("Player Stats")
@export var stats: CharacterStatistics = CharacterStatistics.new()

var held_direction: Vector2 = Vector2.DOWN
var facing: Vector2 = Vector2.DOWN
var direction_name: String = "down"

var speed: float = 100.0

func _ready() -> void:
  self.main_player_state_machine.initialize()
  self.main_player_state_machine.change_state(PlayerIdleState.NAME)
  PlayerManager.player = self

func _process(_delta: float) -> void:
  held_direction = Input.get_vector("left", "right", "up", "down")
  # Only update direction name if we are pressing something.
  if held_direction != Vector2.ZERO:
    # We only update facing if we are pressing something. This way, if we stop
    # pressing something the facing will still be up to date.
    facing = held_direction
    direction_name = Directions.get_direction_name(facing)

  if Input.is_action_just_pressed("roll"):
    self.main_player_state_machine.change_state(PlayerRollState.NAME)
  elif Input.is_action_just_pressed("attack"):
    self.main_player_state_machine.change_state(PlayerAttackState.NAME)
  elif held_direction != Vector2.ZERO:
    self.main_player_state_machine.change_state(PlayerWalkState.NAME)

func _physics_process(_delta: float) -> void:
  velocity = held_direction * speed
  if self.main_player_state_machine.current_state is PlayerAttackState:
    velocity *= 0.5
  elif self.main_player_state_machine.current_state is PlayerRollState:
    # We also want to ignore any direction instructions right now. So, we will
    # override the velocity to be in the direction of the roll.
    velocity = self.main_player_state_machine.current_state.roll_direction * speed * 1.2
  move_and_slide()
