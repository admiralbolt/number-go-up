class_name Slime extends Enemy

@onready var slime_state_machine: StateMachine = $SlimeStateMachine
@onready var slime_animator: SlimeAnimator = $SlimeAnimator

func _ready() -> void:
  self.state_machine = slime_state_machine
  self.state_machine.enemy = self
  self.animation_player = slime_animator.animator

  var modifiers = Modifiers.new()
  self.stats.recompute_total_values(modifiers)
  self.stats.current_hp = self.stats.total_max_health

  self.state_machine.initialize()


