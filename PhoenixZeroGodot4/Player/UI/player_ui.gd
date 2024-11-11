extends Control
class_name PlayerUI

@export var Player : Player
@export var HealthComponent : HealthComponent
@export var StatHandler : StatHandler
@export var SkillHolder : Node3D
@export var WeaponHolder : Node3D
var health
var max_health
var steam
var max_steam
var ammo
var max_ammo
var experience
var level

var hit = false
var skill = false
var shot = false

@onready var DmgScreen = $DmgScreen


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health = HealthComponent.health
	max_health = StatHandler.max_health
	DmgScreen.modulate.a = 1 - (health/(max_health/2))
	steam = SkillHolder.steam
	max_steam = StatHandler.max_energy
	ammo = WeaponHolder.ammo


func _on_health_component_on_damage_received(damage):
	hit = true


func _on_skill_holder_on_skill_used():
	skill=true


func _on_weapon_holder_on_refresh_weapon():
	max_ammo = WeaponHolder.Weapon.max_ammo


func _on_weapon_holder_on_shoot():
	shot = true
