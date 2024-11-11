extends CanvasLayer

var menu = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Start")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and not menu:
		$AnimationPlayer.play("Menu")
		menu = true
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Start":
		$VideoStreamPlayer.play()
	pass # Replace with function body.


func _on_video_stream_player_finished():
	$OtaromStudios.visible=true
	$AnimationPlayer.play("Menu")
	menu = true
	pass # Replace with function body.


func _on_music_finished():
	$Music.play()
	pass # Replace with function body.
