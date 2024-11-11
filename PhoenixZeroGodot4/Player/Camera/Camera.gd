extends Marker3D

var cameraAngle = 180
var rotspd = 2
var camZoom = 2
var cam_lock = false
var _dragging = false
var _camPrevpos = Vector2(0, 0)
var cam_mode = 0
var max_zoom = 1
@export var cam_invert = false

@onready var camera = $PlayerCamera
@onready var campos = camera.position

func _physics_process(delta):
	cam_invert = Global.cam_invert
	cam_control() # Camera Movement
	
	if Input.is_action_just_pressed("cam_mode") and cam_mode:
		cam_mode = !cam_mode
		var temprot = camera.get_rotation()
		temprot.x =  deg_to_rad(-60)
		camera.set_rotation(temprot)
		camera.position.x = 16
		camera.position.z = -16
		campos = Vector3(16,campos.y,-16)
		max_zoom = 1
	elif Input.is_action_just_pressed("cam_mode") and not cam_mode:
		cam_mode = !cam_mode
		var temprot = camera.get_rotation()
		temprot.x = deg_to_rad(-75)
		camera.set_rotation(temprot)
		camera.position.x = 7
		camera.position.z = -7
		campos = Vector3(7,campos.y,-7)
		max_zoom = 1.2
		
	
	# Camera Follows Player
	var player_pos = $"..".global_transform.origin
	global_transform.origin = player_pos

func cam_control(): # Camera Movement
	rotspd = Global.camrotspd
	var camdir = int(Input.is_action_pressed("cam_right") or Input.is_action_pressed("cam_right_alt")) -  int(Input.is_action_pressed("cam_left") or Input.is_action_pressed("cam_left_alt"))
	cameraAngle -= camdir*rotspd
	var newrot = get_rotation()
	if Input.is_action_pressed("cam_reset") or Input.is_action_pressed("cam_reset_alt"):
		cameraAngle = 180
	newrot.y = deg_to_rad(cameraAngle)
	set_rotation(newrot)
	
	if $"..".single_stick and (Input.is_action_just_pressed("cam_lock") or Input.is_action_just_pressed("cam_lock_alt")):
		cam_lock = !cam_lock
		
	if cam_lock:
		var ang_lock = $"../ModelRig".get_rotation()
		ang_lock.z = 0
		ang_lock.x = 0
		ang_lock.y+=deg_to_rad(45)
		cameraAngle = rad_to_deg(ang_lock.y)
		set_rotation(ang_lock)
	
	var zoomdir = int(Input.is_action_pressed("cam_in")or Input.is_action_pressed("cam_in_alt")) -  int(Input.is_action_pressed("cam_out") or Input.is_action_pressed("cam_out_alt"))
	camZoom = clamp(camZoom-(0.01 * sign(zoomdir)), 0.5, max_zoom) 
	camera.position = campos * camZoom

func _input(event): # Camera Movement With Mouse
	if event.is_action_pressed("cam_drag") or event.is_action_pressed("cam_drag_alt"):
		_camPrevpos = get_viewport().get_mouse_position()
		_dragging = true
	elif event.is_action_released("cam_drag") or event.is_action_released("cam_drag_alt"):
		_dragging = false
		
	if event is InputEventMouseButton:
#		print(event.button_index)
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camZoom = clamp(camZoom-0.05, 0.5, max_zoom) 
		
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camZoom = clamp(camZoom+0.05, 0.5, max_zoom) 
		
	elif event is InputEventMouseMotion and _dragging:
		var rot = (_camPrevpos - event.position)
		var signcam = -1
#		print("Prev: " + str(_camPrevpos.x) + " Curr: " + str(event.position.x))
		if cam_invert:
			signcam = 1
		cameraAngle -= lerp(0.0, rot.x *.3, .5) * signcam
		_camPrevpos = event.position
