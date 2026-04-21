"""EVERYTHING we want to save needs to be here.

This is the thing that gets serialized / deserialized.
"""
class_name SaveData extends Resource

# Current Scene.
@export var scene_path: String

# Player stuffs.
@export var player_attributes: Attributes
@export var player_derived_statistics: DerivedStatistics
@export var player_skills: Skills
@export var player_class: CharacterClass
@export var player_level: int

@export var player_inventory_data: Array[InventorySlot]

@export var current_xp: float
@export var starting_xp_this_level: float
@export var total_xp_to_next_level: float
@export var current_health: float
@export var current_stamina: float
@export var current_mana: float
@export var player_position: Vector2

@export var active_static_modifiers: ModifierList
@export var active_effects: Array[Effect]
