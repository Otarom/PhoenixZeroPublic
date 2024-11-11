extends Node

var version = 4

var clouds = false
var cloud_level = 0 # Level of Detail 0 is max 3 is min
var bgquality = 2 # Background Detal Level 0 to 2
var wallquality = 1
var fullscreen = false
var screen_mode = 2
var resolution = 0
var vsync = true
var cam_invert = false
var camrotspd = 2.0
var view_distance = 0

var escmenu = false

var user_settings : UserSettings

var playerWeapon : int = 0
var playerMovtype: int = 0
var playerSkill : int = 2

var sm_expl = preload("res://Misc/VFX/3D_Explosion/small_explosion.tscn")
var md_expl = preload("res://Misc/VFX/3D_Explosion/medium_explosion.tscn")

@onready var options = $Options

signal changed
signal loaded_setings

# Called when the node enters the scene tree for the first time.
func _ready():
#	emit_signal("changed")
	load_settings()
	pass

func init():
	var main = get_tree().current_scene
	var Expl = sm_expl.instantiate()
	Expl.testing = true
	main.add_child.call_deferred(Expl)
	Expl = md_expl.instantiate()
	Expl.testing = true
	main.add_child.call_deferred(Expl)

func change_all_visibility_settings(distance : int):
	var geom_inst = get_tree().current_scene.find_children("","GeometryInstance3D")
	for node in geom_inst:
		if node.visibility_range_end != 0:
#			def_vis_range[node.nam]
#			node.visibility_range_end = 
			pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): # Debug
	if Input.is_action_just_pressed("ui_cancel"):
		if not get_tree().current_scene.name == "Menu":
#			get_tree().change_scene_to_file("res://Misc/UI/Menu/menu.tscn")
			escmenu = !escmenu
			$EscMenu.visible = !$EscMenu.visible
			if not $"EscMenu".visible:
				$Options.visible = false
	pass

func load_settings():
	if ResourceLoader.exists("user://user_settings_demo.tres"):
		var tester = load("user://user_settings_demo.tres")
		if not tester.version or tester.version != version:
			DirAccess.remove_absolute("user://user_settings_demo.tres")
			Global.user_settings = UserSettings.new()
			Global.user_settings.version = version
#			print(tester.version)
#			print(version)
			emit_signal("loaded_setings")
#			resave_settings(tester)
			return
		else:
			Global.user_settings = load("user://user_settings_demo.tres")
	else:
		Global.user_settings = UserSettings.new()
	
	clouds = Global.user_settings.clouds
	cloud_level = Global.user_settings.cloud_level
	bgquality = Global.user_settings.bgquality
	fullscreen = Global.user_settings.fullscreen
	screen_mode = Global.user_settings.screen_mode
	resolution = Global.user_settings.resolution
	vsync = Global.user_settings.vsync
	cam_invert = Global.user_settings.cam_invert
	camrotspd = Global.user_settings.camrotspd
	
	# Remember to change version number if you added a new variable
	wallquality = Global.user_settings.wallquality
	
	emit_signal("loaded_setings")

func resave_settings(old_settings):
	Global.user_settings.clouds = old_settings.clouds
	Global.user_settings.cloud_level = old_settings.cloud_level
	Global.user_settings.bgquality = old_settings.bgquality
	Global.user_settings.fullscreen = old_settings.fullscreen
	Global.user_settings.screen_mode = old_settings.screen_mode
	Global.user_settings.resolution = old_settings.resolution
	Global.user_settings.vsync = old_settings.vsync
	Global.user_settings.cam_invert = old_settings.cam_invert
	Global.user_settings.camrotspd = old_settings.camrotspd
	Global.user_settings.keybindings = old_settings.keybindings
	Global.user_settings.wallquality = old_settings.wallquality
	Global.user_settings.save()
#	load_settings()
