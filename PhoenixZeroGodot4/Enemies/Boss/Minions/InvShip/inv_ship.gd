extends CharacterBody3D

@export var HealthComponent : HealthComponent
@export var StatHandler : StatHandler
@export var model : Node3D

var hitModel : Node3D
var hitTimer = 0.0
var inv_timer
var target_pos
signal on_death(ship:Node3D)

@onready var LockMark = $LockMark

@onready var main = get_tree().current_scene


func _physics_process(delta):
	if transform.origin != target_pos:
		transform.origin=lerp(transform.origin,target_pos,0.05)
		
	if HealthComponent.Invulnerable == true and inv_timer:
		inv_timer-=delta
		if inv_timer<=0:
			model.toggle_shield(false)
			HealthComponent.Invulnerable = false
		

func _ready():
	StatHandler.init()
	HealthComponent.init()
	create_hit_clone()
	

func _process(delta):
	if HealthComponent.Invulnerable == true:
		var testmesh = findmeshes(model)
#		model.material_overlay = load("res://Enemies/EnemyInvMaterial.tres")
		for i in testmesh:
				i.material_overlay = load("res://Enemies/EnemyInvMaterial.tres")
	else:
		var testmesh = findmeshes(model)
#		model.material_overlay = null
		for i in testmesh:
				i.material_overlay = null
	hitTimer -= delta
	if hitTimer <= 0:
		hitModel.visible = false
	

func create_hit_clone():
	hitModel = model.duplicate(8)
	hitModel.visible = false
	hitModel.scale *= 1.01
	hitModel.toggle_shield(false)
	var testmesh = findmeshes(hitModel)
#	hitModel.material_override = load("res://Enemies/EnemyHitMaterial.tres")
	for i in testmesh:
			i.material_override = load("res://Enemies/EnemyHitMaterial.tres")
			i.material_overlay = null
	add_child(hitModel)

func findmeshes(model):
	var array = []
	for n in model.get_children():
		if n is MeshInstance3D or n is CSGShape3D and not n.is_in_group("No_Mesh"):
			array.append(n)
		if n.get_child_count() > 0 and not n.is_in_group("No_Mesh"):
			array += findmeshes(n)
	return array


func _on_health_component_on_hit(Hit):
	hitModel.visible = true
	var testmesh = findmeshes(hitModel)
	hitTimer = 0.05


func _on_health_component_on_death():
	var Expl = Global.md_expl.instantiate()
	main.add_child(Expl)
	Expl.global_transform.origin = global_transform.origin
	emit_signal("on_death", self)
	
func start_inv_timer(time):
	inv_timer = time
