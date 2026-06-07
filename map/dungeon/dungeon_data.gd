class_name DungeonData extends Resource

# Track state of all levers, doors, chests e.t.c.
@export var interactables_state: Dictionary[String, bool] = {}

# Track's the state of all entities.
@export var entity_state: Dictionary[String, EntityState] = {}

