extends Resource
class_name UserSettings

@export var version = 0

## Visual
@export_group("Visual")
@export var clouds = false
@export var cloud_level = 0 # Level of Detail 0 is max 3 is min
@export var bgquality = 2 # Background Detal Level 0 to 2
@export var wallquality = 1
@export var fullscreen = false
@export var screen_mode = 2
@export var resolution = 0
@export var vsync = true
@export var cam_invert = false
@export var camrotspd = 2.0
@export var max_fps = 0

## Audio
@export_group("Audio")
@export var master = 0
@export var music = 0
@export var playersfx = 0
@export var enemsfx = 0
@export var explsfx = 0

## Keybinds
@export_group("Keybinds")
@export var keybindings : Dictionary = {}

func save() -> void:
	ResourceSaver.save(self, "user://user_settings_demo.tres")
