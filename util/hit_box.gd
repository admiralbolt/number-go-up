"""A HIT BOX FOR AN ATTACK!

For Players:
  HitBox: Should have Collision Monitoring 2 set (and nothing else).
  HurtBox: Should have Collision Layer 9 set (and nothing else).

For Enemies:
  HitBox: Should have Collision Monitoring 9 set (and nothing else).
  HurtBox: Should have Collision Layer 2 set (and nothing else).
"""

class_name HitBox extends Area2D

var collision_shape: CollisionShape2D
var hit_log: HitLog

func _ready() -> void:
  # The collision shape should always be a child of the hit box.
  for child in get_children():
    if child is CollisionShape2D:
      self.collision_shape = child
      break

  if self.collision_shape == null:
    push_error("HitBox: %s does not have a CollisionShape2D child." % self.name)
  
  area_entered.connect(_on_area_entered)

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