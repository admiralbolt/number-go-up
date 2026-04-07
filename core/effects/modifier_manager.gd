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
  var modifier_queue: ModifierPriorityQueue = modifier_by_stat.get(modifier.stat_name)
  if modifier_queue == null:
    modifier_queue = ModifierPriorityQueue.new()
    modifier_by_stat[modifier.stat_name] = modifier_queue

  # If a modifier doesn't exist, add it and return.
  var existing_modifier: Modifier = self.get_modifier(modifier)

  if existing_modifier == null:
    self.all_modifiers.modifiers.append(modifier)
    var should_emit: bool = modifier_queue.add_modifier(modifier)
    if emit_recompute and should_emit:
      self.recomputes.emit(emit_data(modifier))
    return should_emit

  # If the modifier does exist, we want to refresh the duration and/or
  # potentially add stacks to it.
  existing_modifier.timer = max(existing_modifier.duration, modifier.duration)

  if existing_modifier.is_stackable:
    existing_modifier.stack_count += modifier.stack_count
    if emit_recompute:
      self.recomputes.emit(emit_data(modifier))
      return true

  return false

func get_modifier(modifier: Modifier) -> Modifier:
  var modifier_queue: ModifierPriorityQueue = modifier_by_stat.get(modifier.stat_name)
  if modifier_queue == null:
    return null

  match modifier.modifier_priority:
    Modifier.ModifierPriority.APPLY_FIRST:
      return modifier_queue.first_modifiers.modifiers_by_name.get(modifier.unique_name)
    Modifier.ModifierPriority.APPLY_ADDITIVE:
      return modifier_queue.additive_modifiers.modifiers_by_name.get(modifier.unique_name)
    Modifier.ModifierPriority.APPLY_MULTIPLICATIVE:
      return modifier_queue.multiplicative_modifiers.modifiers_by_name.get(modifier.unique_name)
    Modifier.ModifierPriority.APPLY_LAST:
      return modifier_queue.last_modifiers.modifiers_by_name.get(modifier.unique_name)

  return null

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

func compute_total_description(stat_name: String, base_value: float) -> Array[String]:
  var modifier_queue: ModifierPriorityQueue = modifier_by_stat.get(stat_name)
  if modifier_queue == null:
    return []

  return modifier_queue.compute_total_description(base_value)

func clear() -> void:
  self.all_modifiers.modifiers.clear()
  self.modifier_by_stat.clear()

func reinitialize(modifiers: ModifierList) -> void:
  self.clear()
  for modifier in modifiers.modifiers:
    self.add_modifier(modifier)

func get_static_modifiers() -> ModifierList:
  """This returns a modifier list of NON-EFFECT modifiers.

  These are typically added directly to the manager, and not through an effect,
  so we need to save and reload these when save and load our game. The effect
  manager will reinitialize all of the active effects, and those will reapply
  their modifiers properly.
  """
  var static_modifiers: ModifierList = ModifierList.new()
  for modifier in self.all_modifiers.modifiers:
    if modifier.source_type == Modifier.ModifierSource.EQUIPMENT or modifier.source_type == Modifier.ModifierSource.SKILL_NODE:
      static_modifiers.modifiers.append(modifier)

  return static_modifiers

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

  func compute_total_description(base_value: float) -> Array[String]:
    var descriptions: Array[String] = []
    descriptions += self.first_modifiers.compute_total_description(base_value)
    descriptions += self.additive_modifiers.compute_total_description(base_value)
    descriptions += self.multiplicative_modifiers.compute_total_description(base_value)
    descriptions += self.last_modifiers.compute_total_description(base_value)
    return descriptions


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

    func compute_total_description(base_value: float) -> Array[String]:
      var descriptions: Array[String] = []
      var val = base_value
      for modifier in self.modifiers_by_name.values():
        descriptions.append("%s:\n\t%.2f -> %.2f" % [modifier.readable_string(), val, modifier.apply(val)] )
        val = modifier.apply(val)

      return descriptions


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