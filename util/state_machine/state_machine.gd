class_name StateMachine extends Node

var states: Array[State]
var state_map: Dictionary[String, State] = {}
var current_state: State
var prev_state: State

var debug: bool = false

func _ready() -> void:
  process_mode = Node.PROCESS_MODE_DISABLED

func initialize() -> void:
  states = []
  for child in get_children():
    if child is State:
      states.append(child)
      state_map[child.state_name] = child

  for state in states:
    state.init(self)

  if states.size() > 0:
    current_state = states[0]
    current_state.on_enter()
    process_mode = Node.PROCESS_MODE_INHERIT


func change_state(new_state_name: String) -> void:
  var new_state: State = self.state_map.get(new_state_name)
  if new_state == null:
    return
  
  if (new_state == current_state and not new_state.self_loop) or not current_state.can_exit(new_state) or not new_state.can_enter(current_state):
    return

  if debug:
    print("Changing from state: ", current_state.state_name, " to state: ", new_state_name)

  current_state.on_exit()
  new_state.on_enter()
  prev_state = current_state
  current_state = new_state

func _process(delta: float) -> void:
  if current_state == null:
    return

  self.change_state(current_state.process(delta))

func _physics_process(delta: float) -> void:
  if current_state == null:
    return

  self.change_state(current_state.physics_process(delta))