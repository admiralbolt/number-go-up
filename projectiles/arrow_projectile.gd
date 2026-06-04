class_name ArrowProjectile extends CharacterBody2D

@onready var hit_box: HitBox = $HitBox
@onready var hurt_box: HurtBox = $HurtBox

var owning_entity: Entity

func _ready() -> void:
  self.hit_box.on_hit.connect(queue_free)
  self.hurt_box.on_hit.connect(queue_free.unbind(1))

func initialize(p_owner: Entity, p_direction: Vector2, p_velocity: float) -> void:
  self.owning_entity = p_owner
  self.velocity = p_direction * p_velocity
  self.position = p_owner.global_position + p_owner.facing * 5
  self.rotation = p_direction.angle()

  self.hit_box.owning_entity = p_owner
  self.hit_box.knockback_direction = p_owner.facing
  self.hit_box.knockback = 140
  self.hit_box.knockback_type = HitBox.KnockbackType.FIXED
  self.hit_box.damage_ranges = [
    HitBox.DamageRange.make_without_skill(Damage.DamageType.PIERCING, 40.0, 50.0),
  ]

func _physics_process(delta: float) -> void:
  var collision: KinematicCollision2D = self.move_and_collide(self.velocity * delta)
  
  if collision != null:
    # If we get here and we haven't queue freed yet, that means there is a
    # chance we are colliding with something that should take damage.
    # We need to apply damage in those cases before queue_free().
    if collision.get_collider() is Entity or collision.get_collider() is InteractableObject:
      self.hit_box.hit_hurt_box(collision.get_collider().hurt_box)
    queue_free()
