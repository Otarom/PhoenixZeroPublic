extends Node3D

@export var Player : Player
@export var Skill : Skill
@export var StatHandler : StatHandler
@export var AimRig: Marker3D
@onready var main = get_tree().current_scene
var steam
var max_steam
var skillarea
var area
var regen = false
var low_st_use = true
signal on_skill_used

func _ready():
	steam = StatHandler.max_energy
	max_steam = StatHandler.max_energy

func refresh():
	pass

func use():
	Skill.use()

func _physics_process(delta):
	if Skill and not Player.dead:
		if (Input.is_action_just_pressed("player_skill") or Input.is_action_just_pressed("player_skill_alt")) && steam != 0 && low_st_use:
			if steam < Skill.cost:
				low_st_use = false
			steam = clamp(steam - Skill.cost, 0, StatHandler.max_energy)
			emit_signal("on_skill_used")
			use()
		Skill.set_rotation(AimRig.get_rotation())
		
		if steam > Skill.cost:
				low_st_use = true
		
		if regen:
			steam+=StatHandler.energy_regen
			if steam > StatHandler.max_energy:
				regen=false
				steam = StatHandler.max_energy

func add_steam(amount):
	steam+=amount
	if steam > StatHandler.max_energy:
		steam = StatHandler.max_energy
