extends Node2D
class_name DamageNumber2D

@onready var label:Label = $Container/Label
@onready var label_container:Node2D = $Container
@onready var ap:AnimationPlayer = $AnimationPlayer

@onready var main = get_tree().current_scene

var pos
var gspread
var gheight


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta):
	if pos:
		var start_pos = main.get_viewport().get_camera_3d().unproject_position(pos)
		var tween = get_tree().create_tween()
		var end_pos = Vector2(randf_range(-gspread,gspread),-gheight) + start_pos
		var tween_length = ap.get_animation("Spawn").length
		tween.tween_property(label_container,"position",end_pos,tween_length).from(start_pos)
	
func set_values_and_animate(value:String, start_pos, height:float, spread:float) -> void:
	label.text = value
	ap.play("Spawn")
	gspread = spread
	gheight = height
	pos = start_pos
	

func set_size(size_num):
	label.label_settings.font_size = size_num

func remove() -> void:
	ap.stop()
	if is_inside_tree():
		get_parent().remove_child(self)
