class_name Hand
extends HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(get_children())
	for child in get_children():
		var card := child as Card
		card.parent=self
		card.reparent_requested.connect(_on_card_ui_reparent_requested)
		card.original_position = card.global_position

func _on_card_ui_reparent_requested(child: Card) -> void:
	child.reparent(self)
