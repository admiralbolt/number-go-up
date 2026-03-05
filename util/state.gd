class_name State extends Node

static var NULL_STATE: String = "this_should_never_be_a_real_state_name"

@export var state_name: String = ""

var state_machine: StateMachine

func init() -> void:
  return

func on_enter() -> void:
  return

func on_exit() -> void:
  return

func can_enter(prev_state: State) -> bool:
  return true

func can_exit(next_state: State) -> bool:
  return true

func process(_delta: float) -> String:
  return NULL_STATE

func physics_process(_delta: float) -> String:
  return NULL_STATE

