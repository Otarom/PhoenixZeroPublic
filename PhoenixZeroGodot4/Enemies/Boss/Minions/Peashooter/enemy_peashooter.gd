extends CharacterBody3D

@export var StatHandler : StatHandler
@export var HealthComponent : HealthComponent
@export var StateMachine : StateMachine
var hitModel : Node3D
var meshes : Array = []
var defOverrideMeshes : Array = []
var hitTimer = 0

@onready var main = get_tree().current_scene

func _ready():
	meshes = findmeshes(StateMachine.model)
	create_hit_clone()
	StatHandler.init()
	StateMachine.start()
	
	HealthComponent.init()
	

func _physics_process(delta):
	hitTimer-=delta
	if hitTimer <= 0:
		hitModel.visible = false

func _on_health_component_on_hit(Hit):
	hitModel.visible = true
	var testmesh = findmeshes(hitModel)
	hitTimer = 0.05

func create_hit_clone():
	hitModel = StateMachine.model.duplicate(8)
	hitModel.visible = false
	hitModel.scale *= 1.01
	var testmesh = findmeshes(hitModel)
	for i in testmesh:
			i.material_override = load("res://Enemies/EnemyHitMaterial.tres")
			i.material_overlay = null
	$ModelRig.add_child(hitModel)

func _on_health_component_on_invulnerability_change(value):
	if value:
		for i in meshes:
			i.material_overlay = load("res://Enemies/EnemyInvMaterial.tres")
	else: 
		for i in meshes:
			i.material_overlay = null

func findmeshes(model):
	var array = []
	for n in model.get_children():
		if n is MeshInstance3D or n is CSGMesh3D:
			array.append(n)
		if n.get_child_count() > 0:
			array += findmeshes(n)
	return array


func _on_health_component_on_death():
	var Expl = Global.sm_expl.instantiate()
	main.add_child(Expl)
	Expl.global_transform.origin = global_transform.origin
	queue_free()
