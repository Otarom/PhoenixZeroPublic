extends Node
class_name BuffHandler

@export var BuffMark : PackedScene

@onready var main = get_tree().current_scene

signal damage_buff_end
signal armour_buff_end
signal multi_shot_buff_end
signal invulnerability_buff_end

signal damage_buff_start(amount)
signal armour_buff_start(amount)
signal multi_shot_buff_start(amount)
signal invulnerability_buff_start

func create_buff(type, amount, color, duration, icon):
	var mark = BuffMark.instantiate()
	main.add_child(mark)
	mark.buff_type = type
	
	
	if type == 0:
		emit_signal("damage_buff_start", amount)
	elif type == 1:
		emit_signal("armour_buff_start", amount)
	elif type == 2:
		emit_signal("multi_shot_buff_start", amount)
	elif type == 3:
		emit_signal("invulnerability_buff_start")
	
	mark.end_buff.connect(end_buff)


func end_buff(buff_type):
	if buff_type == 0:
		emit_signal("damage_buff_end")
	elif buff_type == 1:
		emit_signal("armour_buff_end")
	elif buff_type == 2:
		emit_signal("multi_shot_buff_end")
	elif buff_type == 3:
		emit_signal("invulnerability_buff_end")
		
