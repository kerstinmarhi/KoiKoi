extends AudioStreamPlayer2D


const music = preload("res://Assets/sakura-dance-background-music-traditional-japanese-165338.mp3")

func _play_music(music: AudioStream, volume=0.0):
	if stream==music:
		return
	
	stream=music
	volume_db=volume
	play()
	
func play_bg_music():
	_play_music(music)
