class_name ModifierManager extends Node

signal recomputes(recompute_targets: Dictionary[Modifier.ModifierTarget, RecomputeTargetList])

@export var all_modifiers: ModifierList = ModifierList.new()

var modifier_by_stat: Dictionary[String, ModifierPriorityQueue] = {}

func add_modifiers(modifiers: Array[Modifier]) -> void:
  var recompute_targets: Dictionary[Modifier.ModifierTarget, RecomputeTargetList] = {}
  for modifier in modifiers:
    if self.add_modifier(modifier, false):
      var target_list: RecomputeTargetList = recompute_targets.get(modifier.target_type)
      if target_list == null:
        target_list = RecomputeTargetList.new()
        recompute_targets[modifier.target_type] = target_list
      target_list.targets.append(RecomputeTarget.new(modifier.target_type, modifier.stat_name))

  if recompute_targets.size() > 0:
    self.recomputes.emit(recompute_targets)

func add_modifier(modifier: Modifier, emit_recompute: bool = true) -> bool:
  """Returns a bool value indicating if we need to recompute."""
  self.all_modifiers.modifiers.append(modifier)
  var modifier_queue: ModifierPriorityQueue = modifier_by_stat.get(modifier.stat_name)
  if modifier_queue == null:
    modifier_queue = ModifierPriorityQueue.new()
    modifier_by_stat[modifier.stat_name] = modifier_queue

  var should_emit: bool = modifier_queue.add_modifier(modifier)
  if emit_recompute and should_emit:
    self.recomputes.emit(emit_data(modifier))
  return should_emit

func update_modifier(modifier: Modifier, delta: float) -> void:
  if not modifier.is_timed:
    return

  modifier.timer -= delta
  if modifier.timer <= 0:
    # If it's a stackable modifier, we want to reduce the stack count, reset
    # the timer, and emit a recompute.
    if modifier.is_stackable and modifier.stack_count > 1:
      modifier.stack_count -= 1
      modifier.timer = modifier.duration
      self.recomputes.emit(emit_data(modifier))
      return

    # Otherwise, it's either not stackable OR down to the last stack.
    self.remove_modifier(modifier)
    return

  # Finally, if it's a decaying modifier, we do need to emit a recompute.
  if modifier.is_decaying:
    self.recomputes.emit(emit_data(modifier)) 
  

func remove_modifier(modifier: Modifier) -> void:
  var index: int = self.all_modifiers.get_index(modifier)
  if index == -1:
    return

  self.all_modifiers.modifiers.remove_at(index)
  var modifier_queue: ModifierPriorityQueue = modifier_by_stat.get(modifier.stat_name)
  modifier_queue.remove_modifier(modifier)
  self.recomputes.emit(emit_data(modifier))

func compute_total(stat_name: String, base_value: float) -> float:
  var modifier_queue: ModifierPriorityQueue = modifier_by_stat.get(stat_name)
  if modifier_queue == null:
    return base_value

  return modifier_queue.compute_total(base_value)

func debug_print() -> void:
  for modifier in self.all_modifiers.modifiers:
    print(modifier)


class ModifierPriorityQueue extends Resource:
  """A priority queue of modifiers to apply.

  Honestly, I don't expect to use any besides the default ones for additive and
  multiplicative modifiers, but I'm adding this just in case. If we need to
  add additional priorities in the future it shouldn't be too bad.

  It is assumed that all modifiers in the same priority queue should apply
  to the same stat.
  """
  @export var first_modifiers: ModifierQueue = ModifierQueue.new()
  @export var additive_modifiers: ModifierQueue = ModifierQueue.new()
  @export var multiplicative_modifiers: ModifierQueue = ModifierQueue.new()
  @export var last_modifiers: ModifierQueue = ModifierQueue.new()

  func add_modifier(p_modifier: Modifier) -> bool:
    match p_modifier.modifier_priority:
      Modifier.ModifierPriority.APPLY_FIRST:
        return self.first_modifiers.add_modifier(p_modifier)
      Modifier.ModifierPriority.APPLY_ADDITIVE:
        return self.additive_modifiers.add_modifier(p_modifier)
      Modifier.ModifierPriority.APPLY_MULTIPLICATIVE:
        return self.multiplicative_modifiers.add_modifier(p_modifier)
      Modifier.ModifierPriority.APPLY_LAST:
        return self.last_modifiers.add_modifier(p_modifier)

    return false


  func remove_modifier(p_modifier: Modifier) -> void:
    match p_modifier.modifier_priority:
      Modifier.ModifierPriority.APPLY_FIRST:
        self.first_modifiers.remove_modifier(p_modifier)
      Modifier.ModifierPriority.APPLY_ADDITIVE:
        self.additive_modifiers.remove_modifier(p_modifier)
      Modifier.ModifierPriority.APPLY_MULTIPLICATIVE:
        self.multiplicative_modifiers.remove_modifier(p_modifier)
      Modifier.ModifierPriority.APPLY_LAST:
        self.last_modifiers.remove_modifier(p_modifier)

  func compute_total(base_value: float) -> float:
    var val = base_value
    val = self.first_modifiers.compute(val)
    val = self.additive_modifiers.compute(val)
    val = self.multiplicative_modifiers.compute(val)
    val = self.last_modifiers.compute(val)
    return val


  class ModifierQueue extends Resource:
    """A queue for modifiers.

    The assumption is that all modifiers in the same queue should apply to the
    same stat AND at at the same priority.
    """
    @export var modifiers_by_name: Dictionary[String, Modifier] = {}

    func add_modifier(p_modifier: Modifier) -> bool:
      var modifier: Modifier = self.modifiers_by_name.get(p_modifier.unique_name)
      if modifier == null:
        self.modifiers_by_name[p_modifier.unique_name] = p_modifier
        return true

      # Whether or not it can stack, we want to refresh the duration.
      modifier.timer = max(modifier.duration, p_modifier.duration)

      if modifier.can_stack(p_modifier):
        modifier.stack_count += p_modifier.stack_count
        return true

      return false

    func remove_modifier(p_modifier: Modifier) -> void:
      self.modifiers_by_name.erase(p_modifier.unique_name)

    func compute(base_value: float) -> float:
      var val = base_value
      for modifier in self.modifiers_by_name.values():
        val = modifier.apply(val)
      return val


class ModifierList extends Resource:
  @export var modifiers: Array[Modifier] = []

  func get_index(p_modifier: Modifier) -> int:
    for i in range(modifiers.size()):
      if modifiers[i].eq(p_modifier):
        return i

    return -1


static func emit_data(modifier: Modifier) -> Dictionary[Modifier.ModifierTarget, RecomputeTargetList]:
  var target_list: RecomputeTargetList = RecomputeTargetList.new()
  target_list.targets.append(RecomputeTarget.new(modifier.target_type, modifier.stat_name))
  return {modifier.target_type: target_list}

class RecomputeTargetList:
  var targets: Array[RecomputeTarget] = []


class RecomputeTarget:
  var target_type: Modifier.ModifierTarget
  var stat_name: String

  func _init(p_target_type: Modifier.ModifierTarget, p_stat_name: String) -> void:
    self.target_type = p_target_type
    self.stat_name = p_stat_name