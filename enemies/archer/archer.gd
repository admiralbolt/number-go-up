class_name Archer extends Enemy

@onready var archer_state_machine: StateMachine = $ArcherStateMachine
@onready var archer_animator: ArcherAnimator = $ArcherAnimator

func _ready() -> void:
  self.state_machine = self.archer_state_machine
  self.state_machine.enemy = self
  self.animation_player = archer_animator.animator
  self.hurt_box = $HurtBox

  self.state_machine.initialize()
  super._ready()
