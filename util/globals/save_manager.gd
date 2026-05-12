extends Node

const SAVE_PATH: String = "user://"

signal game_loaded
signal game_saved

var starting_timestamp: float

func _ready() -> void:
  self.starting_timestamp = Time.get_unix_time_from_system()

func save_game(slot: int) -> SaveData:
  var save_data: SaveData = SaveData.new()
  save_data.scene_path = get_tree().current_scene.scene_file_path
  save_data.character_name = PlayerManager.player.character_name
  save_data.player_attributes = PlayerManager.player.attributes
  save_data.player_derived_statistics = PlayerManager.player.derived_statistics
  save_data.player_skills = PlayerManager.player.skills
  save_data.player_class = PlayerManager.player.character_class.duplicate(true)
  save_data.player_level = PlayerManager.player.level

  save_data.player_inventory_data = PlayerManager.player.inventory.serialize()
  save_data.player_equipment = PlayerManager.player.equipment_manager.get_equipped_items()

  save_data.current_xp = PlayerManager.player.xp
  save_data.starting_xp_this_level = PlayerManager.player.starting_xp_this_level
  save_data.total_xp_to_next_level = PlayerManager.player.total_xp_to_next_level
  save_data.current_health = PlayerManager.player.current_health
  save_data.current_mana = PlayerManager.player.current_mana
  save_data.current_stamina = PlayerManager.player.current_stamina
  save_data.player_position = PlayerManager.player.position

  save_data.active_static_modifiers = PlayerManager.player.modifier_manager.get_static_modifiers().duplicate(true)
  save_data.active_effects = PlayerManager.player.effect_manager.active_effects.duplicate(true)

  save_data.timestamp = Time.get_unix_time_from_system()
  save_data.play_time = save_data.play_time + (save_data.timestamp - self.starting_timestamp)

  ResourceSaver.save(save_data, "user://save_game_%s.tres" % slot)
  self.game_saved.emit()

  return save_data

func load_save_data(slot: int) -> SaveData:
  if not FileAccess.file_exists("user://save_game_%s.tres" % slot):
    return null
  
  var save_data: Resource = ResourceLoader.load("user://save_game_%s.tres" % slot, "SaveData", ResourceLoader.CACHE_MODE_IGNORE_DEEP)
  if save_data is not SaveData:
    print("Save data is corrupted!")
    return null

  return save_data

func load_game(slot: int) -> void:
  var save_data: Resource = self.load_save_data(slot)

  LevelManager.load_new_level(save_data.scene_path, "", Vector2.ZERO, true)
  await SignalBus.level_load_started

  PlayerManager.player.modifier_manager.reinitialize(save_data.active_static_modifiers.duplicate(true))
  PlayerManager.player.effect_manager.reinitialize(save_data.active_effects.duplicate(true))

  PlayerManager.player.character_name = save_data.character_name
  PlayerManager.player.attributes = save_data.player_attributes
  PlayerManager.player.derived_statistics = save_data.player_derived_statistics
  PlayerManager.player.skills = save_data.player_skills
  PlayerManager.player.initialize_stats()
  PlayerManager.player.character_class = save_data.player_class
  PlayerManager.player.level = save_data.player_level

  PlayerManager.player.inventory.load_from_list(save_data.player_inventory_data)
  PlayerManager.player.equipment_manager.reinitialize(save_data.player_equipment.duplicate(true))

  PlayerManager.player.xp = save_data.current_xp
  PlayerManager.player.starting_xp_this_level = save_data.starting_xp_this_level
  PlayerManager.player.total_xp_to_next_level = save_data.total_xp_to_next_level

  PlayerManager.player.current_health = save_data.current_health
  PlayerManager.player.current_mana = save_data.current_mana
  PlayerManager.player.current_stamina = save_data.current_stamina

  PlayerManager.player.position = save_data.player_position

  self.starting_timestamp = Time.get_unix_time_from_system()
  self.game_loaded.emit()
