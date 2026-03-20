class_name Slime extends Enemy

@onready var slime_state_machine: StateMachine = $SlimeStateMachine
@onready var slime_animator: SlimeAnimator = $SlimeAnimator

@export var slime_attributes: Attributes = Attributes.new()
@export var slime_derived_statistics: DerivedStatistics = DerivedStatistics.new()
@export var slime_skills: Skills = Skills.new()

func _ready() -> void:
  self.state_machine = slime_state_machine
  self.state_machine.enemy = self
  self.animation_player = slime_animator.animator

  self.state_machine.initialize()
  await get_tree().create_timer(1).timeout

  super.initialize(slime_attributes, slime_derived_statistics, slime_skills)
