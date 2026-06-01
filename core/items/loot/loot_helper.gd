extends Node

static var COIN_TABLE_L0: LootTable

func _ready() -> void:
  ### Coin Tables! ###
  COIN_TABLE_L0 = LootTable.new(2, [
    LootEntry.new(Item.NULL, 600, -1, 1, 1),
    LootEntry.new(ItemCoin.NAME, 100, 1, 1, 3)
  ])
