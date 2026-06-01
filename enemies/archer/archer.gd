class_name Archer extends Enemy

const LOCK_ON_RANGE: float = 170.0

@onready var archer_state_machine: StateMachine = $ArcherStateMachine
@onready var archer_animator: ArcherAnimator = $ArcherAnimator

func _ready() -> void:
  self.state_machine = self.archer_state_machine
  self.state_machine.enemy = self
  self.animation_player = archer_animator.animator
  self.hurt_box = $HurtBox

  self._setup_stats()
  self._setup_loot()

  self.state_machine.initialize()
  super._ready()

func _setup_stats() -> void:
  self.xp = 150

  self.attributes.strength.value = 20
  self.attributes.constitution.value = 20
  self.attributes.dexterity.value = 40
  self.attributes.agility.value = 40
  self.attributes.spirit.value = 20
  self.attributes.wisdom.value = 20
  self.attributes.intelligence.value = 30
  self.attributes.charisma.value = 10
  self.attributes.luck.value = 10

  self.derived_statistics.max_health.base_value = 98
  self.derived_statistics.health_regen.base_value = 1
  self.derived_statistics.movement_speed.base_value = 30

func _setup_loot() -> void:
  self.loot_tables.append(LootTable.new(3, [
    LootEntry.new(Item.NULL, 1000, -1, 1, 1),
    LootEntry.new(ItemApple.NAME, 80, 1, 1, 1),
  ]))
  self.loot_tables.append(LootHelper.COIN_TABLE_L0)
