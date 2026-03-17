class_name PlayerState extends State

var player: Player

func init(p_state_machine: StateMachine) -> void:
  if p_state_machine is not PlayerStateMachine:
    push_error("PlayerState must be used with a PlayerStateMachine.")
    return
  
  self.state_machine = p_state_machine
  self.player = p_state_machine.player