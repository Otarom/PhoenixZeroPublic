extends Control
class_name EnemyUI

@export var damage_number_2d_template : PackedScene = preload("res://Misc/UI/damage_indicator.tscn")
@export var MainNode : CharacterBody3D
@export var HealthComponent : HealthComponent
@export var font_size : int = 16

@onready var main = get_tree().current_scene

var dmgpos = Vector3(0,0,0)
var count = 0

var damage_number_2d_pool:Array[DamageNumber2D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	HealthComponent.on_hit.connect(_on_health_component_on_hit)
	HealthComponent.on_damage_received.connect(_on_health_component_on_damage)
	
	pass # Replace with function body.


func spawn_damage_number(value, pos, size_num):
	var damage_number = get_damage_number()
	if damage_number:
		var val = str(value)
		var size_dif = font_size/16
		var height = randf_range(100*size_dif,180*size_dif)
		var spread = 20
#		damage_number.visible = true
		main.get_child(0).add_child(damage_number, true)
		damage_number.set_size(size_num)
		damage_number.set_values_and_animate(val, pos, height, spread)

func get_damage_number() -> DamageNumber2D:
	# get a damage number from the pool
	if damage_number_2d_pool.size() > 0:
		return damage_number_2d_pool.pop_front()
	
	# create a new damage number if the pool is empty
	else:
		var new_damage_number = damage_number_2d_template.instantiate()
#		new_damage_number.visibility_changed.connect(
#			func():if(not new_damage_number.visible):damage_number_2d_pool.append(new_damage_number))
		new_damage_number.tree_exiting.connect(
			func():damage_number_2d_pool.append(new_damage_number))
#		new_damage_number.freed.connect(
#			func():damage_number_2d_pool.erase(new_damage_number); count-=1)
#		main.get_child(0).add_child(new_damage_number, true)

		return new_damage_number

func _on_health_component_on_hit(Hit):
#	var dmgpos = MainNode.get_viewport().get_camera_3d().unproject_position(Hit.global_position)
	dmgpos = Hit.global_position
	if HealthComponent.Invulnerable:
		spawn_damage_number("Shielded", dmgpos,font_size)
		
func _on_health_component_on_damage(damage):
	spawn_damage_number(damage, dmgpos, font_size)

	
