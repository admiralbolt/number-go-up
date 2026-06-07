class_name Crate extends EntityObject

func _ready() -> void:
  self.hurt_box = $HurtBox
  self.sprite = $Sprite2D
  self.is_pushable = true
  self.weight = 350.0

  super._ready()

  self.died.connect(self.queue_free.unbind(1))

  self.loot_tables.append(LootTable.new(3, [
    LootEntry.new(Item.NULL, 3000, -1, 1, 1),
    LootEntry.new(ItemApple.NAME, 80, 1, 1, 1),
  ]))
  self.loot_tables.append(LootHelper.COIN_TABLE_L0)

func _process(delta: float) -> void:
  self.velocity = Vector2.ZERO
  super._process(delta)

func _setup_stats() -> void:
  super._setup_stats()
  self.derived_statistics.max_health.base_value = 200
  self.derived_statistics.armor.base_value = 20
  self.derived_statistics.piercing_reduction.base_value = 20
  self.derived_statistics.slashing_reduction.base_value = 15
  self.derived_statistics.bludgeoning_reduction.base_value = 5