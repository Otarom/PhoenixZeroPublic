extends Node3D
class_name Weapon

@export var shots = 1
@export var max_ammo = 100
@export var damage = 10 
@export_range(0, 100) var armour_penetration : int = 0
@export var piercing = true
@export var bullet_speed = 8
@export var range = 15
@export var reload_speed = 10.0
@export var cooldown = 1.0
@export var Sound : AudioStreamPlayer
@export var Bullet : PackedScene
@export var Muzzle_Flash : PackedScene
@export var Spawner : Node3D


var cooltime = 0.0
var WeaponHolder

@onready var main = get_tree().current_scene

func _process(delta):
	cooltime -= delta

func shoot():
	if cooltime <= 0:
		WeaponHolder.ammo -=1
		cooltime = cooldown
		if Sound:
			Sound.play()
		Spawner.shoot()
