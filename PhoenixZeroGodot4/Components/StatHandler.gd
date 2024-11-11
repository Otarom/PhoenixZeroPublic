extends Node
class_name StatHandler
# Holds current stats, refreshes values on call and modifies stats based 
# on value changes (Buffs, Debuffs, Item changes)

# For functions that are specific to each object, create them on a Control Node
# and add it as a variable on the main node. Add the additional refresh functions
# on if statements searching by node type or group.

@export var BaseStats : BaseStats
@export var MainNode : Node3D

@export_group("Basic Stats")
@export var level = 1
@export var speed = 5
@export var armour = 0
@export var damage = 20
@export var max_health = 100.0
@export var health_regen = 3.0
@export var max_energy = 100.0
@export var energy_regen = 0.1
var sprint_mult = 2

@export_group("Multipliers")
@export var atk = 1
@export var vit = 1
@export var con = 1
@export var dex = 1
@export var spd = 1
@export var enrg = 1

@export_group("Debug")
@export_subgroup("Debuffs")
@export var heal_debuff = 0
@export var energy_debuff = 0
@export var armour_debuff = 0
@export var damage_debuff = 0

@export_subgroup("Buffs")
@export var heal_buff = 0
@export var energy_buff = 0
@export var armour_buff = 0
@export var damage_buff = 0

signal on_refresh

# Loads all the base stats with the calculations based on the multipliers.
func init():
	speed = BaseStats.speed
	armour = BaseStats.armour
	damage = BaseStats.damage
	max_health = BaseStats.max_health
	max_energy = BaseStats.max_energy

# Sets the multipliers with fixed values
func set_multiplier(a : int, v : int, c : int, d : int, s : int, e : int):
	atk = clamp(a, 1, 99)
	vit = clamp(v, 1, 99)
	con = clamp(c, 1, 99)
	dex = clamp(d, 1, 99)
	spd = clamp(s, 1, 99)
	enrg = clamp(e, 1, 99)
	
	refresh()
	
# Changes the value of the current multipliers
func update_multiplier(a : int, v : int, c : int, d : int, s : int, e : int):
	atk = clamp(atk+a, 1, 99)
	vit = clamp(vit+v, 1, 99)
	con = clamp(con+c, 1, 99)
	dex = clamp(dex+d, 1, 99)
	spd = clamp(spd+s, 1, 99)
	enrg = clamp(enrg+e, 1, 99)
	
	refresh()
	
func refresh():
	speed = BaseStats.speed * spd
	armour = BaseStats.armour 
	max_health = BaseStats.max_health * con
	max_energy = BaseStats.max_energy * enrg
	
	emit_signal("on_refresh")
	
