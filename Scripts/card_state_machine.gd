class_name CardStateMachine
extends Node

@export var initial_state: CardState
var current_state: CardState
var states:={}

func init(card: Card) -> void:
	for child in get_children():
		if child is CardState:
			states[child.state]=child
			child.transition_requested.connect(_on_transition_requested)
			child.card=card
	if initial_state:
		initial_state.enter()
		current_state=initial_state

func on_input(event: InputEvent)->void:
	if current_state:
		current_state.on_input(event)
	# Aufruf von validate_card_position beim Loslassen der linken Maustaste
	if event is InputEventMouseButton and current_state.card.card_moveable:
		if event.button_index == MOUSE_BUTTON_LEFT:
			current_state.card.validate_card_position()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			current_state.card.return_to_original_position()
		
func on_gui_input(event: InputEvent)->void:
	if current_state:
		current_state.on_gui_input(event)
		
func on_mouse_entered()->void:
	if current_state:
		current_state.on_mouse_entered()
		
func on_mouse_exited()->void:
	if current_state:
		current_state.on_mouse_exited()
		
func _on_transition_requested(from: CardState, to: CardState.State) -> void:
	if from !=current_state:
		return
	
	var new_state: CardState = states[to]
	if not new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state=new_state
