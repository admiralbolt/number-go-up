@tool
extends Node2D

@onready var sprite_and_shape: Node2D = $SpriteAndShape
@onready var sprite: Sprite2D = $SpriteAndShape/Sprite2D
@onready var collision_shape: CollisionShape2D = $SpriteAndShape/CollisionShape2D

@export var save_data: SwordShape

@export_tool_button("Save Settings", "Callable") var save_action = save_settings

func _ready() -> void:
  self.save_data = SwordShape.new()
  self.process_mode = Node.PROCESS_MODE_ALWAYS

func save_settings() -> void:
  save_data.parent_scale = self.sprite_and_shape.scale
  save_data.sprite_position = self.sprite.position
  save_data.collision_shape = self.collision_shape.shape
  save_data.shape_position = self.collision_shape.position
  save_data.shape_rotation = self.collision_shape.rotation
  save_data.shape_scale = self.collision_shape.scale