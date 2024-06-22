class_name StatsUI
extends HBoxContainer

@onready var left_points: Sprite2D = %PointsLeft 
@onready var right_points: Sprite2D = %PointsRight

var left_0 = preload("res://Assets/hands/left/0.png")
var left_1 = preload("res://Assets/hands/left/1.png")
var left_2 = preload("res://Assets/hands/left/2.png")
var left_3 = preload("res://Assets/hands/left/3.png")
var left_4 = preload("res://Assets/hands/left/4.png")
var left_5 = preload("res://Assets/hands/left/5.png")
var right_5 = preload("res://Assets/hands/right/5i.png")
var right_4 = preload("res://Assets/hands/right/4i.png")
var right_3 = preload("res://Assets/hands/right/3i.png")
var right_2 = preload("res://Assets/hands/right/2i.png")
var right_1 = preload("res://Assets/hands/right/1i.png")
var right_0 = preload("res://Assets/hands/right/0i.png")

func update_points(stats: Stats):
	if stats.health == 10:
		left_points.texture=left_5
		right_points.texture=right_5
	elif stats.health == 9:
		left_points.texture=left_4
		right_points.texture=right_5
	elif stats.health == 8:
		left_points.texture=left_4
		right_points.texture=right_4
	elif stats.health == 7:
		left_points.texture=left_3
		right_points.texture=right_4
	elif stats.health == 6:
		left_points.texture=left_3
		right_points.texture=right_3
	elif stats.health == 5:
		left_points.texture=left_2
		right_points.texture=right_3
	elif stats.health == 4:
		left_points.texture=left_2
		right_points.texture=right_2
	elif stats.health == 3:
		left_points.texture=left_1
		right_points.texture=right_2
	elif stats.health == 2:
		left_points.texture=left_1
		right_points.texture=right_1
	elif stats.health == 1:
		left_points.texture=left_0
		right_points.texture=right_1
	elif stats.health == 0:
		left_points.texture=left_0
		right_points.texture=right_0
	
