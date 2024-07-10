extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/MasterSlider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$HBoxContainer/BackgroundMusicSlider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$HBoxContainer/SoundEffectsSlider.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	

func _on_sound_effects_slider_mouse_exited():
	release_focus() 


func _on_background_music_slider_mouse_exited():
	release_focus() 


func _on_master_slider_mouse_exited():
	release_focus() 
