class_name Slime extends Enemy

func _ready() -> void:
  state_machine = $EnemyStateMachine
  animation_player = $AnimationPlayer

  var modifiers = Modifiers.new()
  stats.recompute_total_values(modifiers)
  stats.current_hp = stats.total_max_health

