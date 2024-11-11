extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.loaded_setings.connect(init)

func init():
	AudioServer.set_bus_volume_db(0,Global.user_settings.master)
	AudioServer.set_bus_volume_db(1,Global.user_settings.music)
	AudioServer.set_bus_volume_db(2,Global.user_settings.playersfx)
	AudioServer.set_bus_volume_db(3,Global.user_settings.enemsfx)
	AudioServer.set_bus_volume_db(4,Global.user_settings.explsfx)
	
	$Master/MasterSlider.value = AudioServer.get_bus_volume_db(0)
	$Music/MusicSlider.value = AudioServer.get_bus_volume_db(1)
	$PlayerSFX/PlayerSFXSlider.value = AudioServer.get_bus_volume_db(2)
	$EnemSFX/EnemSFXSlider.value = AudioServer.get_bus_volume_db(3)
	$ExplSFX/ExplSFXSlider.value = AudioServer.get_bus_volume_db(4)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)
	
func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)
	
func _on_player_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)
	
func _on_enem_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(3, value)
	
func _on_expl_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(4, value)
	


func _on_player_sfx_slider_drag_ended(value_changed):
	$TestAudio.bus = "PlayerSFX"
	$TestAudio.volume_db = -22
	$TestAudio.pitch_scale = 1.1
	$TestAudio.stream = load("res://Player/SFX/ReloadReady.wav")
	$TestAudio.play()
	Global.user_settings.playersfx = AudioServer.get_bus_volume_db(2)
	Global.user_settings.save()


func _on_enem_sfx_slider_drag_ended(value_changed):
	$TestAudio.bus = "EnemSFX"
	$TestAudio.volume_db = -10
	$TestAudio.pitch_scale = 1
	$TestAudio.stream = load("res://Player/SFX/ReloadReady.wav")
	$TestAudio.play()
	Global.user_settings.enemsfx = AudioServer.get_bus_volume_db(3)
	Global.user_settings.save()


func _on_expl_sfx_slider_drag_ended(value_changed):
	$TestAudio.bus = "ExplSFX"
	$TestAudio.volume_db = -15
	$TestAudio.pitch_scale = 0.8
	$TestAudio.stream = load("res://Misc/VFX/3D_Explosion/EnemExplosion5.wav")
	$TestAudio.play()
	Global.user_settings.explsfx = AudioServer.get_bus_volume_db(4)
	Global.user_settings.save()


func _on_master_slider_drag_ended(value_changed):
	Global.user_settings.master = AudioServer.get_bus_volume_db(0)
	Global.user_settings.save()
	pass # Replace with function body.


func _on_music_slider_drag_ended(value_changed):
	Global.user_settings.music = AudioServer.get_bus_volume_db(1)
	Global.user_settings.save()
	pass # Replace with function body.
