extends Node3D
class_name HealthComponent

@export var StatHandler : StatHandler
@export var Invulnerable = false
var health : float
var regen = false

# Signals
signal on_hit
signal on_damage_received(damage:float)
signal on_heal(heal:float)
signal on_death
signal on_invulnerability_change(value:bool)
signal on_bleed(bleed:float)

func _ready():
	init()

func init():
	health = StatHandler.max_health
	
func _physics_process(delta):
	if regen:
		health+=StatHandler.health_regen
		if health > StatHandler.max_health:
			health = StatHandler.max_health
	
func damage(Hit: Hit):
	emit_signal("on_hit", Hit)
	if not Invulnerable or Hit.explosion:
		var damage = Hit.damage - StatHandler.armour * (1 - (Hit.ap/100))
		health -= damage
		emit_signal("on_damage_received", damage)
		
	if health <=0:
		emit_signal("on_death")

func bleed(bleed):
	if not Invulnerable:
		health -= bleed
		emit_signal("on_bleed", bleed)
		
	if health <=0:
		emit_signal("on_death")

func die():
	emit_signal("on_death")

func heal(heal: Heal):
	if health == StatHandler.max_health:
		return false
	var amount = heal.amount - (heal.amount * (StatHandler.heal_debuff / 100))
	emit_signal("on_heal", amount)
	health += amount
	
	if health > StatHandler.max_health:
		health = StatHandler.max_health
	
	return true

func toggle_invulnerability(value:bool):
	Invulnerable=value
	emit_signal("on_invulnerability_change", Invulnerable)
