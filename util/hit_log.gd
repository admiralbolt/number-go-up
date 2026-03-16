class_name HitLog extends RefCounted

var hits: Array[Node] = []

func has_hit(node: Node) -> bool:
  return node in hits

func log_hit(node: Node) -> void:
  hits.append(node)
