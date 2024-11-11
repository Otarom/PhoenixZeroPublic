extends CharacterBody3D

@export var StatHandler : StatHandler
@export var BuffHandler : BuffHandler
@export var HealthComponent : HealthComponent
@export var StateMachine : StateMachine

@export_range(-360.0,360.0) var y_rot = 0

@onready var LockMark = $LockMark

var Player : Player

var hitModel : Node3D
var meshes : Array = []
var defOverrideMeshes : Array = []
var hitTimer = 0

@onready var model_rot = $ModelRig.get_rotation()
var direction = Vector3(0,0,1)

@onready var main = get_tree().current_scene

func _ready():
	direction = direction.rotated(Vector3.UP,deg_to_rad(y_rot))
	direction = direction.normalized()
	meshes = findmeshes(StateMachine.model)
	create_hit_clone()
	StatHandler.init()
	StateMachine.start()
	HealthComponent.init()
	


func _physics_process(delta):
	
	if direction:
		velocity.x = direction.x * StatHandler.speed
		velocity.z = direction.z * StatHandler.speed
		
		model_rot = $ModelRig.get_rotation()
		var angle = atan2(direction.x, direction.z)
		if Player and not HealthComponent.Invulnerable:
			var p_dir = global_position.direction_to(Player.global_position)
			angle = atan2(p_dir.x, p_dir.z)
		model_rot.y = angle
		$ModelRig.set_rotation(model_rot)
		$Weapon1.set_rotation(model_rot)
	else:
		velocity.x = move_toward(velocity.x, 0, StatHandler.speed)
		velocity.z = move_toward(velocity.z, 0, StatHandler.speed)

	move_and_slide()
	
	hitTimer-=delta
	if hitTimer <= 0:
		hitModel.visible = false
#		



func _on_health_component_on_hit(Hit):
	hitModel.visible = true
	Player = Hit.MainNode
	var testmesh = findmeshes(hitModel)
	hitTimer = 0.05

func create_hit_clone():
	hitModel = StateMachine.model.duplicate(8)
	hitModel.visible = false
	hitModel.scale *= 1.02
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
	var rng = RandomNumberGenerator.new()
	if rng.randf() <= 0.15:
		var pack = load("res://Pickups/energy_pickup.tscn")
		var Pack = pack.instantiate()
		main.add_child(Pack)
		Pack.global_transform.origin = global_transform.origin
		Pack.direction = direction
	
	var Expl = Global.sm_expl.instantiate()
	main.add_child(Expl)
	Expl.global_transform.origin = global_transform.origin
	
	queue_free()


func _on_area_3d_body_entered(body):
	if body is Player:
		Player=body
