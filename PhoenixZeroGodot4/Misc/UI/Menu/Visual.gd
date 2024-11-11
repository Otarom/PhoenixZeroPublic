extends Panel

const RESOLUTIONS : Dictionary = {
	"1152 x 648" : Vector2i(1152,648),
	"1280 x 720" : Vector2i(1280,720),
	"1366 x 768" : Vector2i(1366,768),
	"1920 x 1080" : Vector2i(1920,1080)
}

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.loaded_setings.connect(init)

func init():
	if Global.clouds:
		$Clouds/CloudSelect.selected = Global.cloud_level
	else:
		$Clouds/CloudSelect.selected = 4
		
	$Bg/BgSelect.selected = Global.bgquality
	
	$Wall/WallSelect.selected = Global.wallquality
	
	$"Window Mode/WindowSelect".selected = Global.screen_mode
	
	$Resolution/ResSelect.selected = Global.resolution
	
	$VSync/VSyncCheck.button_pressed = Global.vsync
	
	Engine.max_fps = Global.user_settings.max_fps
	
	$MaxFPS/FPSSelect.selected = Engine.max_fps/30
	
	$CamInvert/CamInvertCheck.button_pressed = Global.cam_invert
	
	$CamRot/CamRotSlider.value = Global.camrotspd
	$CamRot/val.text = str(Global.camrotspd)
	
	match Global.screen_mode:
		0: # Fullscreen
			get_window().position = Vector2(0.5,0.5)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		1: # Borderless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		2: # Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_size(RESOLUTIONS.values()[Global.resolution])
			get_window().position = get_window().position + Vector2i(1,1)
	
	
	
	if Global.vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Resolution/ResSelect.disabled = Global.fullscreen
	pass


func _on_cloud_select_item_selected(index):
	if index == 4:
		Global.clouds = false
	else:
		Global.clouds = true
		Global.cloud_level = index
	Global.user_settings.clouds = Global.clouds
	Global.user_settings.cloud_level = Global.cloud_level
	Global.user_settings.save()
	Global.emit_signal("changed")



func _on_bg_select_item_selected(index):
	Global.bgquality = index
	Global.user_settings.bgquality = Global.bgquality
	Global.user_settings.save()
	Global.emit_signal("changed")

func _on_wall_select_item_selected(index):
	Global.wallquality = index
	Global.user_settings.wallquality = Global.wallquality
	Global.user_settings.save()
	Global.emit_signal("changed")

func _on_window_select_item_selected(index):
	Global.screen_mode = index
	Global.user_settings.screen_mode = Global.screen_mode
	Global.user_settings.save()
	match index:
		0: # Fullscreen
			if not Global.fullscreen:
				get_window().position = Vector2(0.5,0.5)
			Global.fullscreen = true
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		1: # Borderless
			Global.fullscreen = true
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		2: # Windowed
			Global.fullscreen = false
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_size(RESOLUTIONS.values()[Global.resolution])
			get_window().position = get_window().position + Vector2i(1,1)
		


func _on_res_select_item_selected(index):
	Global.resolution = index
	Global.user_settings.resolution = Global.resolution
	Global.user_settings.save()
	DisplayServer.window_set_size(RESOLUTIONS.values()[index])
	get_window().position = get_window().position + Vector2i(1,1)


func _on_v_sync_check_toggled(button_pressed):
	Global.vsync = button_pressed
	Global.user_settings.vsync = Global.vsync
	Global.user_settings.save()
	if button_pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_fps_select_item_selected(index):
	Engine.max_fps = 30*index
	Global.user_settings.max_fps = Engine.max_fps
	Global.user_settings.save()


func _on_cam_invert_check_toggled(button_pressed):
	Global.cam_invert = button_pressed
	Global.user_settings.cam_invert = Global.cam_invert
	Global.user_settings.save()


func _on_cam_rot_slider_value_changed(value):
	$CamRot/val.text = str(value)
	Global.camrotspd = value
	Global.user_settings.camrotspd = Global.camrotspd
	Global.user_settings.save()
	pass # Replace with function body.



