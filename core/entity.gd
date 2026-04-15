class_name Entity extends CharacterBody2D

const CONTACT_HITBOX_NAME: String = "CONTACT_HITBOX"

signal damaged(hit_box: HitBox)
signal died(hit_box: HitBox)

@export var entity_id: String 
@export var attributes: Attributes = Attributes.new()
@export var derived_statistics: DerivedStatistics = DerivedStatistics.new()
@export var skills: Skills = Skills.new()
@export var xp: float = 0.0

var modifier_manager: ModifierManager = ModifierManager.new()
var effect_manager: EffectManager = EffectManager.new()
var physics_manager: PhysicsManager = PhysicsManager.new(self)

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

func _exit_tree() -> void:
  EntityManager.remove_entity(self)

func kill() -> void:
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

func debug_print() -> void:
  self.attributes.debug_print()
  self.derived_statistics.debug_print()
  self.skills.debug_print()
