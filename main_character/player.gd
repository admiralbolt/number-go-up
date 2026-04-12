class_name Player extends Entity

@onready var player_animator: PlayerAnimator = $PlayerAnimator
@onready var animation_player: AnimationPlayer = player_animator.animator
@onready var weapon_renderer: WeaponRenderer = $WeaponRenderer
@onready var main_player_state_machine: MainPlayerStateMachine = $MainPlayerStateMachine

# Character customization options.
@export var level: int = 1
@export var character_class: CharacterClass = SlayerClass.new()

var held_direction: Vector2 = Vector2.DOWN
var facing: Vector2 = Vector2.DOWN
var direction_name: String = "down"

var starting_xp_this_level: float = 0.0
var total_xp_to_next_level: float = RPGUtil.total_xp_for_next_level(1)

func _ready() -> void:
  self.main_player_state_machine.initialize()
  self.main_player_state_machine.change_state(PlayerIdleState.NAME)
  PlayerManager.player = self

  self.hurt_box = $PlayerHurtBox
  super._ready()

func level_up() -> void:
  self.character_class.level_up()
  self.level += 1

  self.starting_xp_this_level = self.total_xp_to_next_level
  self.total_xp_to_next_level = RPGUtil.total_xp_for_next_skill_level(self.level)
  SignalBus.player_level_up.emit(self.level)

func add_xp(amount: float) -> void:
  self.xp += amount
  if self.xp >= self.total_xp_to_next_level:
    self.level_up()

func _process(_delta: float) -> void:
  super._process(_delta)
  held_direction = Input.get_vector("left", "right", "up", "down")
  # Only update direction name if we are pressing something.
  if held_direction != Vector2.ZERO:
    # We only update facing if we are pressing something. This way, if we stop
    # pressing something the facing will still be up to date.
    facing = held_direction
    direction_name = Directions.get_direction_name(facing)

  if Input.is_action_just_pressed("hotbar1"):
    AbilityManager.use_ability(AbilityBlast.NAME)
    return

  if Input.is_action_just_pressed("roll"):
    self.main_player_state_machine.change_state(PlayerRollState.NAME)
    # self._test_buff_effect()
  elif Input.is_action_just_pressed("attack"):
    self.main_player_state_machine.change_state(PlayerAttackState.NAME)
  elif held_direction != Vector2.ZERO:
    self.main_player_state_machine.change_state(PlayerWalkState.NAME)

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
