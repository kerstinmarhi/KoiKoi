extends CardState

const MOUSE_Y_SNAPBACK_TRESHOLD := 700

func enter():
	card.targets.clear()
	var offset := Vector2(card.parent.size.x/2, -card.size.y/2)
	offset.x -= card.size.x/2
	card.animate_to_position(card.parent.global_position + offset, 0.2)
	card.drop_point_detector.monitoring = false
	
	Events.card_aim_started.emit(card)
	
	
func exit():
	Events.card_aim_ended.emit(card)
	
	# Remove the card from hand and pool
	var pool = get_tree().get_root().get_node("GameScene/CardPool/CardPool/GridContainer")
	for child:PoolCard in pool.get_children():
		if child.selected.is_visible():
			var game_scene:Game = get_tree().get_root().get_node("GameScene")
			game_scene.player_played_cards.append(child.card_data)
			game_scene.player_played_cards.append(card.card_data)
			game_scene.player_hand.remove_at(card.get_index())
			game_scene.table_cards.remove_at(child.get_index())
			
			card.queue_free()
			child.queue_free()
			
			print("Match found: Card played and removed from hand and pool.")
			
			game_scene.player_hand.append(game_scene.deck.draw_card())
			game_scene.table_cards.append(game_scene.deck.draw_card())
			game_scene.update_player_hand_ui(game_scene.player_hand, game_scene.get_node("PlayerHand/Hand"))
			game_scene.update_pool_ui(game_scene.table_cards, pool)
	
func on_input(event: InputEvent):
	var mouse_motion := event is InputEventMouseMotion
	var mouse_at_bottom := card.get_global_mouse_position().y > MOUSE_Y_SNAPBACK_TRESHOLD
	
	if (mouse_motion and mouse_at_bottom) or event.is_action_pressed("right_mouse"):
		transition_requested.emit(self, CardState.State.BASE)
	elif event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse"):
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
