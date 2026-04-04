class_name Slime extends Enemy

@onready var slime_state_machine: StateMachine = $SlimeStateMachine
@onready var slime_animator: SlimeAnimator = $SlimeAnimator

func _ready() -> void:
  self.state_machine = slime_state_machine
  self.state_machine.enemy = self
  self.animation_player = slime_animator.animator

  self.hurt_box = $HurtBox
  self.hit_box = $SlimeAnimator/HitBox

  self.hit_box.min_damage = 30.0
  self.hit_box.max_damage = 50.0
  self.hit_box.governing_skill = Skills.UNARMED

  self.state_machine.initialize()
  super._ready()
