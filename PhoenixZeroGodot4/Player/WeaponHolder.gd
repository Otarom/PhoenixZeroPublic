extends Node3D

@export var Weapon : Weapon
@export var StatHandler : StatHandler
@export var Player : Player
@export var aimRig : Marker3D
@export var lockMark : Node3D
@onready var Sound = $"../Sound"
var ammo = 0
var shdelay = 0
var reloading = false
var reloadtime = 0
signal on_refresh_weapon
signal on_shoot
signal on_reload
signal on_release
signal on_shoot_no_ammo

func _ready():
	refresh()

func refresh():
	if Weapon:
		var dmg = Weapon.damage * clamp(StatHandler.damage_buff, 1, 10)
		StatHandler.damage = dmg - (dmg*StatHandler.damage_debuff/100)
		ammo = Weapon.max_ammo
		Weapon.WeaponHolder = self
		reloading = false
		reloadtime = 0
		shdelay = 0
		emit_signal("on_refresh_weapon")
	else:
		StatHandler.damage = 0
		ammo = 0

func refresh_damage():
	if Weapon:
		var dmg = Weapon.damage * clamp(StatHandler.damage_buff, 1, 10)
		StatHandler.damage = dmg - (dmg*StatHandler.damage_debuff/100)
	else:
		StatHandler.damage = 0

func reload():
	reloading = false
	ammo = Weapon.max_ammo
	shdelay = 0.3
	Sound.Reload.play()
	emit_signal("on_reload")

func _physics_process(delta):
	if Weapon and not Player.dead:
		reloadtime-=delta
		shdelay-=delta
		
		
		if (Input.is_action_pressed("player_shoot") or Input.is_action_pressed("player_shoot_alt")) && not reloading && not Player.mov.dodging and shdelay<=0 and not Global.escmenu:
			reloadtime = Weapon.reload_speed # Enables reload if player is not shooting
			emit_signal("on_shoot")
			Weapon.shoot()
			
		if (Input.is_action_pressed("player_shoot") or Input.is_action_pressed("player_shoot_alt")) && reloading && not Sound.NoAmmo.playing:
			emit_signal("on_shoot_no_ammo")
			Sound.NoAmmo.play()
		
		if (Input.is_action_just_released("player_shoot") or Input.is_action_just_released("player_shoot_alt")):
			emit_signal("on_release")
		
		if reloadtime <= 0 and ammo < Weapon.max_ammo: # Reload
			reload()
			
			
		
		if ammo <=0 && not reloading: # Reload start
			reloading = true
			reloadtime = Weapon.reload_speed
			Sound.NoAmmo.play()
#			Sound.Recharge.play()
	
	# This is a crude code that fits the Proof of Concept
	# Needs revamp since this will be defined by each Plane Model or Weapon
	if Player.single_stick:
		#	Aim rotation with movement/model
		if Player.direction:
			var angle = atan2(Player.direction.x, Player.direction.z)
			var rot = aimRig.get_rotation()
			rot.y = angle
			aimRig.set_rotation(rot)
			if Weapon:
				rot = Weapon.get_rotation()
				rot.y = angle
				Weapon.set_rotation(rot)
	elif Player.lock_mode:
		var rot = aimRig.get_rotation()
		rot.y = $"../ModelRig".get_rotation().y
		aimRig.set_rotation(rot)
		if Weapon:
			rot = Weapon.get_rotation()
			rot.y = $"../ModelRig".get_rotation().y
			Weapon.set_rotation(rot)
	else:
		#	Aim rotation with mouse
		var pos = Player.get_mouse_pos()
		if not pos == null:
			aimRig.look_at(Vector3(pos.x, 0, pos.z), Vector3.UP)
			aimRig.rotate_object_local(Vector3.UP, PI)
			if Weapon:
				Weapon.look_at(Vector3(pos.x, 0, pos.z), Vector3.UP)
				Weapon.rotate_object_local(Vector3.UP, PI)

		

