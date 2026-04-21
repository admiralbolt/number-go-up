class_name InventorySlot extends Resource

@export var item: Item
@export var quantity: int

func full_description() -> String: 
  var builder: Array[String] = []
  var color: Color = Item.RARITY_COLOR[self.item.rarity]
  builder.append("[color=#%s]%s[/color]" % [color.to_html(false), self.item.name])
  builder.append("---------------")
  if self.item.is_sellable:
    builder.append("Price: %.2f" % self.item.base_price)
  if self.item.is_stackable and self.quantity > 1:
    builder.append("Weight: %.2f (%.2f each)" % [self.item.weight * self.quantity, self.item.weight])
  else:
    builder.append("Weight: %.2f" % self.item.weight)

  builder.append("\n")
  builder.append(self.item.description)
  return "\n".join(builder)