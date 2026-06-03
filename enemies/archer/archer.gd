class_name Archer extends Enemy

const LOCK_ON_RANGE: float = 170.0

func _ready() -> void:
  self.state_machine = $ArcherStateMachine
  self.hurt_box = $HurtBox
  self.animation_player = $ArcherAnimator/AnimationPlayer
  self.sprite = $ArcherAnimator/Sprite2D

  self._setup_stats()
  self._setup_loot()

  super._ready()

func _setup_stats() -> void:
  self.xp = 180

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
