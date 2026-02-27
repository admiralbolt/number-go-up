extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  var attributes = Attributes.new(10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0)
  var derived_values = DerivedValues.new()
  var skills = Skills.new()
  var modifier_manager = Modifiers.new()
  
  attributes.debug_print(modifier_manager)
  derived_values.debug_print(attributes, modifier_manager)
  skills.debug_print(attributes, modifier_manager)


  # Now lets add some modifiers.
  modifier_manager.add_modifier(Modifiers.Modifier.new("Flame Blade", "Spell", 30.0, [
    Modifiers.SubModifier.new("attribute", "strength", 5.0),
    Modifiers.SubModifier.new("attribute", "agility", 10.3),
    Modifiers.SubModifier.new("derived", "health", -15.2),
    Modifiers.SubModifier.new("skill", "swords", 7.3),
  ]))

  modifier_manager.add_modifier(Modifiers.Modifier.new("Bull Strength", "Potion", 60.0, [
    Modifiers.SubModifier.new("attribute", "strength", 1.2, Modifiers.SubModifier.ModifierType.Multiplicative),
  ]))

  attributes.debug_print(modifier_manager)
  derived_values.debug_print(attributes, modifier_manager)
  skills.debug_print(attributes, modifier_manager)

  # Remove our modifier.
  modifier_manager.remove_modifier("Flame Blade")

  attributes.debug_print(modifier_manager)
  derived_values.debug_print(attributes, modifier_manager)
  skills.debug_print(attributes, modifier_manager)