class_name EnemyState extends State

var enemy: Enemy

func init(p_state_machine: StateMachine) -> void:
  if p_state_machine is not EnemyStateMachine:
    push_error("EnemyState must be used with an EnemyStateMachine.")
    return
  
  self.state_machine = p_state_machine
  self.enemy = p_state_machine.enemy