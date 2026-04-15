extends Node

var entities: Dictionary[String, Entity] = {}

func add_entity(entity: Entity) -> void:
  entities[entity.name] = entity

func remove_entity(entity: Entity) -> void:
  entities.erase(entity.name)

func get_entity(p_name: String) -> Entity:
  return entities.get(p_name, null)