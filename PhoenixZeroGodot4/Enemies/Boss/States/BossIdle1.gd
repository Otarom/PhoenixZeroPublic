extends State

var timer = 12.5
#var timer = 2
var playerIn = false
@onready var music = $"../../Music"

func _ready():
	state_name = "Idle"

func enter():
	MainNode.HealthComponent.toggle_invulnerability(true)

func exit():
	pass

func update(delta):
	pass

	
func physics_update(delta):
	#This will handle the dialogue
	#Right now it's set on a timer
	if playerIn:
		music.volume_db = move_toward(music.volume_db,-10,1)
		if Input.is_action_just_pressed("debug_skip"):
			timer-=10
		timer -= delta
		if timer <= 0:
			emit_signal("changed", self, "InvState")
#			emit_signal("changed", self, "Laser")
#			emit_signal("changed", self, "InvLaser")
#			emit_signal("changed", self, "Nuke")
#			emit_signal("changed", self, "NukeSpawn") 


func _on_area_3d_body_entered(body):
	if body is Player:
		music.active = true
		playerIn = true
