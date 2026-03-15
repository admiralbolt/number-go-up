class_name HitBox extends Area2D

var hit_log: HitLog

func _ready() -> void:
  area_entered.connect(_on_area_entered)

  set_collision_layer_value(1, false)
  set_collision_mask_value(1, false)

func _on_area_entered(area: Area2D) -> void:
  if area is not HurtBox:
    return

  var hurt_box_owner = area.owner
  if hit_log:
    if hit_log.has_hit(hurt_box_owner):
      return
    hit_log.log_hit(hurt_box_owner)

  area.receive_hit(owner.stats.base_strength * 2.5)


func enable() -> void:
  monitoring = true
  hit_log = HitLog.new()

func disable() -> void:
  monitoring = false
  hit_log = null