extends Node
@export var Player : Player

@onready var Motor = $Movement
@onready var Reload = $Reload
@onready var NoAmmo = $NoAmmo
@onready var LowHealth = $LowHealth
#@onready var WeaponShoot = $Weapon
#@onready var WeaponShoot = $WeaponTest
@onready var Recharge = $Recharge
@onready var Death = $Death

var Mpitch = 0.8
var Wpitch = 0.8

# Called when the node enters the scene tree for the first time.
func _ready():
	Motor.play()
	pass # Replace with function body.


func _physics_process(delta):
	Motor.pitch_scale = move_toward(Motor.pitch_scale,Mpitch,0.01)
#	WeaponShoot.pitch_scale = move_toward(WeaponShoot.pitch_scale,Wpitch,0.01)

func motor_speed(value):
	if value == 0:
		Mpitch = 0.8
	elif value == 1:
		Mpitch = 1
	elif value == 2:
		Mpitch= 1.2
	else:
		Mpitch = 0.8
