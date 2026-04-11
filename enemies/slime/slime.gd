class_name Slime extends Enemy

@onready var slime_state_machine: StateMachine = $SlimeStateMachine
@onready var slime_animator: SlimeAnimator = $SlimeAnimator

func _ready() -> void:
  self.state_machine = slime_state_machine
  self.state_machine.enemy = self
  self.animation_player = slime_animator.animator

  self.hurt_box = $HurtBox
  self.hit_box = $SlimeAnimator/HitBox

  self.hit_box.damage_ranges = [
    HitBox.DamageRange.make_without_skill(Damage.DamageType.BLUDGEONING, 40.0, 40.1),
    HitBox.DamageRange.make_without_skill(Damage.DamageType.ACID, 20.0, 20.1)
  ]
  self.hit_box.owning_entity = self

  self.derived_statistics.movement_speed.base_value = 70
  self.derived_statistics.movement_speed.compute_total()

  self.state_machine.initialize()
  super._ready()
