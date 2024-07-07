extends CardState

const MOUSE_Y_SNAPBACK_TRESHOLD := 700
var placed = false

func enter():
	card.targets.clear()
	if card.get_class() == "Card":
		var offset := Vector2(card.parent.size.x/2, -card.size.y/2)
		offset.x -= card.size.x/2
		card.animate_to_position(card.parent.global_position + offset, 0.2)
		card.drop_point_detector.monitoring = false
	
	Events.card_aim_started.emit(card)
	
	
func exit():
	Events.card_aim_ended.emit(card)
	
	var game_scene:Node = get_tree().get_root().get_node("GameScene")
	if game_scene is Game:
		var pool = get_tree().get_root().get_node("GameScene/CardPool/CardPool/GridContainer")
		if placed:
			if game_scene.is_card_in_container(card) == "drawn_card_display":
				game_scene.reparent_card(card.card_data)
				game_scene.end_turn()
			elif game_scene.is_card_in_container(card) == "player_hand_container":
				game_scene.reparent_card(card.card_data)
				game_scene.draw_and_play_card()
		else:
			for child:PoolCard in pool.get_children():
				if child.selected.is_visible():
					if game_scene.is_card_in_container(card) == "drawn_card_display":
						game_scene.remove_cards(card,child)
						game_scene.end_turn()
					elif game_scene.is_card_in_container(card) == "player_hand_container":
						game_scene.remove_cards(card,child)
						game_scene.draw_and_play_card()
		print("Player played card.")
	else:
		print("GameScene node not found or not of type Game")
	
	
	
func on_input(event: InputEvent):
	var mouse_motion := event is InputEventMouseMotion
	var mouse_at_bottom := card.get_global_mouse_position().y > MOUSE_Y_SNAPBACK_TRESHOLD
	var place = event.is_action_pressed("middle_click")
	
	if (mouse_motion and mouse_at_bottom) or event.is_action_pressed("right_mouse"):
		transition_requested.emit(self, CardState.State.BASE)
	elif event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse"):
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
	elif place:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.BASE)
		placed = true

