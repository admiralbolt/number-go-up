class_name Orc extends Enemy

const STALK_RANGE: float = 140.0
const STALK_TARGET_DISTANCE: float = 50.0

const CHASE_RANGE: float = 140.0
const ATTACK_RANGE: float = 25.0
const SLASH_HIT_BOX: String = "SLASH_ATTACK_HITBOX"

@onready var slash_hit_box: HitBox = $OrcAnimator/SlashHitBox

func _ready() -> void:
  self.state_machine = $OrcStateMachine
  self.hurt_box = $HurtBox
  self.animation_player = $OrcAnimator/AnimationPlayer
  self.sprite = $OrcAnimator/Sprite2D

  self._setup_hitboxes()
  self._setup_stats()
  self._setup_loot()
  
  super._ready()

func _setup_hitboxes() -> void:
  self.hit_boxes[SLASH_HIT_BOX] = self.slash_hit_box

  self.slash_hit_box.damage_ranges = [
    HitBox.DamageRange.make_without_skill(Damage.DamageType.SLASHING, 20, 30),
  ]
  self.slash_hit_box.owning_entity = self
  self.slash_hit_box.knockback = 75
  self.slash_hit_box.enable(false)

  var effect: BleedEffect = BleedEffect.new()
  effect.damage_per_second = 2.0
  effect.duration = 10.0
  effect.timer = effect.duration
  effect.owner_entity_id = self.entity_id
  effect.owner = self
  self.slash_hit_box.effects.append(effect)
  self.slash_hit_box.disable()

func _setup_stats() -> void:
  self.xp = 400

  self.attributes.strength.value = 40
  self.attributes.constitution.value = 40
  self.attributes.dexterity.value = 30
  self.attributes.agility.value = 30
  self.attributes.spirit.value = 10
  self.attributes.wisdom.value = 10
  self.attributes.intelligence.value = 10
  self.attributes.charisma.value = 10
  self.attributes.luck.value = 10

  self.derived_statistics.max_health.base_value = 295
  self.derived_statistics.health_regen.base_value = 3
  self.derived_statistics.movement_speed.base_value = 110

func _setup_loot() -> void:
  self.loot_tables.append(LootTable.new(3, [
    LootEntry.new(Item.NULL, 1000, -1, 1, 1),
    LootEntry.new(ItemApple.NAME, 80, 1, 1, 1),
  ]))
  self.loot_tables.append(LootHelper.COIN_TABLE_L0)
