class_name Slime extends Enemy

const EXPLODE_ATTACK_HITBOX_NAME: String = "EXPLODE_ATTACK_HITBOX"

@onready var slime_state_machine: StateMachine = $SlimeStateMachine
@onready var slime_animator: SlimeAnimator = $SlimeAnimator
@onready var contact_hit_box: HitBox = $SlimeAnimator/ContactHitBox
@onready var explode_attack_hit_box: HitBox = $SlimeAnimator/ExplodeAttackHitBox

func _ready() -> void:
  self.state_machine = slime_state_machine
  self.state_machine.enemy = self
  self.animation_player = slime_animator.animator
  self.hurt_box = $HurtBox

  self._setup_hitboxes()
  self._setup_stats()
  self._setup_loot()
  
  self.state_machine.initialize()
  super._ready()

func _setup_hitboxes() -> void:
  self.hit_boxes[CONTACT_HITBOX_NAME] = self.contact_hit_box
  self.hit_boxes[EXPLODE_ATTACK_HITBOX_NAME] = self.explode_attack_hit_box

  self.contact_hit_box.damage_ranges = [
    HitBox.DamageRange.make_without_skill(Damage.DamageType.BLUDGEONING, 5, 10),
    HitBox.DamageRange.make_without_skill(Damage.DamageType.ACID, 5, 15)
  ]
  self.contact_hit_box.owning_entity = self
  self.contact_hit_box.knockback = 155
  self.contact_hit_box.enable(false)

  # By default the explode attack hit box should not be active.
  self.explode_attack_hit_box.disable()
  self.explode_attack_hit_box.damage_ranges = [
    HitBox.DamageRange.make_without_skill(Damage.DamageType.BLUDGEONING, 20, 40),
    HitBox.DamageRange.make_without_skill(Damage.DamageType.ACID, 15.0, 30)
  ]
  self.explode_attack_hit_box.owning_entity = self
  self.explode_attack_hit_box.knockback = 310

func _setup_stats() -> void:
  self.xp = 100

  self.attributes.strength.value = 20
  self.attributes.constitution.value = 40
  self.attributes.dexterity.value = 10
  self.attributes.agility.value = 30
  self.attributes.spirit.value = 10
  self.attributes.wisdom.value = 10
  self.attributes.intelligence.value = 10
  self.attributes.charisma.value = 10
  self.attributes.luck.value = 10

  self.derived_statistics.max_health.base_value = 146
  self.derived_statistics.movement_speed.base_value = 104

func _setup_loot() -> void:
  var loot_entries: Array[LootEntry] = []
  loot_entries.append(LootEntry.new(Item.NULL, 1000, -1, 1, 1))
  loot_entries.append(LootEntry.new(ItemApple.NAME, 100, 1, 1, 1))

  var table: LootTable = LootTable.new(3, loot_entries)

  var loot_entries2: Array[LootEntry] = []
  loot_entries2.append(LootEntry.new(Item.NULL, 600, -1, 1, 1))
  loot_entries2.append(LootEntry.new(ItemCoin.NAME, 100, 1, 1, 3))

  var table2: LootTable = LootTable.new(2, loot_entries2)

  self.loot_tables.append(table)
  self.loot_tables.append(table2)
