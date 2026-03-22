class_name PlayerSpawned extends Node2D

func _ready() -> void:
  visible = false
  if PlayerManager.is_player_spawning:
    PlayerManager.player.global_position = self.global_position
    PlayerManager.is_player_spawning = false

  queue_free()
  
