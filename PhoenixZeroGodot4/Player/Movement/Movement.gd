extends Node

# Script that holds all the movement of the player

@export var StatHandler : StatHandler
@onready var Player = $".."
@onready var Sound = $"../Sound"

var move_direction = Vector3(1,0,1)
var vel
var sprint_tog = false

@onready var camera_rig = $"../CameraRig"
@onready var model = $"../ModelRig"

var target : Node3D
var locked = false
var exited = false
var lock_pos

var backturn = false
var dodging = false
var old_direction

func move(delta, mov_type, lock_mode):
	
	# Dodge (needs to be replaced later since extra action will vary between Plane Models)
	if (Input.is_action_just_pressed("player_dodge") or Input.is_action_just_pressed("player_dodge_alt")) && not dodging:
		dodging = true
		Player.HealthComponent.toggle_invulnerability(true)
		var vel_x = Player.last_dir.x * -20
		var vel_z = Player.last_dir.z * -20
		Player.velocity = Vector3(vel_x, 0, vel_z)
	
	if Player.velocity == Vector3(0,0,0) && dodging:
		dodging = false
		Player.HealthComponent.toggle_invulnerability(false)
	
	
	
	
	if not dodging:
		sprint_tog = false
	
		if (Input.is_action_pressed("player_sprint") or Input.is_action_pressed("player_sprint_alt")):
			sprint_tog = true
		if mov_type:
			if (Input.is_action_pressed("player_up") or Input.is_action_pressed("player_up_alt")):
				sprint_tog = true
			return single_stick(delta)
		else:
			if lock_mode:
				sprint_tog = true
				return lock_mode(delta)
			else:
				return double_stick(delta)
		

func double_stick(delta):
	
	# Checks directions
	var input_dir = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	input_dir += Input.get_vector("player_left_alt", "player_right_alt", "player_up_alt", "player_down_alt")
#	input_dir += Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") #test
	input_dir.clamp( Vector2(-1,-1), Vector2(1,1))
	# Resets the vector
	var move_direction = Vector3()

	var angC = camera_rig.get_rotation()
	# Gets the rotation of the camera and adds 315 (Angle that the camera starts in)
	angC = deg_to_rad(315) + angC.y

	# Defines the second angle 180 degrees from the other to calculate the variation
	var tempA = angC - PI

	var SangC = sin(angC)
	var StempA = sin(tempA)
	# Calculates the error margin
	var error_sin = StempA - SangC

	var CangC = cos(angC)
	var CtempA = cos(tempA)
	# Calculates the error margin
	var error_cos = CtempA - CangC
	
	# Removes the variation of the sin calculation to get the correct results
	var vvalueX = -SangC + error_sin # 0->0, 45->-0.5, 90->-1, 135->-0,5 180->0, 225->+0,5 270->1, 315->+0.5
	var hvalueZ = SangC - error_sin
	
	# Removes the variation of the cos calculation to get the correct results
	var vvalueZ = -CangC + error_cos # 0->-1, 45->-0.5, 90->0, 135->+0,5 180->+1, 225->+0,5 270->0, 315->-0.5
	var hvalueX = -CangC + error_cos
	
	move_direction += Vector3(vvalueX, 0, vvalueZ) * input_dir.y
	move_direction += Vector3(hvalueX, 0, hvalueZ) * input_dir.x

	# Normalizes the vector
	if not move_direction == Vector3():
		move_direction = move_direction.normalized()

	# Moving Sound
	if bool(abs(input_dir.y)) or bool(abs(input_dir.x)):
		Sound.motor_speed(1)
	else:
		Sound.motor_speed(0)
	if sprint_tog and (bool(abs(input_dir.y)) or bool(abs(input_dir.x))):
		Sound.motor_speed(2)
	
		
	#	Rotates the model if character is moving
	if bool(abs(input_dir.y)) or bool(abs(input_dir.x)):	
		var angle = atan2(move_direction.x, move_direction.z)
		var char_rot = model.get_rotation()
		var spr = 1
		if sprint_tog:
			spr=1.5
		
		char_rot.x = lerp(char_rot.x, .4*spr, 0.05) # Turning animation
		
		char_rot.y = lerp_angle(char_rot.y, angle, 0.1*Player.acc)
		model.set_rotation(char_rot)
	else:
		var char_rot = model.get_rotation()
		char_rot.x = lerp(char_rot.x, 0.0, 0.05) # Turning animation
		model.set_rotation(char_rot)
	
	
	return move_direction


func single_stick(delta):
	var turn = 0.040
	var char_rot = model.get_rotation()
	var tilt = 0.6
	
#	Checks if player is changing directions
	var dir = int(Input.is_action_pressed("player_right") or Input.is_action_pressed("player_right_alt")) -  int(Input.is_action_pressed("player_left") or Input.is_action_pressed("player_left_alt"))
	
	if sprint_tog:
		turn*=1.5
	
#	Changes directions
	if !backturn:
		move_direction = move_direction.rotated(Vector3(0, -1, 0), turn * dir)
		char_rot.z = lerp(char_rot.z, tilt*dir, 0.05) # Turning animation
	
