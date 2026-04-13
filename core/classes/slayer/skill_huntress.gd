class_name SkillHuntress extends SkillNode

static var NAME: String = "Huntress"

static var SPEED_BASE: float = 2
static var SPEED_PER_RANK: float = 0.25
static var REGEN_BASE: float = 0.5
static var REGEN_PER_RANK: float = 0.1
static var DURATION_BASE: float = 4
static var DURATION_PER_RANK: float = 0.4

const HUNTRESS_EFFECT_ICON: Texture2D = preload("res://assets/effects/icons/huntress.png")

func _init() -> void:
  self.name = NAME
  self.description = "On kill, increases movement speed and health regeneration."
  self.icon_path = "res://assets/classes/slayer/huntress.png"
  self.node_type = SkillNodeType.TRIGGERED_ABILITY
  self.max_ranks = 10
  SignalBus.on_player_killed_enemy.connect(_on_kill)

func dynamic_description() -> String:
  var lines: Array[String] = []

  lines.append("On kill, increases movement speed (+%.2f) and health regeneration (+%.2f) for %.2f seconds." % [(SPEED_BASE + SPEED_PER_RANK * self.ranks), (REGEN_BASE + REGEN_PER_RANK * self.ranks), (DURATION_BASE + (DURATION_PER_RANK * self.ranks))])
  lines.append("-----------")
  lines.append(SKILL_NODE_TYPE_NAMES[self.node_type])
  lines.append("")
  lines.append("On kill, increases movement speed by (%.2f + %.2f * ranks) and health regeneration by (%.2f + %.2f * ranks) for (%.2f + %.2f * ranks) seconds, per stack." % [SPEED_BASE, SPEED_PER_RANK, REGEN_BASE, REGEN_PER_RANK, DURATION_BASE, DURATION_PER_RANK])

  return "\n".join(lines)

func _create_on_kill_effect() -> BuffEffect:
  var effect: BuffEffect = BuffEffect.new()

  var speed_mod = Modifier.new()
  speed_mod.source_name = self.name
  speed_mod.source_type = Modifier.ModifierSource.SKILL_NODE_TRIGGERED
  speed_mod.target_type = Modifier.ModifierTarget.DERIVED_STATISTIC
  speed_mod.stat_name = DerivedStatistics.MOVEMENT_SPEED
  speed_mod.value = SPEED_BASE + (SPEED_PER_RANK * self.ranks)
  speed_mod.base_value = speed_mod.value
  speed_mod.modifier_type = Modifier.ModifierType.ADDITIVE
  speed_mod.modifier_priority = Modifier.ModifierPriority.APPLY_ADDITIVE
  speed_mod.sentiment = Modifier.ModifierSentiment.BUFF

  var regen_mod = Modifier.new()
  regen_mod.source_name = self.name
  regen_mod.source_type = Modifier.ModifierSource.SKILL_NODE_TRIGGERED
  regen_mod.target_type = Modifier.ModifierTarget.DERIVED_STATISTIC
  regen_mod.stat_name = DerivedStatistics.HEALTH_REGEN
  regen_mod.value = REGEN_BASE + (REGEN_PER_RANK * self.ranks)
  regen_mod.base_value = regen_mod.value
  regen_mod.modifier_type = Modifier.ModifierType.ADDITIVE
  regen_mod.modifier_priority = Modifier.ModifierPriority.APPLY_ADDITIVE
  regen_mod.sentiment = Modifier.ModifierSentiment.BUFF

  effect.is_stackable = true
  effect.is_decaying = false
  effect.duration = DURATION_BASE + (DURATION_PER_RANK * self.ranks)
  effect.timer = effect.duration
  effect.modifiers.modifiers.append(speed_mod)
  effect.modifiers.modifiers.append(regen_mod)
  effect.icon = HUNTRESS_EFFECT_ICON

  return effect

func _on_kill(_event: Damage.FinalDamageEvent) -> void:
  if not self.is_unlocked():
    return

  PlayerManager.player.effect_manager.apply_effect(self._create_on_kill_effect())
 