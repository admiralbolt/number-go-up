class_name CharacterStatsDisplay extends ContentPanel.ContentPanelChild

@onready var vbox: VBoxContainer = $VBoxContainer

var attributes: Attributes

func focus() -> void:
  return

func _ready() -> void:
  self.attributes = Attributes.new() if not PlayerManager.player else PlayerManager.player.player_attributes

  for attribute_name in Attributes.ALL_ATTRIBUTES:
    var attribute_display: AttributeDisplay = vbox.get_node("%sDisplay" % attribute_name.capitalize())
    if attribute_display == null:
      continue

    attribute_display.set_attribute(self.attributes.get(attribute_name))

  for child in vbox.get_children():
    if child is not AttributeDisplay:
      continue

    


  
