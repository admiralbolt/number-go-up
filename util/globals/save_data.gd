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
@export var current_health: float
@export var current_stamina: float
@export var current_mana: float
@export var player_position: Vector2