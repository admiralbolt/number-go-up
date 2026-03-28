class_name Player extends Entity

@onready var player_animator: PlayerAnimator = $PlayerAnimator
@onready var animation_player: AnimationPlayer = player_animator.animator
@onready var weapon_renderer: WeaponRenderer = $WeaponRenderer
@onready var main_player_state_machine: MainPlayerStateMachine = $MainPlayerStateMachine

@export var player_attributes: Attributes = Attributes.new()
@export var player_derived_statistics: DerivedStatistics = DerivedStatistics.new()
@export var player_skills: Skills = Skills.new()

var held_direction: Vector2 = Vector2.DOWN
var facing: Vector2 = Vector2.DOWN
var direction_name: String = "down"

var speed: float = 100.0

func _ready() -> void:
  self.main_player_state_machine.initialize()
  self.main_player_state_machine.change_state(PlayerIdleState.NAME)
  PlayerManager.player = self

  super.initialize(player_attributes, player_derived_statistics, player_skills)

  self.player_attributes.agility.value = 20
  super._ready()

  # self._test_buff_effect()

func _process(_delta: float) -> void:
  super._process(_delta)
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

func _physics_process(delta: float) -> void:
  velocity = held_direction * self.derived_statistics.movement_speed.total_value
  if self.main_player_state_machine.current_state is PlayerAttackState:
    velocity *= 0.5
  elif self.main_player_state_machine.current_state is PlayerRollState:
    # We also want to ignore any direction instructions right now. So, we will
    # override the velocity to be in the direction of the roll.
    velocity = self.main_player_state_machine.current_state.roll_direction * self.derived_statistics.movement_speed.total_value * PlayerRollState.ROLL_SPEED_BOOST
  self.move_and_collide(velocity * delta)


func _test_buff_effect() -> void:
  var m: Modifier = Modifier.new()
  m.source_name = "FIRE MANG"
  m.source_type = Modifier.ModifierSource.SPELL
  m.target_type = Modifier.ModifierTarget.ATTRIBUTE
  m.stat_name = Attributes.AGILITY
  m.value = 1200
  m.duration = 10
  m.is_timed = true
  m.is_decaying = true

  var b: BuffEffect = BuffEffect.new()
  b.modifier = m

  self.effect_manager.apply_effect(b)