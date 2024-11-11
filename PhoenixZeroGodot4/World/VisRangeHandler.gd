extends Node3D

var def_vis_range : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var nodearray = self.find_children("","GeometryInstance3D")
	for node in nodearray:
		def_vis_range[node] = node.visibility_range_end
	
	Global.changed.connect(change_vis_range)
	
	change_vis_range()
	
	pass # Replace with function body.

func change_vis_range():
	var value = Global.view_distance
	for node in def_vis_range:
		node.visibility_range_end = def_vis_range[node] + value
