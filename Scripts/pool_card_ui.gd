class_name PoolCard
extends Control

signal reparent_requested(which_card_ui: Card)
var card_data = null
@export var card: CardRes : set = _set_card
@onready var drop_point_detector = $DropPoint_Detector
@onready var selected = $DropPoint_Detector/Selected

@onready var image: Sprite2D = $SpriteCard

func set_card_data(data):
	card_data = data
	update_card_display()

func update_card_display():
	if card_data:
		# Lade das entsprechende Bild basierend auf den Monat und Typ
		$SpriteCard.texture = load("res://Assets/Cards/%s.png" %card_data.id)


func _on_drop_point_detector_area_entered(area):
	selected.show()


func _on_drop_point_detector_area_exited(area):
	selected.hide()

func _set_card(value: CardRes):
	if not is_node_ready():
		await ready
	card=value
	image.texture=card.sprite
