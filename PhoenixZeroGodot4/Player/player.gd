extends CharacterBody3D
class_name Player

@export var single_stick = false
@export var lock_mode = false
@export_enum("Machinegun",  "Sword", "Saw", "Sniper", "Laser", "Cluster") var weapon_type: int
@export_enum("Damage Buff", "Heal", "Shield") var skill_type: int
@export var StatHandler : StatHandler
@export var BuffHandler : BuffHandler
@export var HealthComponent : HealthComponent
@export var control : Node

@onready var mov = $Movement
var acc = 0.1
var spr_value = 1
var vel_x = 0
var vel_z = 0
var direction = Vector3()
var last_dir = Vector3(0,0,0)
var dead = false
var dirspd = 1

func _ready():
	weapon_type = Global.playerWeapon
	if Global.playerMovtype == 0:
		$"BaseStats".armour = 10
		single_stick = false
		lock_mode = false
	elif Global.playerMovtype == 1:
		$"BaseStats".armour = 40
		$"ModelRig/quad2fix2".visible = false
		$"ModelRig/TrustyOldOne".visible = true
		single_stick = true
		lock_mode = false
	elif Global.playerMovtype == 2:
		$"BaseStats".speed = 9
		single_stick = false
		lock_mode = true
	skill_type = Global.playerSkill
	StatHandler.init()
	HealthComponent.init()
	control.change_weapon(weapon_type)
	control.load_skill()
	Global.change_all_visibility_settings(100)

func _physics_process(delta):
	var SPEED = StatHandler.speed
	var SPRINT = StatHandler.sprint_mult
	if not dead:
		direction = mov.move(delta, single_stick, lock_mode)
	else:
		if not direction:
			direction = last_dir
		mov.sprint_tog = false
	
	if mov.sprint_tog:
		spr_value = move_toward(spr_value, SPRINT, 0.025)
		if spr_value == SPRINT:
			$ModelRig/Trail/Trail3D._enabled = true
			$ModelRig/Trail/Trail3D2._enabled = true
			$ModelRig/Trail/Trail3D3._enabled = true
#			$ModelRig/Trail/Trail3D2/Trail3D2._enabled = true
#			$ModelRig/Trail/Trail3D/Trail3D._enabled = true
			$ModelRig/quad2fix2/DefTrail/Trail3D3._enabled = false
			$ModelRig/TrustyOldOne/DefTrail/Trail3D._enabled = false
			$ModelRig/TrustyOldOne/DefTrail/Trail3D2._enabled = false
	else:
		spr_value = move_toward(spr_value, 1, 0.05)
		if spr_value == 1:
			$ModelRig/Trail/Trail3D._enabled = false
			$ModelRig/Trail/Trail3D2._enabled = false
			$ModelRig/Trail/Trail3D3._enabled = false
#			$ModelRig/Trail/Trail3D2/Trail3D2._enabled = false
#			$ModelRig/Trail/Trail3D/Trail3D._enabled = false
			$ModelRig/quad2fix2/DefTrail/Trail3D3._enabled = true
			$ModelRig/TrustyOldOne/DefTrail/Trail3D._enabled = true
			$ModelRig/TrustyOldOne/DefTrail/Trail3D2._enabled = true
	
	if direction:
		# Acceleration
		acc = move_toward(acc, 1, 0.025)
		
		# unsure if this is still needed
		vel_x = direction.x * SPEED * spr_value * acc
		vel_z = direction.z * SPEED * spr_value * acc
		
		velocity = velocity.move_toward(direction * SPEED * spr_value * acc, dirspd)
		dirspd = move_toward(dirspd, 0.9, 0.01)
		
		last_dir=direction
	else:
		acc = 0.1
		dirspd = 1
		# Changes the friction value based on the multiplier of the superspeed
		var fric = 0.15 * spr_value
		if mov.dodging:
			fric = 0.5 # Dodge Friction
		# Friction
		velocity = velocity.move_toward(Vector3(), fric)
	
	move_and_slide()


func get_mouse_pos():
	var rayOrigin = Vector3()
	var rayEnd = Vector3()
	var space_state = get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = $CameraRig/PlayerCamera
	var pos = null
	
	rayOrigin = camera.project_ray_origin(mouse_pos)
	rayEnd = rayOrigin + camera.project_ray_normal(mouse_pos)*2000
	
	var Parameters = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	var intersection = space_state.intersect_ray(Parameters)
	
	if not (intersection is Dictionary and intersection == {}):
		pos = intersection.position
		
	return pos
