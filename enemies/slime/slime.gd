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
  self.hit_boxes[CONTACT_HITBOX_NAME] = self.contact_hit_box
  self.hit_boxes[EXPLODE_ATTACK_HITBOX_NAME] = self.explode_attack_hit_box

  # Setup our hitboxes.
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

  self.derived_statistics.movement_speed.base_value = 70
  self.derived_statistics.movement_speed.compute_total()

  self.state_machine.initialize()
  super._ready()
