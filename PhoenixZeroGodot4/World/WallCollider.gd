extends CollisionShape3D
class_name WallCollider

@onready var Wall = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	shape = shape.duplicate()
	shape.size = Wall.size

