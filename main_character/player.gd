class_name Player extends Entity

@onready var player_animator: PlayerAnimator = $PlayerAnimator
@onready var animation_player: AnimationPlayer = player_animator.animator
@onready var weapon_renderer: WeaponRenderer = $WeaponRenderer
@onready var main_player_state_machine: MainPlayerStateMachine = $MainPlayerStateMachine

# Character customization options.
@export var level: int = 1
@export var character_class: CharacterClass = SlayerClass.new()
@export var inventory: Inventory = Inventory.new()

# Name, I guess.
@export var character_name: String = GeneratorUtil.generate_random_word(6)

var held_direction: Vector2 = Vector2.DOWN

var starting_xp_this_level: float = 0.0
var total_xp_to_next_level: float = RPGUtil.total_xp_for_next_level(1)

func _ready() -> void:
  self.main_player_state_machine.initialize()
  self.main_player_state_machine.change_state(PlayerIdleState.NAME)
  PlayerManager.player = self

  TestItemManager.initialize()

  self.inventory.updated.connect(self._apply_encumberance.unbind(1))
  self.derived_statistics.carrying_capacity.changed.connect(self._apply_encumberance)

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

func kill(_damage_event: Damage.DamageEvent) -> void:
  # Override this function, and do nothing!
  return

func _process(_delta: float) -> void:
  super._process(_delta)
  held_direction = Input.get_vector("left", "right", "up", "down")
  # Only update direction name if we are pressing something.
  if held_direction != Vector2.ZERO:
    # We only update facing if we are pressing something. This way, if we stop
    # pressing something the facing will still be up to date.
    self.facing = held_direction
    self.weapon_renderer.hit_box.knockback_direction = self.facing

  if Input.is_action_just_pressed("hotbar1"):
    AbilityManager.use_ability(self, AbilityRupture.NAME)
    return

  if Input.is_action_just_pressed("roll"):
    self.main_player_state_machine.change_state(PlayerRollState.NAME)
    self._test_buff_effect()
  elif Input.is_action_just_pressed("attack"):
    self.inventory.add_item(TestItemManager.get_item(), randi_range(1, 7))
    self.inventory.add_item(ItemApple.new())
    self.inventory.add_item(EquipmentBreastplate.new())
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
  m.base_value = 1200

  var b: BuffEffect = BuffEffect.new()

  b.duration = 10
  b.timer = b.duration
  b.is_decaying = true
  b.modifiers.modifiers.append(m)

  self.effect_manager.apply_effect(b)

func _apply_encumberance() -> void:
  var multiplier: int = int(self.inventory.total_weight / self.derived_statistics.carrying_capacity.total_value)
  var agility_penalty: int = (((multiplier + 7) ** 2 + (multiplier + 7)) / 2) - 21
  var dexterity_penalty: int = (((multiplier + 2) ** 2 + (multiplier + 2)) / 2) - 1
  # For each multiple we are over, we want to apply an increasing penalty
  # to both agility and dexterity. The agility penalty will be harsher than
  # the dexterity one.
  var m: Modifier = Modifier.new()
  m.source_name = "Over Encumbered"
  m.source_type = Modifier.ModifierSource.ENCUMBERANCE
  m.target_type = Modifier.ModifierTarget.ATTRIBUTE
  m.stat_name = Attributes.AGILITY
  m.modifier_type = Modifier.ModifierType.ADDITIVE
  m.sentiment = Modifier.ModifierSentiment.DEBUFF
  m.value = -1 * agility_penalty
  m.base_value = -1 * agility_penalty

  var m2: Modifier = Modifier.new()
  m2.source_name = "Over Encumbered"
  m2.source_type = Modifier.ModifierSource.ENCUMBERANCE
  m2.target_type = Modifier.ModifierTarget.ATTRIBUTE
  m2.stat_name = Attributes.DEXTERITY
  m2.modifier_type = Modifier.ModifierType.ADDITIVE
  m2.sentiment = Modifier.ModifierSentiment.DEBUFF
  m2.value = -1 * dexterity_penalty
  m2.base_value = -1 * dexterity_penalty

  # Remove modifiers then re-apply.
  self.modifier_manager.remove_modifier(m)
  self.modifier_manager.remove_modifier(m2)

  # Under our encumberance.
  if self.inventory.total_weight < self.derived_statistics.carrying_capacity.total_value:
    return

  self.modifier_manager.add_modifier(m)
  self.modifier_manager.add_modifier(m2)
