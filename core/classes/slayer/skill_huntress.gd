class_name SkillHuntress extends SkillNode

static var NAME: String = "Huntress"

static var SPEED_PER_RANK: float = 3
static var REGEN_PER_RANK: float = 1
static var DURATION_BASE: float = 5
static var DURATION_PER_RANK: float = 0.5

func _init() -> void:
  self.name = NAME
  self.description = "On kill, increases movement speed and health regeneration."
  self.node_type = SkillNodeType.TRIGGERED_ABILITY
  self.max_ranks = 10
  SignalBus.on_player_killed_enemy.connect(_on_kill)

func dynamic_description() -> String:
  return "On kill, increases movement speed (+%.2f) and health regeneration (+%.2f) for %.2f seconds." % [(SPEED_PER_RANK * self.ranks), (REGEN_PER_RANK * self.ranks), (DURATION_BASE + (DURATION_PER_RANK * self.ranks))]

func _create_on_kill_effect() -> MultiBuffEffect:
  var effect: MultiBuffEffect = MultiBuffEffect.new()
  var modifier_list: ModifierList = ModifierList.new()

  var speed_mod = Modifier.new()
  speed_mod.source_name = self.name
  speed_mod.source_type = Modifier.ModifierSource.SKILL_NODE_TRIGGERED
  speed_mod.target_type = Modifier.ModifierTarget.DERIVED_STATISTIC
  speed_mod.stat_name = DerivedStatistics.MOVEMENT_SPEED
  speed_mod.value = (SPEED_PER_RANK * self.ranks)
  speed_mod.modifier_type = Modifier.ModifierType.ADDITIVE
  speed_mod.modifier_priority = Modifier.ModifierPriority.APPLY_ADDITIVE
  speed_mod.sentiment = Modifier.ModifierSentiment.BUFF
  speed_mod.is_stackable = true
  speed_mod.is_decaying = false
  speed_mod.duration = DURATION_BASE + (DURATION_PER_RANK * self.ranks)
  speed_mod.is_timed = true

  var regen_mod = Modifier.new()
  regen_mod.source_name = self.name
  regen_mod.source_type = Modifier.ModifierSource.SKILL_NODE_TRIGGERED
  regen_mod.target_type = Modifier.ModifierTarget.DERIVED_STATISTIC
  regen_mod.stat_name = DerivedStatistics.HEALTH_REGEN
  regen_mod.value = (REGEN_PER_RANK * self.ranks)
  regen_mod.modifier_type = Modifier.ModifierType.ADDITIVE
  regen_mod.modifier_priority = Modifier.ModifierPriority.APPLY_ADDITIVE
  regen_mod.sentiment = Modifier.ModifierSentiment.BUFF
  regen_mod.is_stackable = true
  regen_mod.is_decaying = false
  regen_mod.duration = DURATION_BASE + (DURATION_PER_RANK * self.ranks)
  regen_mod.is_timed = true

  modifier_list.modifiers.append(speed_mod)
  modifier_list.modifiers.append(regen_mod)

  effect.modifiers = modifier_list

  return effect

func _on_kill(_target: Entity, _hit_box: HitBox, _total_damage: float) -> void:
  if not self.is_unlocked():
    return

  PlayerManager.player.effect_manager.apply_effect(self._create_on_kill_effect())
