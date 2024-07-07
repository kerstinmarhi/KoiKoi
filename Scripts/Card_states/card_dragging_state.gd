extends CardState

const DRAGGING_MINIMUM_TRESHOLD = 0.05
var minimum_drag_time_elapsed=false

func enter()->void:
	var ui_layer := get_tree().get_first_node_in_group("ui_layer") 
	if ui_layer:
		card.reparent(ui_layer)
	minimum_drag_time_elapsed=false
	var treshold_timer:= get_tree().create_timer(DRAGGING_MINIMUM_TRESHOLD,false)
	treshold_timer.timeout.connect(func(): minimum_drag_time_elapsed=true)
	
func on_input(event: InputEvent) -> void:
	var mouse_motion := event is InputEventMouseMotion
	var cancel = event.is_action_pressed("right_mouse")
	var confirm = event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")
	
	if mouse_motion and card.targets.size() > 0:
		transition_requested.emit(self,CardState.State.AIMING)
		return
	
	if mouse_motion:
		card.global_position = card.get_global_mouse_position() - card.pivot_offset
		
	
	if cancel:
		transition_requested.emit(self,CardState.State.BASE)
	elif minimum_drag_time_elapsed and confirm:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self,CardState.State.RELEASED)
		
