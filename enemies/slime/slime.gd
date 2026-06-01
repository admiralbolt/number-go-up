class_name Slime extends Enemy

const CHASE_RANGE: float = 140.0
const ATTACK_RANGE: float = 25.0
const EXPLODE_ATTACK_HITBOX_NAME: String = "EXPLODE_ATTACK_HITBOX"

@onready var contact_hit_box: HitBox = $SlimeAnimator/ContactHitBox
@onready var explode_attack_hit_box: HitBox = $SlimeAnimator/ExplodeAttackHitBox

func _ready() -> void:
  self.state_machine = $SlimeStateMachine
  self.hurt_box = $HurtBox
  self.animation_player = $SlimeAnimator/AnimationPlayer
  self.sprite = $SlimeAnimator/Sprite2D

  self._setup_hitboxes()
  self._setup_stats()
  self._setup_loot()
  
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
  self.xp = 10000

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
  self.derived_statistics.health_regen.base_value = 4
  self.derived_statistics.movement_speed.base_value = 104

func _setup_loot() -> void:
  self.loot_tables.append(LootTable.new(3, [
    LootEntry.new(Item.NULL, 1000, -1, 1, 1),
    LootEntry.new(ItemApple.NAME, 80, 1, 1, 1),
  ]))
  self.loot_tables.append(LootHelper.COIN_TABLE_L0)
