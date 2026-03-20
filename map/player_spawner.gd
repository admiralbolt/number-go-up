class_name PlayerSpawned extends Node2D

func _ready() -> void:
  visible = false
  if not PlayerManager.player_spawned:
    PlayerManager.player.global_position = self.global_position

  queue_free()