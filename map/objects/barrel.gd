class_name Barrel extends InteractableObject

func _ready() -> void:
  self.hurt_box = $HurtBox
  self.sprite = $Sprite2D
  self.is_pushable = true
  self.weight = 150.0

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