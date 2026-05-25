class_name LootHelper

static var BASIC_COIN_TABLE: LootTable = LootTable.new(3, [
  LootEntry.new(Item.NULL, 0, 1_000, -0.5),
  LootEntry.new(ItemApple.NAME, 1, 30, 0.5),
])