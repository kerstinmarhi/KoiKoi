extends Control

@export var card: CardRes : set = _set_card
var card_data = null
@onready var image: Sprite2D = $SpriteCard

func set_card_data(data):
	card_data = data
	update_card_display()

func update_card_display():
	if card_data:
		# Lade das entsprechende Bild basierend auf den Monat und Typ
		$SpriteCard.texture = load("res://Assets/Cards/%s.png" % card_data.id)

func _set_card(value: CardRes):
	if not is_node_ready():
		await ready
	card=value
	image.texture=card.sprite