#	Emergency turn
	if (Input.is_action_pressed("player_down") or Input.is_action_pressed("player_down_alt")) and !backturn:
		backturn = true
		old_direction = move_direction.normalized()
		move_direction.z += turn * sign(move_direction.x)
		move_direction.x -= turn * sign(move_direction.z)
	
	if backturn:
		move_direction = lerp(move_direction, -old_direction, 0.2)
		if move_direction.distance_to(-old_direction) < 0.1:
			backturn = false
	
	# Sound
	Sound.motor_speed(1)
	if sprint_tog:
		Sound.motor_speed(2)
	
#	Normalizes the vector
	move_direction = move_direction.normalized()
	
#	Sets rotation
	var angle = atan2(move_direction.x, move_direction.z)
	char_rot.y = angle
	model.set_rotation(char_rot)
	
	return move_direction


func lock_mode(delta):
	
	var lock = $"../AimRig/Lock"
	if not locked:
		lock.visible = true
	
	# Checks directions
	camera_rig.cam_lock = true
	var input_dir = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	input_dir += Input.get_vector("player_left_alt", "player_right_alt", "player_up_alt", "player_down_alt")
#	input_dir += Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") #test
	input_dir.clamp( Vector2(-1,-1), Vector2(1,1))
	# Resets the vector
	var move_direction = Vector3()
		
	
	var angC = camera_rig.get_rotation()
	# Gets the rotation of the camera and adds 315 (Angle that the camera starts in)
	angC = deg_to_rad(315) + angC.y

	# Defines the second angle 180 degrees from the other to calculate the variation
	var tempA = angC - PI

	var SangC = sin(angC)
	var StempA = sin(tempA)
	# Calculates the error margin
	var error_sin = StempA - SangC

	var CangC = cos(angC)
	var CtempA = cos(tempA)
	# Calculates the error margin
	var error_cos = CtempA - CangC
	
	# Removes the variation of the sin calculation to get the correct results
	var vvalueX = -SangC + error_sin # 0->0, 45->-0.5, 90->-1, 135->-0,5 180->0, 225->+0,5 270->1, 315->+0.5
	var hvalueZ = SangC - error_sin
	
	# Removes the variation of the cos calculation to get the correct results
	var vvalueZ = -CangC + error_cos # 0->-1, 45->-0.5, 90->0, 135->+0,5 180->+1, 225->+0,5 270->0, 315->-0.5
	var hvalueX = -CangC + error_cos
	
	move_direction += Vector3(vvalueX, 0, vvalueZ) * input_dir.y
	move_direction += Vector3(hvalueX, 0, hvalueZ) * input_dir.x
	
	
	
	if (Input.is_action_just_pressed("cam_lock") or Input.is_action_just_pressed("cam_lock_alt")):
		locked = !locked
		if target:
			lock_pos = target.global_position
			target.LockMark.visible = true
			if not locked:
				target.LockMark.visible = false
				if exited:
					target = null
					exited = false
		else:
			lock_pos = lock.global_position
		
		lock.visible = !lock.visible
	
	
	if locked:
		
		if target:
			if is_instance_valid(target):
				lock_pos = target.global_position
			else:
				locked=false
				target=null
		
		
		$"../LockMark".visible = true
		$"../LockMark".global_position = lock_pos
		var dir = Player.global_position.direction_to(lock_pos)
		
		
		var char_rot = model.get_rotation()
		char_rot.y = atan2(dir.x, dir.z)
		model.set_rotation(char_rot)
		
	else:
		
		if target and is_instance_valid(target):
			$"../AimRig/Lock/Sprite".pixel_size = target.LockMark.pixel_size * 2
			$"../AimRig/Lock/Sprite".global_position = target.global_position
		else:
			$"../AimRig/Lock/Sprite".pixel_size = 0.005
			$"../AimRig/Lock/Sprite".global_position = $"../AimRig/Lock".global_position
		
		$"../LockMark".global_position = lock.global_position
		
		$"../LockMark".visible = false
		var turn = -(int(Input.is_action_pressed("cam_right") or Input.is_action_pressed("cam_right_alt")) -  int(Input.is_action_pressed("cam_left") or Input.is_action_pressed("cam_left_alt")))
		
		if bool(abs(turn)):
			var char_rot = model.get_rotation()
			char_rot.y += deg_to_rad(turn * Global.camrotspd)
			model.set_rotation(char_rot)
		
	
	# Normalizes the vector
	if not move_direction == Vector3():
		move_direction = move_direction.normalized()

	# Moving Sound
	if bool(abs(input_dir.y)) or bool(abs(input_dir.x)):
		Sound.motor_speed(2)
	else:
		Sound.motor_speed(0)
	if sprint_tog and (bool(abs(input_dir.y)) or bool(abs(input_dir.x))):
		Sound.motor_speed(1)
	
	if (Input.is_action_pressed("player_sprint") or Input.is_action_pressed("player_sprint_alt")):
		sprint_tog = false
	
	return move_direction


func _on_lock_body_entered(body):
	if body.is_in_group("Lockable") and not locked:
		target = body
	if body == target and locked:
		exited = false
	pass # Replace with function body.


func _on_lock_body_exited(body):
	if body == target and not locked:
		target = null
	if body == target and locked:
		exited = true
	pass # Replace with function body.
