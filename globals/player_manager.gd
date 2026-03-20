extends Node

const PLAYER = preload("res://main_character/Player.tscn")

var player: Player = null
var player_spawned: bool = false

func _ready() -> void:
  add_player_instance()
  await get_tree().create_timer(1).timeout
  player_spawned = true


func add_player_instance() -> void:
  self.player = PLAYER.instantiate()
  add_child(self.player)

func set_as_parent(parent: Node) -> void:
  if self.player.get_parent():
    self.player.get_parent().remove_child(self.player)
  parent.add_child(self.player)

func unparent_player(parent: Node) -> void:
  parent.remove_child(self.player)
