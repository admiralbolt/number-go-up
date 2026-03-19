class_name Slime extends Enemy

@onready var slime_state_machine: StateMachine = $SlimeStateMachine
@onready var slime_animator: SlimeAnimator = $SlimeAnimator

func _init() -> void:
  print("SLIME INIT")
  super._init()

func _ready() -> void:
  self.state_machine = slime_state_machine
  self.state_machine.enemy = self
  self.animation_player = slime_animator.animator

  self.state_machine.initialize()

  print("derived")
  print("-------")
  print(self.derived_statistics)


