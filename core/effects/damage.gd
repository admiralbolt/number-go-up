class_name Damage extends RefCounted

enum DamageType {
  # Physical types
  SLASHING,
  PIERCING,
  BLUDGEONING,

  # Magical/status types
  FIRE,
  ICE,
  LIGHTNING,
  POISON,
  BLEED,
  ARCANE,
  HOLY,
  DARK,

  # True damage ignores all defenses
  TRUE,
}