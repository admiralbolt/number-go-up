class_name State extends Node

@export var state_name: String = ""

var state_machine: StateMachine

func init() -> void:
  return

func on_enter() -> void:
  return

func on_exit() -> void:
  return

func can_enter() -> bool:
  return true

func can_exit() -> bool:
  return true

func process(_delta: float) -> State:
  return null

func physics(_delta: float) -> State:
  return null

