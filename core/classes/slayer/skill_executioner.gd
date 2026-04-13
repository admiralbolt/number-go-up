class_name SkillExecutioner extends SkillNode

const NAME: String = "Executioner"

# This is a funny constant to think about, but this is the damage increase
# for each 1% HP missing. So if this was set to 0.01, then we'd deal 1% more
# damage for each 1% missing HP. Which is surprisingly strong.
# 
# I'll need to mess around with numbers here to figure out what this should
# be exactly, but I want it to cap at 1% per 1%, therefore it should be 0.2.
const DAMAGE_INCREASE_PER_MISSING_HP_PERCENT_PER_RANK: float = 0.2

func _init() -> void:
  self.name = NAME
  self.description = "Deal more damage based on missing HP."
  self.icon_path = "res://assets/classes/slayer/executioner.png"
  self.node_type = SkillNodeType.PASSIVE_MODIFIER
  self.max_ranks = 5
  self.required_level = 10

  SignalBus.on_damage_pre_apply.connect(_on_damage_pre_apply)

func dynamic_description() -> String:
  var lines: Array[String] = []

  lines.append("Increase damage dealt by %.2f%% for each 1%% of the targets missing HP." % (DAMAGE_INCREASE_PER_MISSING_HP_PERCENT_PER_RANK * self.ranks))
  lines.append("-----------")
  lines.append(SKILL_NODE_TYPE_NAMES[self.node_type])
  lines.append("")

  return "\n".join(lines)

func _on_damage_pre_apply(event: Damage.DamageCalculationEvent) -> void:
  if not self.is_unlocked():
    return

  # Eventually I think I'll need to figure out how to differentiate between
  # damage sources. In the case of an enchanted weapon, we probably don't
  # want to increase the damage of the enchantment, just the base damage.
  # Don't have an easy way of differentiating that quite yet.
  event.raw_damage *= (1 + (DAMAGE_INCREASE_PER_MISSING_HP_PERCENT_PER_RANK * self.ranks * (1 - (event.target.current_health / event.target.derived_statistics.max_health.total_value))))

  return
