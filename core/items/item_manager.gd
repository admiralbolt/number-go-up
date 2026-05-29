"""Where all items are stored!

Primarily just a map from item name => item instance.
"""
extends Node

const ITEM_PICKUP_SCENE: PackedScene = preload("res://core/items/ItemPickup.tscn")

const ITEM_BASE_PATH: String = "res://core/items"

const ITEM_FOLDERS: Array[String] = [
  "consumables",
  "currency"
]

static var ALL_ITEMS: Dictionary[String, Item] = {}

static func load_item(path: String) -> Item:
  var script: Resource = load(path)
  return script.new()

func _init() -> void:
  for folder in ITEM_FOLDERS:
    for f in DirAccess.get_files_at("%s/%s/" % [ITEM_BASE_PATH, folder]):
      if f.ends_with("uid"):
        continue

      var item: Item = load_item("%s/%s/%s" % [ITEM_BASE_PATH, folder, f])
      ALL_ITEMS[item.name] = item

func get_n_items(item_name: String, amount: int) -> Array[Item]:
  var item: Item = ALL_ITEMS.get(item_name)
  if item == null:
    return []

  var items: Array[Item]
  for _i in range(amount):
    items.append(item.duplicate(true))

  return items

func make_item_pickup(item: Item) -> ItemPickup:
  var item_pickup: ItemPickup = ITEM_PICKUP_SCENE.instantiate()
  item_pickup.item = item
  return item_pickup

func make_item_pickup_from_name(item_name: String) -> ItemPickup:
  var item: Item = ALL_ITEMS.get(item_name)
  if item == null:
    return null
  
  var item_pickup: ItemPickup = ITEM_PICKUP_SCENE.instantiate()
  item_pickup.item = item
  return item_pickup
