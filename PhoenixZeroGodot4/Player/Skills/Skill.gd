extends Node3D
class_name Skill

@export var duration = 10
@export var cost = 30
@export var amount : float = 1 
@export var cooldown = 5
@export var size = 8
@export var skill_object : PackedScene
@export var Spawner : Node3D

@onready var main = get_tree().current_scene

func use():
	Spawner.use()
