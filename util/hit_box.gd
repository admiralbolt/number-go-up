class_name HitBox extends Area2D

@onready var collision_shape: CollisionShape2D = $WeaponCollisionShape

var hit_log: HitLog

func _ready() -> void:
  area_entered.connect(_on_area_entered)

  set_collision_layer_value(1, false)
  set_collision_mask_value(1, false)

func _on_area_entered(area: Area2D) -> void:
  if area is not HurtBox:
    return

  var hurt_box_owner = area.owner
  if self.hit_log:
    if self.hit_log.has_hit(hurt_box_owner):
      return
    self.hit_log.log_hit(hurt_box_owner)

  area.receive_hit(self)

func enable() -> void:
  self.monitoring = true
  self.hit_log = HitLog.new()

func disable() -> void:
  self.monitoring = false

func reset() -> void:
  self.monitoring = false
  self.hit_log = null

func has_hit() -> bool:
  return self.hit_log and self.hit_log.hits.size() > 0