@tool
class_name ItemPickup extends CharacterBody2D

@export var item: Item: set = _set_item
@export var quantity: int = 1
@export var override_icon: SpriteSheetIcon = null

@onready var area: Area2D = $Area2D
@onready var item_sprite: Sprite2D = $ItemSprite
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer

func _ready() -> void:
  self._update_texture()
  if Engine.is_editor_hint():
    return

  area.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
  var collision_info: KinematicCollision2D = self.move_and_collide(self.velocity * delta)
  if collision_info:
    self.velocity = self.velocity.bounce(collision_info.get_normal())
  self.velocity -= self.velocity * delta * 4

func _update_texture() -> void:
  if self.item == null or self.item_sprite == null:
    return

  if self.override_icon != null:
    self.override_icon.render(self.item_sprite)
    return

  self.item.icon.render(self.item_sprite)

func _set_item(p_item: Item) -> void: 
  item = p_item
  self._update_texture()

func _on_body_entered(body: Node) -> void:
  if body is not Player:
    return

  if not self.item:
    return

  PlayerManager.player.inventory.add_item(self.item, self.quantity)
  area.body_entered.disconnect(self._on_body_entered)
  self.visible = false
  self.audio_player.play()
  await audio_player.finished
  self.queue_free()
