class_name Player
extends Node2D

@export var character_stats:Stats:set=set_character_stats
@onready var stats_ui : StatsUI = $StatsUi as StatsUI
var hand: Array[CardRes] = []
var played_cards: Array[CardRes] = []


func set_character_stats(value: Stats):
	if value == null:
		print("Error: character_stats is null")
		return
	
	character_stats = value.create_instance()
	if not character_stats.stats_changed.is_connected(update_stats):
		character_stats.stats_changed.connect(update_stats)
		
	update_player()
	
func update_player():
	if not character_stats is Stats:
		return
	
	if not is_inside_tree():
		await ready
	update_stats()
	
func update_stats():
	stats_ui.update_points(character_stats)
	
func take_damage(damage:int):
	
	if character_stats.health<=0:
		return
	character_stats.take_damage(damage)
	
	if character_stats.health <= 0:
		queue_free()



