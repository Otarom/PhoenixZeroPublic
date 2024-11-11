extends CharacterBody3D

var direction = Vector3(0,0,1)
var speed = 3
var found
var p

func _ready():
	var heal = Heal.new()
	heal.amount = 600
	heal.collision = $Area3D
	heal.one_time = true
	heal.init()
	heal.freed.connect(_on_heal_freed)

func _physics_process(delta):
	if found:
		speed = 2
#		direction = global_position.direction_to(p.global_position)
	speed -= delta
	if speed > 0:
		velocity.z = direction.z * speed
		velocity.x = direction.x * speed
		move_and_slide()

func _on_heal_freed():
	queue_free()



func _on_magnet_body_entered(body):
	if body is Player:
		found = true
		p = body
		direction = global_position.direction_to(body.global_position)
	pass # Replace with function body.


func _on_magnet_body_exited(body):
	if body is Player:
		found = false
		p = null
	pass # Replace with function body.
