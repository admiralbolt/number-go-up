class_name Descriptions extends Node

const ATTRIBUTE_DESCRIPTIONS: Dictionary[String, String] = {
  "level": "What level your character is! Higher is better. Makes number go up.",
  "strength": "How much you can bench. Increases damage with physical attacks, carrying capacity, and max health.",
  "constitution": "Makes you beefier. Increases armor, max health, max stamina, health regeneration, and stamina regeneration.",
  "dexterity": "How deft your hands are. Increases accuracy & damage with physical attacks.",
  "agility": "How nimble you are. Increases movement speed & dodge.",
  "spirit": "The force of your soul. Increases damage with magical attacks, max mana, and affects health, mana, and stamina regeneration.",
  "wisdom": "Street-smarts. Increases magic resistance, and mana regeneration.",
  "intelligence": "How smart you are. Increase max mana, and affects what spells you can learn.",
  "charisma": "How charming you are. Better shop prices, better quest rewards, larger access to factions.",
  "luck": "How lucky you are. Increases your chances of finding better loot. Has a small impact on all saving throws."
}

const DERIVED_STATISTIC_DESCRIPTIONS: Dictionary[String, String] = {
  "max_health": "B E E F. Some extra lines of text and stuff here to make sure that this is actually filling to the screen width."
}