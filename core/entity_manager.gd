"""Simple manager for mapping entity ids -> entities.

Primarily just for tracking who owns what without needing to pass a reference
to the entity around.
"""

extends Node

var entities: Dictionary[String, Entity] = {}

func add_entity(entity: Entity) -> void:
  entities[entity.entity_id] = entity

func remove_entity(entity: Entity) -> void:
  entities.erase(entity.entity_id)

func get_entity(p_entity_id: String) -> Entity:
  return entities.get(p_entity_id, null)
