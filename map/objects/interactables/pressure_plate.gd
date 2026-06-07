class_name PressurePlate extends Area2D

signal state_changed(value: bool)

@onready var sprite: Sprite2D = $Sprite2D

@export var required_weight: float = 50.0

var current_weight: float = 0.0
var is_activated: bool = false

func _ready() -> void:
  self.body_entered.connect(self._on_body_entered)
  self.body_exited.connect(self._on_body_exited)

func _on_body_entered(b: Node2D) -> void:
  if b is not Entity:
    return

  self.current_weight += b.weight
  if self.is_activated or self.current_weight < self.required_weight:
    return

  self.is_activated = true
  self.sprite.region_rect.position.x = 384
  self.state_changed.emit(self.is_activated)
    

func _on_body_exited(b: Node2D) -> void:
  if b is not Entity:
    return

  self.current_weight -= b.weight
  if not self.is_activated or self.current_weight >= self.required_weight:
    return

  self.is_activated = false
  self.sprite.region_rect.position.x = 416
  self.state_changed.emit(self.is_activated)
  
  