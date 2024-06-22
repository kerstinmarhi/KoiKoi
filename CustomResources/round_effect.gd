class_name RoundEffect
extends Effect

# Signal, das ausgesendet wird, wenn die Runde beendet ist
signal round_ended

var current_player_index: int = 0

func execute(_targets: Array[Node]):
	if _targets.size() == 0:
		return

	if current_player_index >= _targets.size():
		current_player_index = 0

	var current_player = _targets[current_player_index]

	draw_card(current_player)
	play_card(current_player)
	check_win_conditions(current_player)

	current_player_index += 1

	if current_player_index >= _targets.size():
		emit_signal("round_ended")
	else:
		# Call execute again for the next player
		execute(_targets)

func draw_card(player: Node):
	print("Drawing a card for player: ", player.name)
	if player.has_method("draw_card"):
		player.draw_card()

func play_card(player: Node):
	print("Playing a card for player: ", player.name)
	if player.has_method("play_card"):
		player.play_card()

func check_win_conditions(player: Node):
	print("Checking win conditions for player: ", player.name)
	if player.has_method("check_win_conditions"):
		player.check_win_conditions()
