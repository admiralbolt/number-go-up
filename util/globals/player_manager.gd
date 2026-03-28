extends Node

const PLAYER = preload("res://main_character/Player.tscn")

var player: Player = null
var is_player_spawning: bool = false

func _ready() -> void:
  # Don't inject the player if we aren't in a level.
  if get_tree().current_scene is not Level:
    return

  self.is_player_spawning = true
  self.add_player_instance()

func add_player_instance() -> void:
  self.player = PLAYER.instantiate()
  add_child(self.player)

func set_as_parent(parent: Node) -> void:
  if self.player.get_parent():
    self.player.get_parent().remove_child(self.player)
  parent.add_child(self.player)

func unparent_player(parent: Node) -> void:
  parent.remove_child(self.player)
