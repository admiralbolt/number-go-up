class_name AttributeDisplay extends Control

var attribute: Attribute

@onready var attribute_name_label: Label = $AttributeName
@onready var attribute_value_label: Label = $AttributeValue

@export var display_as_int: bool = false


func _ready() -> void:
  if self.attribute == null:
    self.set_attribute(Attribute.make("Stat", 33))
  
func set_attribute(p_attribute: Attribute) -> void:
  self.attribute = p_attribute
  self.attribute.changed.connect(self.update)
  self.attribute_name_label.text = attribute.name.capitalize()
  self.update()

func update() -> void:
  attribute_value_label.text = str(snapped(attribute.total_value, 0.01)) if not self.display_as_int else str(int(attribute.total_value))

 
