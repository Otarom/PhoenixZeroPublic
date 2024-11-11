extends CharacterBody3D
class_name Hit

var MainNode : Node3D
var direction = Vector3()
var damage = 0
var piercing = false
var ap = 0
var range = 0
var speed = 0
var origin
var explosion = false

var despawnTimer = 60

func dist(from, to):
	var xdif = (to.x - from.x)
	var ydif = (to.y - from.y)
	var zdif = (to.z - from.z)
	var distance = sqrt( xdif*xdif + ydif*ydif + zdif*zdif )
	return distance

func main(delta):
	pass
	
func _physics_process(delta):
	main(delta)
	despawnTimer-=delta
	if despawnTimer <= 0:
		queue_free()

