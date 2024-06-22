extends Control

var player_points = 0
var enemy_points = 0

func _ready():
	update_ui()

func update_ui():
	# Aktualisiere die Punkteanzeige
	$PlayerPointsLabel.text = str(player_points)
	$EnemyPointsLabel.text = str(enemy_points)

func on_end_turn_button_pressed():
	# Logik für das Ende des Spielerzugs und den Beginn des Gegnerzugs
	get_tree().get_root().get_node("MainGame").end_player_turn()
