extends CardState

var played : bool

func enter():
	played=false
	if not card.targets.is_empty():
		played=true
		print("play card for targets:", card.targets)
		
		var target_card = card.targets[0]  # Only the first matching target is considered
		
		

func on_input(_event: InputEvent):
	if played:
		return
	
	transition_requested.emit(self,CardState.State.BASE)
	
