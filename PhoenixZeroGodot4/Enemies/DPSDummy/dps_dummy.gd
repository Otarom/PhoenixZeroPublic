extends CharacterBody3D


@export var HealthComponent : HealthComponent
@export var StatHandler : StatHandler
@export var model : Node3D

@onready var LockMark = $LockMark

var timer = 1
var time = timer
var total = 0
var timed = 0.0
var DPS = 0
var damaged = false
var hitModel : Node3D
var hitTimer = 0.0
var resettimer = 5.0

func _ready():
	StatHandler.init()
	HealthComponent.init()
	create_hit_clone()
	

func _process(delta):
	resettimer-=delta
	if damaged:
		time -= delta
		timed += delta
		$Sprite3D/SubViewport/Time.text = str(roundi(timed)) + " sec"
		$Sprite3D/SubViewport/TotalDmg.text = str(total)
		if time <= 0:
			# Displays the average DPS
#			print(DPS/timer)
			$Sprite3D/SubViewport/DPS.text = str(roundi(total/timed))
			
			time = timer
	else:
		timed = 0
		total = 0
	if resettimer <= 0:
		damaged = false
	hitTimer -= delta
	if hitTimer <= 0:
		hitModel.visible = false
	
	
	

func _on_health_component_on_damage_received(damage):
	damaged = true
	resettimer = 5
	total += damage
	DPS += damage
	pass # Replace with function body.

func create_hit_clone():
	hitModel = model.duplicate(8)
	hitModel.visible = false
	hitModel.scale *= 1.01
	var testmesh = findmeshes(hitModel)
	for i in testmesh:
			i.material_override = load("res://Enemies/EnemyHitMaterial.tres")
			i.material_overlay = null
	add_child(hitModel)

func _on_health_component_on_death():
	HealthComponent.health = StatHandler.max_health
	pass # Replace with function body.

func findmeshes(model):
	var array = []
	for n in model.get_children():
		if n is MeshInstance3D:
			array.append(n)
		if n.get_child_count() > 0:
			array += findmeshes(n)
	return array


func _on_health_component_on_hit(Hit):
	hitModel.visible = true
	var testmesh = findmeshes(hitModel)
	var count = 0
	for i in testmesh:
#			i.material_overlay = meshes[count].material_overlay
			count+=1
	hitTimer = 0.05
