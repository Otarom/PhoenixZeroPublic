extends Node
@onready var main = get_tree().current_scene
@onready var Player = $".."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("debug_godmode"):
		$"../Control".toggle_godmode()
		
	if Input.is_action_just_pressed("debug_restart"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("debug_die"):
		$"../HealthComponent".die()
	
	if Input.is_action_just_pressed("debug_spawn_enemy"):
		var pos = Player.get_mouse_pos()
		if not pos == null:
			var trailhunt = load("res://Enemies/Boss/Minions/Fighter/enemy_fighter_1.tscn")
			var minion = trailhunt.instantiate()
			main.add_child(minion)
			pos.y = 0
			minion.transform.origin = pos
	if Input.is_action_just_pressed("debug_spawn_enemy2"):
		var pos = Player.get_mouse_pos()
		if not pos == null:
			var trailhunt = load("res://Enemies/Boss/Minions/Trailhunters/enemy_traihunter_1.tscn")
			var minion = trailhunt.instantiate()
			main.add_child(minion)
			pos.y = 0
			minion.transform.origin = pos
#	if Input.is_action_just_pressed("debug_weapon"):
#		if Player.single_stick and Player.weapon_type == 1:
#			Player.weapon_type = 2
#		elif Player.single_stick and Player.weapon_type == 2:
#			Player.weapon_type = 1
#
#		if not Player.single_stick and Player.weapon_type == 0:
#			Player.weapon_type = 3
#		elif not Player.single_stick and Player.weapon_type == 3:
#			Player.weapon_type = 0
#
#		Player.control.change_weapon(Player.weapon_type)
#		$"../WeaponHolder".refresh()
#
#	if Input.is_action_just_pressed("debug_plane"):
#		Player.single_stick = !Player.single_stick
#		if Player.single_stick:
#			$"../BaseStats".armour = 40
#			var char_rot = $"../ModelRig".get_rotation()
#			char_rot.x = 0
#			$"../ModelRig".set_rotation(char_rot)
#			Player.weapon_type = 1
#			Player.control.change_weapon(Player.weapon_type)
#		else:
#			$"../BaseStats".armour = 0
#			var char_rot = $"../ModelRig".get_rotation()
#			char_rot.z = 0
#			$"../ModelRig".set_rotation(char_rot)
#			Player.weapon_type = 0
#			Player.control.change_weapon(Player.weapon_type)
#		$"../WeaponHolder".refresh()
#		$"../PlayerStats".refresh()
#		$"../ModelRig/quad2fix2".visible = !$"../ModelRig/quad2fix2".visible
#		$"../ModelRig/TrustyOldOne".visible = !$"../ModelRig/TrustyOldOne".visible
#		$"../ModelRig/PaperPlane".visible = !$"../ModelRig/PaperPlane".visible
