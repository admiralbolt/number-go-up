extends Node

const SAVE_PATH: String = "user://"

signal game_loaded
signal game_saved

func save_game() -> void:
  var save_data: SaveData = SaveData.new()
  save_data.scene_path = get_tree().current_scene.scene_file_path
  save_data.player_attributes = PlayerManager.player.attributes
  save_data.player_derived_statistics = PlayerManager.player.derived_statistics
  save_data.player_skills = PlayerManager.player.skills
  save_data.player_class = PlayerManager.player.character_class.duplicate(true)
  save_data.player_level = PlayerManager.player.level

  save_data.current_xp = PlayerManager.player.xp
  save_data.starting_xp_this_level = PlayerManager.player.starting_xp_this_level
  save_data.total_xp_to_next_level = PlayerManager.player.total_xp_to_next_level
  save_data.current_health = PlayerManager.player.current_health
  save_data.current_mana = PlayerManager.player.current_mana
  save_data.current_stamina = PlayerManager.player.current_stamina
  save_data.player_position = PlayerManager.player.position

  save_data.active_static_modifiers = PlayerManager.player.modifier_manager.get_static_modifiers().duplicate(true)
  save_data.active_effects = PlayerManager.player.effect_manager.active_effects.duplicate(true)

  ResourceSaver.save(save_data, SAVE_PATH + "save_game.tres")
  self.game_saved.emit()

func load_game() -> void:
  var save_data: Resource = ResourceLoader.load(SAVE_PATH + "save_game.tres", "SaveData", ResourceLoader.CACHE_MODE_IGNORE_DEEP)
  if save_data == null:
    print("No save data found.")
    return

  if save_data is not SaveData:
    print("Save data is corrupted!")
    return

  LevelManager.load_new_level(save_data.scene_path, "", Vector2.ZERO, true)
  await SignalBus.level_load_started

  PlayerManager.player.modifier_manager.reinitialize(save_data.active_static_modifiers.duplicate(true))
  PlayerManager.player.effect_manager.reinitialize(save_data.active_effects.duplicate(true))

  PlayerManager.player.attributes = save_data.player_attributes
  PlayerManager.player.derived_statistics = save_data.player_derived_statistics
  PlayerManager.player.skills = save_data.player_skills
  PlayerManager.player.initialize_stats()
  PlayerManager.player.character_class = save_data.player_class
  PlayerManager.player.level = save_data.player_level

  PlayerManager.player.xp = save_data.current_xp
  PlayerManager.player.starting_xp_this_level = save_data.starting_xp_this_level
  PlayerManager.player.total_xp_to_next_level = save_data.total_xp_to_next_level

  PlayerManager.player.current_health = save_data.current_health
  PlayerManager.player.current_mana = save_data.current_mana
  PlayerManager.player.current_stamina = save_data.current_stamina

  PlayerManager.player.position = save_data.player_position

  self.game_loaded.emit()
