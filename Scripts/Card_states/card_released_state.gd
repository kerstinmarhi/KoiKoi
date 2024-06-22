extends CardState

var played : bool

func enter():
	played=false
	if not card.targets.is_empty():
		played=true
		print("play card for targets:", card.targets)

func on_input(_event: InputEvent):
	if played:
		return
	
	transition_requested.emit(self,CardState.State.BASE)
	
