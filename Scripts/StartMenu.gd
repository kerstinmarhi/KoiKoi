extends Control

func _ready():
	$Button_NewGame.pressed.connect(self._on_NewGame_pressed)
	$Button_End.pressed.connect(self._on_Quit_pressed)

func _on_NewGame_pressed():
	get_tree().change_scene_to_file("res://Scenes/GameScene.tscn")


func _on_Quit_pressed():
	get_tree().quit()
