class_name Enemy
extends Node2D

@export var character_stats:Stats:set=set_character_stats
@onready var stats_ui : StatsUI = $StatsUi as StatsUI
@export var play_interval: float = 3.0  # Zeitintervall zwischen Zügen des Gegners
var hand: Array[CardRes] = []

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

func start_playing():
	# Startet einen Timer, der die Karte nach einer bestimmten Zeit ausspielt
	var play_timer = Timer.new()
	add_child(play_timer)
	play_timer.wait_time = play_interval
	play_timer.connect(play_timer.timeout, _on_play_timer_timeout)
	play_timer.start()

func _on_play_timer_timeout():
	play_card()
	start_playing()  # Startet den Timer erneut

func play_card():
	if hand.size() == 0:
		return

	var card_to_play = hand.pop_front()  # Beispiel: Nimm die erste Karte aus der Hand
	var targets = get_card_targets(card_to_play)  # Finde Ziele für die Karte
	card_to_play.play(targets, character_stats)

func get_card_targets(card: CardRes) -> Array[Node]:
	# Logik zum Finden der Ziele der Karte
	return []
