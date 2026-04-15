class_name SkillSlice extends SkillNode

static var NAME: String = "Slice"

static var BLEED_DAMAGE_PER_SECOND_BASE: float = 5.0
static var BLEED_DAMAGE_PER_SECOND_PER_RANK: float = 1.0
static var BLEED_DURATION_BASE: float = 4.0
static var BLEED_DURATION_PER_RANK: float = 0.5

func _init() -> void:
  self.name = NAME
  self.description = "On hit, apply bleed."
  self.icon_path = "res://assets/classes/slayer/slice.png"
  self.node_type = SkillNodeType.TRIGGERED_ABILITY
  self.max_ranks = 10
  SignalBus.on_player_attack_landed.connect(_on_attack_landed)

func dynamic_description() -> String:
  var lines: Array[String] = []

  return "\n".join(lines)

func _create_on_hit_effect() -> BleedEffect:
  var effect: BleedEffect = BleedEffect.new()
  effect.owner_entity_id = PlayerManager.player.entity_id
  effect.damage_per_second = BLEED_DAMAGE_PER_SECOND_BASE + (BLEED_DAMAGE_PER_SECOND_PER_RANK * self.ranks)
  effect.duration = BLEED_DURATION_BASE + (BLEED_DURATION_PER_RANK * self.ranks)
  effect.timer = effect.duration
  return effect

func _on_attack_landed(event: Damage.HitEvent) -> void:
  if not self.is_unlocked():
    return

  event.target.effect_manager.apply_effect(self._create_on_hit_effect())