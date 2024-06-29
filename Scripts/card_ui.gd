class_name Card
extends Control

signal reparent_requested(which_card_ui: Card)
@export var card: CardRes : set = _set_card
var card_data = null
var original_position: Vector2
var card_moveable = true

var parent: Control
var tween: Tween

@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var drop_point_detector = $DropPoint_Detector
@onready var targets: Array[Node] = []

@onready var image: Sprite2D = $SpriteCard

func _ready():
	card_state_machine.init(self)
	# Die ursprüngliche Position nach einer kurzen Verzögerung speichern
	call_deferred("save_initial_position")

func _input(event):
	card_state_machine.on_input(event)

func _on_gui_input(event):
	card_state_machine.on_gui_input(event)

func _on_mouse_entered():
	card_state_machine.on_mouse_entered()
	
func _on_mouse_exited():
	card_state_machine.on_mouse_exited()

func set_card_data(data):
	card_data = data
	update_card_display()

func update_card_display():
	if card_data:
		# Lade das entsprechende Bild basierend auf den Monat und Typ
		$SpriteCard.texture = load("res://Assets/Cards/%s.png" % card_data.id)


func _on_drop_point_detector_area_entered(area):
	if not targets.has(area):
		targets.append(area)

func _on_drop_point_detector_area_exited(area):
	targets.erase(area)
	
# save position of card in hand
func save_initial_position():
	original_position = global_position
	print("Saved initial position: ", original_position)

# return card to hand
func return_to_original_position():
	global_position = original_position
	print("Returning to initial position: ", original_position)

# validate card position
func validate_card_position():
	if targets.size() == 0:
		return_to_original_position()
	else:
		card_moveable = false
		print("Card placed in valid drop zone")
		
func animate_to_position(new_position: Vector2, duration: float):
	tween=create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position,duration)

func _set_card(value: CardRes):
	if not is_node_ready():
		await ready
	card=value
	image.texture=card.sprite
