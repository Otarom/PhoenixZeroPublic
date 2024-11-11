extends State

var timer
var closest_player


@onready var main = get_tree().current_scene

func _ready():
	state_name = "Nuke"

func enter():
	timer = 20
	
	$"../../Weapons1".shoot()
	
	var nuke = load("res://Enemies/Boss/Minions/Nuke/enemy_nuke.tscn")
	var ang = 0
	for n in range(0,4):
		var minion = nuke.instantiate()
		minion.y_rot = ang + (90*n)
		main.add_child(minion)
		minion.transform.origin = MainNode.transform.origin

func exit():
	$"../../Laser".set_rotation($"../../ModelRig".get_rotation())
	MainNode.HealthComponent.toggle_invulnerability(true)
	pass

func update(delta):
	pass
	
func physics_update(delta):
#	get_closest()
#
#	# Rotate towards player
#	var xform = $"../../ModelRig".transform # node transform
#	var rot_dir = -closest_player.global_position
#	xform = xform.looking_at(rot_dir,Vector3.UP)
#	$"../../ModelRig".transform = $"../../ModelRig".transform.interpolate_with(xform,0.01)
	
	timer-=delta
	if timer <= 0:
		emit_signal("changed", self, "InvLaser")
	
func get_closest():
	for t in MainNode.targets:
		if not closest_player:
			closest_player = t
		elif MainNode.global_position.distance_to(t.global_position) < MainNode.global_position.distance_to(closest_player.global_position):
			closest_player = t
