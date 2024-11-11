extends Node3D
class_name BuffMark

var color
var BuffHandler : BuffHandler
var buff_type
var duration
var icon

signal end_buff(buff_type)

func _ready():
	$MarkSprite.modulate = color
	$MarkSprite/MarkSprite.modulate = color
	$MarkSprite.play()
	$MarkSprite/MarkSprite.play()
	$Icon.texture = icon
	if buff_type == 3:
		BuffHandler.invulnerability_buff_end.connect(buff_end)

func _process(delta):
	duration -= delta
	if duration <= 0:
		emit_signal("end_buff", buff_type)
		buff_end()

func buff_end():
	queue_free()
	
