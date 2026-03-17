class_name State extends Node

static var NULL_STATE: String = "this_should_never_be_a_real_state_name"

@export var state_name: String = ""
# If self_loop is true, the state machine will allow transitions from this
# state to itself.
@export var self_loop: bool = false

var state_machine: StateMachine

func init(p_state_machine: StateMachine) -> void:
  self.state_machine = p_state_machine

func on_enter() -> void:
  return

func on_exit() -> void:
  return

func can_enter(_prev_state: State) -> bool:
  return true

func can_exit(_next_state: State) -> bool:
  return true

func process(_delta: float) -> String:
  return NULL_STATE

func physics_process(_delta: float) -> String:
  return NULL_STATE

