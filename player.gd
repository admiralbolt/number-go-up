class_name Player extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_state_machine: PlayerStateMachine = $PlayerStateMachine

var direction: Vector2 = Vector2.ZERO
var direction_name: String = "down"

var speed: float = 100.0

func _ready() -> void:
  player_state_machine.initialize2(self)
  player_state_machine.change_state("player_walk")

func _process(_delta: float) -> void:
  direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
  direction_name = Directions.get_direction_name(direction)

func _physics_process(_delta: float) -> void:
  velocity = direction * speed
  move_and_slide()
