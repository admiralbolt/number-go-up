"""Where all items are stored!

Primarily just a map from item name => item instance.
"""
extends Node

const ITEM_PICKUP_SCENE: PackedScene = preload("res://core/items/ItemPickup.tscn")

static var ALL_ITEMS: Dictionary[String, Item] = {}

func _init() -> void:
  ALL_ITEMS[ItemApple.NAME] = ItemApple.new()

func make_item_pickup(item_name: String) -> ItemPickup:
  var item: Item = ALL_ITEMS.get(item_name)
  if item == null:
    return null
  
  var item_pickup: ItemPickup = ITEM_PICKUP_SCENE.instantiate()
  item_pickup.item = item
  return item_pickup




