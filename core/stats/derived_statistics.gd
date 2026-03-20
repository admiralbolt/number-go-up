class_name DerivedStatistics extends Resource

const FORTITUDE_SAVE: String = "fortitude_save"
const MOVEMENT_SPEED: String = "movement_speed"
const MAX_HEALTH: String = "max_health"
const MAX_MANA: String = "max_mana"
const MAX_STAMINA: String = "max_stamina"

@export var base_fortitude_save: float = 0.0
@export var base_movement_speed: float = 95.0
@export var base_max_health: float = 200.0
@export var base_max_mana: float = 100.0
@export var base_max_stamina: float = 100.0

var fortitude_save: DerivedStatistic
var movement_speed: DerivedStatistic
var max_health: DerivedStatistic
var max_mana: DerivedStatistic
var max_stamina: DerivedStatistic


func initialize(p_entity: Entity) -> void:
  self.fortitude_save = DerivedStatistic.make("Fortitude Save", base_fortitude_save, {
    "strength": 0.02,
    "constitution": 0.08,
  }, p_entity)

  self.movement_speed = DerivedStatistic.make("Movement Speed", base_movement_speed, {
    "agility": 0.1,
    "dexterity": 0.02
  }, p_entity)

  self.max_health = DerivedStatistic.make("Max Health", base_max_health, {
    "constitution": 0.1,
    "strength": 0.03,
  }, p_entity)

  self.max_mana = DerivedStatistic.make("Max Mana", base_max_mana, {
    "intelligence": 0.1,
    "spirit": 0.04,
    "wisdom": 0.02,
    "charisma": 0.01
  }, p_entity)

  self.max_stamina = DerivedStatistic.make("Max Stamina", base_max_stamina, {
    "constitution": 0.05,
    "strength": 0.04,
    "agility": 0.03,
    "spirit": 0.02,
  }, p_entity)

  
func debug_print() -> void:
  print("Derived Statistics:")
  print(self.max_health)


