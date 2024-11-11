extends AudioStreamPlayer

var active = false
@export var WeaponNode : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if active:
		var reloading = WeaponNode.get_parent().reloading
		if Input.is_action_just_released("player_shoot") or reloading:
			active = false
			stop()
	pass

func start():
	if not active:
		play()
		active = true
	
	
