class_name StateMachine extends Node

var states: Array[State]
var current_state: State
var prev_state: State

func _ready() -> void:
  process_mode = Node.PROCESS_MODE_DISABLED

func initialize() -> void:
  states = []
  for child in get_children():
    if child is State:
      states.append(child)

  for state in states:
    state.state_machine = self
    state.init()

  if states.size() > 0:
    current_state = states[0]
    current_state.on_enter()
    process_mode = Node.PROCESS_MODE_INHERIT


func change_state(new_state: State) -> void:
  if new_state == null or new_state == current_state or not current_state.can_exit() or not new_state.can_enter():
    return

  current_state.on_exit()
  new_state.on_enter()
  prev_state = current_state
  current_state = new_state