class_name HitLog extends RefCounted

var hit_log: Array[Node] = []

func has_hit(node: Node) -> bool:
  return node in hit_log

func log_hit(node: Node) -> void:
  hit_log.append(node)
