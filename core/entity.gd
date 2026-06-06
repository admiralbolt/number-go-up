class_name Entity extends CharacterBody2D

const CONTACT_HITBOX_NAME: String = "CONTACT_HITBOX"

signal damaged(hit_box: HitBox)
signal died(hit_box: HitBox)

@export var entity_id: String 
@export var attributes: Attributes = Attributes.new()
@export var derived_statistics: DerivedStatistics = DerivedStatistics.new()
@export var skills: Skills = Skills.new()
@export var xp: float = 0.0
@export var gives_skill_xp: bool = true
@export var is_pushable: bool = false
@export var weight: float = 0.0

var loot_tables: Array[LootTable] = []

var modifier_manager: ModifierManager = ModifierManager.new()
var effect_manager: EffectManager = EffectManager.new()
var physics_manager: PhysicsManager = PhysicsManager.new(self)
var equipment_manager: EquipmentManager = EquipmentManager.new(self)
# The value doesn't actually matter, using this as set effectively.
var effect_immunities: Dictionary[String, bool] = {}

# Which way we looking. Should always be normalized.
var facing: Vector2 = Vector2.DOWN: set = _set_facing
var facing_name: String = "down"
var facing_primary_direction: String = "down"

var sprite: Sprite2D
var flash_tween: Tween
var dying: bool = false

# All entities should have a hurt box.
var hurt_box: HurtBox

# Used for storing references to hit boxes the entity has.
var hit_boxes: Dictionary[String, HitBox] = {}

# Current values for bar resources + signals for them.
signal current_health_changed(new_current_health: float)
signal current_mana_changed(new_mana: float)
signal current_stamina_changed(new_stamina: float)

var current_health: float = 100.0: set = _set_current_health
var current_mana: float = 100.0: set = _set_current_mana
var current_stamina: float = 100.0: set = _set_current_stamina

func _set_facing(value: Vector2) -> void:
  facing = value
  facing_name = Directions.get_direction_name(facing)
  facing_primary_direction = Directions.get_primary_direction_name(facing)

func _init() -> void:
  self.initialize_stats()

  # Finally set the values based on the maxes.
  self.current_health = self.derived_statistics.max_health.total_value
  self.current_mana = self.derived_statistics.max_mana.total_value
  self.current_stamina = self.derived_statistics.max_stamina.total_value

func initialize_stats() -> void:
  self.attributes.initialize(self)
  self.derived_statistics.initialize(self)
  self.skills.initialize(self)
  self.effect_manager.initialize(self)

func _ready() -> void:
  # We need to hook into changes to the max hp/mp/sp.
  self.derived_statistics.max_health.changed.connect(self._on_max_health_changed.bind(self.derived_statistics.max_health.total_value))
  self.derived_statistics.max_mana.changed.connect(self._on_max_mana_changed.bind(self.derived_statistics.max_mana.total_value))
  self.derived_statistics.max_stamina.changed.connect(self._on_max_stamina_changed.bind(self.derived_statistics.max_stamina.total_value))

  # Don't set the ID until it gets added to the scene.
  self.entity_id = "%s_%d" % [self.name, randi_range(100_000, 999_999)]
  EntityManager.add_entity(self)

  # Recompute all derived statistics. Many base values get set in the enemy
  # initializers. Just make sure the correct totals have been calculated.
  for stat_name in self.derived_statistics.ALL_DERIVED_STATISTICS:
    var stat: DerivedStatistic = self.derived_statistics.get(stat_name)
    stat.compute_total()

  self.hurt_box.on_hit.connect(self._flash_on_hit.unbind(1))

func _exit_tree() -> void:
  EntityManager.remove_entity(self)

func spawn_loot(damage_event: Damage.DamageEvent) -> void:
  if self.loot_tables.size() == 0:
    return

  for table in self.loot_tables:
    for item in table.roll_loot(damage_event):
      var item_pickup: ItemPickup = ItemManager.make_item_pickup(item)
      if item_pickup == null:
        continue

      item_pickup.global_position = self.global_position + Vector2(randf_range(-1, 1), randf_range(-1, 1))
      item_pickup.velocity = self.velocity.rotated(randf_range(-PI / 4, PI / 4) * randf_range(2.7, 4.3))
      self.get_parent().call_deferred("add_child", item_pickup)

func kill(damage_event: Damage.DamageEvent) -> void:
  self.spawn_loot(damage_event)
  self.dying = true
  self.effect_manager.process_effects = false
  self.died.emit(null)

func disable_all_hit_boxes() -> void:
  for hit_box in self.hit_boxes.values():
    hit_box.disable()

func _set_current_health(p_health: float) -> void:
  if p_health == current_health:
    return

  current_health = clamp(p_health, 0, self.derived_statistics.max_health.total_value)
  current_health_changed.emit(p_health)

func _set_current_mana(p_mana: float) -> void:
  if p_mana == current_mana:
    return

  current_mana = clamp(p_mana, 0, self.derived_statistics.max_mana.total_value)
  current_mana_changed.emit(p_mana)

func _set_current_stamina(p_stamina: float) -> void:
  if p_stamina == current_stamina:
    return

  current_stamina = clamp(p_stamina, 0, self.derived_statistics.max_stamina.total_value)
  current_stamina_changed.emit(p_stamina)

# The logic for these three functions is the same.
func _on_max_health_changed(_p_max_health: float) -> void:
  if self.current_health >= self.derived_statistics.max_health.total_value:
    self.current_health = self.derived_statistics.max_health.total_value
    return

func _on_max_mana_changed(_p_max_mana: float) -> void:
  if self.current_mana >= self.derived_statistics.max_mana.total_value:
    self.current_mana = self.derived_statistics.max_mana.total_value
    return

func _on_max_stamina_changed(_p_max_stamina: float) -> void:
  if self.current_stamina >= self.derived_statistics.max_stamina.total_value:
    self.current_stamina = self.derived_statistics.max_stamina.total_value
    return

func _process(delta: float) -> void:
  self.effect_manager.process(delta)

  if not self.dying:
    # Update regeneration of health, mana, and stamina.
    self.current_health += self.derived_statistics.health_regen.total_value * delta
    self.current_mana += self.derived_statistics.mana_regen.total_value * delta
    self.current_stamina += self.derived_statistics.stamina_regen.total_value * delta

func _physics_process(delta: float) -> void:
  # Velocity and such should be set by _process(). Applying stuff from our
  # physics manager here should happen *LAST*.
  self.physics_manager.process_effects(delta)
  self.move_and_slide()

func _flash_on_hit() -> void:
  if self.flash_tween and self.flash_tween.is_valid():
    self.flash_tween.kill()

  self.sprite.modulate = Color.from_rgba8(255, 100, 100)
  self.flash_tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
  self.flash_tween.tween_property(self.sprite, "modulate", Color.from_rgba8(255, 255, 255), 0.6)

func debug_print() -> void:
  self.attributes.debug_print()
  self.derived_statistics.debug_print()
  self.skills.debug_print()
