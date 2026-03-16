@tool
extends CollisionShape2D

@export var save_data: CollisionWithTransform

func _ready() -> void:
  self.save_data = CollisionWithTransform.new()
  self.shape.changed.connect(self._on_shape_changed)
  self.process_mode = Node.PROCESS_MODE_ALWAYS


func _process(_delta: float) -> void:
  save_data.position = self.position
  save_data.rotation = self.rotation
  save_data.scale = self.scale
  save_data.collision_shape = self.shape

func _on_shape_changed() -> void:
  save_data.collision_shape = self.shape