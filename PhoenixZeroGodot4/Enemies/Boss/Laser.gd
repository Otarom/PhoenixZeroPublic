extends Marker3D

@export var Main : CharacterBody3D

@onready var DgArea = $DangerArea
@onready var beam = $Beam/Beam1

var active = false

var delay = 5
var count = 0
var timer = 5
var activetimer = 5
var hitdelay = 0.1

var rot_speed = 0.005

var players = []
var minions = []
var targets = []
var closest_player
var rot_dir

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shoot():
	delay = 3
	count = 0
	timer = 1
	activetimer = 8
	hitdelay = 0.1

	rot_speed = 0.005
	active = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if active:
		aim_player()
		laser(delta)
	
func aim_player():
	
	# Find closest player
	for t in Main.targets:
		if not closest_player:
			closest_player = t
		elif Main.global_position.distance_to(t.global_position) < Main.global_position.distance_to(closest_player.global_position):
			closest_player = t
	
	if rot_dir:
		# Rotate towards player
		var xform = transform # node transform
		xform = xform.looking_at(rot_dir,Vector3.UP)
		transform = transform.interpolate_with(xform,rot_speed)


func laser(delta):
	delay-=delta
	
#	if not beam.visible:
#		# Gets player rotation because and makes it negative because of wrong Z positioning
#		rot_dir = -closest_player.global_position
	rot_dir = -closest_player.global_position
	
	# Danger Area
	if delay <= 0 and count < DgArea.get_child_count():
		delay = 0.1
		rot_speed = 0.013
		DgArea.get_child(count).visible = true
		count+=1
	
	# Danger Area Timer
	if count == DgArea.get_child_count():
		timer-=delta
	
	# Lase + Damage
	if timer <= 0 and activetimer > 0:
		rot_speed = 0.008
		
		for i in DgArea.get_children():
			i.visible = false
		
		hitdelay-=delta
		
		beam.visible = true
		
		var hit = Hit.new()
		hit.damage = 800
		# Damages player every 0.1 seconds
		if hitdelay <= 0:
			for p in players:
				p.HealthComponent.damage(hit)
			for m in minions:
				m.HealthComponent.die()
#				print("found "+ str(m))
			hitdelay = 0.1
		activetimer -= delta
	
	# Stops the laser
	if activetimer <= 0:
		beam.visible = false
		active = false

func stop():
	active = false
	beam.visible = false
	for i in DgArea.get_children():
		i.visible = false

func _on_dmg_area_body_entered(body):
	if body is Player:
		players.append(body)
	
	if not body == self and body.is_in_group("Minions"):
		minions.append(body)


func _on_dmg_area_body_exited(body):
	if body is Player:
		players.erase(body)
	
	if not body == self and body.is_in_group("Minions"):
		minions.erase(body)
	


func _on_area_3d_body_entered(body):
	if body is Player:
		Main.targets.append(body)
