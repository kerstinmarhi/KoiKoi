extends Node2D

const ARC_POINTS := 30
@onready var area2d: Area2D = $Area2D
@onready var cardarc: Line2D = $CanvasLayer/CardArc

var current_card: Card
var targeting = false

func _ready():
	Events.card_aim_started.connect(_on_card_aim_started)
	Events.card_aim_ended.connect(_on_card_aim_ended)
	
func _process(delta):
	if not targeting:
		return
	
	area2d.position=get_local_mouse_position()
	cardarc.points=_get_points()
	
func _get_points() -> Array:
	var points=[]
	var start=current_card.global_position
	start.x += (current_card.size.x / 2)
	var target := get_local_mouse_position()
	var distance : Vector2= (target - start)
	
	for i in range(ARC_POINTS):
		var t := (1.0 / ARC_POINTS)*i
		var x :float= start.x + (distance.x / ARC_POINTS) * i
		var y :float= start.y + ease_out_cubic(t) * distance.y
		points.append(Vector2(x,y))
	
	points.append(target)
	return points
	
func ease_out_cubic(number: float) -> float:
	return 1.0 - pow(1.0 - number, 3.0)

func _on_card_aim_started(card: Card):
	targeting = true
	area2d.monitorable = true
	area2d.monitoring = true
	current_card = card

func _on_card_aim_ended(card: Card):
	targeting = false
	cardarc.clear_points()
	area2d.position=Vector2.ZERO
	area2d.monitorable = false
	area2d.monitoring = false
	current_card=null
	
func _on_area_2d_area_entered(area: Area2D):
	print("Entered card area")
	if not current_card or not targeting:
		return
	
	if not current_card.targets.has(area):
		current_card.targets.append(area)
		
	
func _on_area_2d_area_exited(area: Area2D):
	if not current_card or not targeting:
		return
	
	current_card.targets.erase(area)
