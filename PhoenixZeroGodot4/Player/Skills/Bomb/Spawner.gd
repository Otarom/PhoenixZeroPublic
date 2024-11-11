extends Node3D

@export var Skill : Skill
@onready var Mount_Count = get_child_count()
# This code need to be revamped later on Inventory Update
# to better fit gun needs and ease gun creation.

func use():
	for i in range(0, Mount_Count, 1):
		var mount = get_child(i)
		var area = Skill.skill_object.instantiate()
		area.timer = Skill.duration
		area.speed = Skill.size
		area.damage = Skill.amount
		area.MainNode = Skill.get_parent().Player
		var rot = mount.get_rotation() + Skill.get_rotation()
		rot.x = 0
		rot.z = 0
		area.set_rotation(rot)
		Skill.main.add_child(area)
		area.global_transform.origin = mount.global_transform.origin
