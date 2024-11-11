extends Marker3D

@export var Minion : PackedScene
@export var Holder : Node3D
@onready var main = get_tree().current_scene




# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawn():
	for m in get_children():
		var minion = Minion.instantiate()
		Holder.add_child(minion)
		minion.transform = m.global_transform 
		minion.transform.origin.y = 0
		minion.global_transform.origin = m.global_transform.origin

func despawn():
	for m in Holder.get_children():
		m.queue_free()
		
		
