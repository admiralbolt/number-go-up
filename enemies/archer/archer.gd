class_name Archer extends Enemy

const LOCK_ON_RANGE: float = 170.0

@onready var archer_state_machine: StateMachine = $ArcherStateMachine
@onready var archer_animator: ArcherAnimator = $ArcherAnimator

func _ready() -> void:
  self.state_machine = self.archer_state_machine
  self.state_machine.enemy = self
  self.animation_player = archer_animator.animator
  self.hurt_box = $HurtBox

  self.derived_statistics.movement_speed.base_value = 30
  self.derived_statistics.movement_speed.compute_total()

  self.state_machine.initialize()
  super._ready()
