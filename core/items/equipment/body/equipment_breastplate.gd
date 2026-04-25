class_name EquipmentBreastplate extends Equipment

const NAME: String = "Breastplate"

func _init() -> void:
  super._init()

  # Base Item things.
  self.name = NAME
  self.description = "Armour. Armor. Armer? I 'ardly know 'er"
  self.icon = TextureManager.GENERIC_ICONS_1.make_icon(5)
  self.rarity = Item.ItemRarity.COMMON

  self.weight = 0.1
  self.base_price = 1

  # Equipment specific things.
  self.equipment_type = Equipment.EquipmentType.ARMOR
  self.slot = Equipment.EquipmentSlot.BODY
  self.attribute_requirements = {
    Attributes.STRENGTH: 65,
    Attributes.CONSTITUTION: 55
  }
  self.modifiers = _make_modifiers()
  self.init_uid()

static func _make_modifiers() -> Array[Modifier]:
  var armor_mod: Modifier = Modifier.new()
  armor_mod.source_name = NAME
  armor_mod.source_type = Modifier.ModifierSource.EQUIPMENT
  armor_mod.target_type = Modifier.ModifierTarget.DERIVED_STATISTIC
  armor_mod.stat_name = DerivedStatistics.ARMOR
  armor_mod.value = 40
  armor_mod.base_value = 40

  var agility_mod: Modifier = Modifier.new()
  agility_mod.source_name = NAME
  armor_mod.source_type = Modifier.ModifierSource.EQUIPMENT
  armor_mod.target_type = Modifier.ModifierTarget.ATTRIBUTE
  armor_mod.stat_name = Attributes.AGILITY
  armor_mod.value = -20
  armor_mod.base_value = -20

  return [armor_mod, agility_mod]