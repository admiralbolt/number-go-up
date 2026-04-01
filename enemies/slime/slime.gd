class_name Slime extends Enemy

@onready var slime_state_machine: StateMachine = $SlimeStateMachine
@onready var slime_animator: SlimeAnimator = $SlimeAnimator

func _ready() -> void:
  self.state_machine = slime_state_machine
  self.state_machine.enemy = self
  self.animation_player = slime_animator.animator

  self.hurt_box = $HurtBox
  self.hit_box = $SlimeAnimator/HitBox

  self.state_machine.initialize()
  super._ready()
