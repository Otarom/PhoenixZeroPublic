extends CharacterBody3D

@export var StatHandler : StatHandler
@export var HealthComponent : HealthComponent
var duration = 100
var health = 100
var size = 8
@onready var open_anim = $AnimationPlayer.get_animation("ShieldOpen")

# Called when the node enters the scene tree for the first time.
func _ready():
	open_anim.track_set_key_value(0, 2, Vector3(size,4,0.5))
	open_anim.track_set_key_value(1, 1, Vector3(size/2,0.736,0))
	open_anim.track_set_key_value(3, 1, Vector3(-size/2,0.736,0))
	StatHandler.BaseStats.max_health = health
	StatHandler.refresh()
	HealthComponent.init()
	$AnimationPlayer.play("ShieldOpen")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	duration-=delta
	if duration <= 0:
		$AnimationPlayer.play_backwards("ShieldOpen")



func _on_animation_player_animation_finished(anim_name):
	if anim_name == "ShieldOpen" && duration > 0:
		HealthComponent.Invulnerable = false
	if duration <= 0 || anim_name == "ShieldBreak":
		queue_free()


func _on_health_component_on_death():
	$AnimationPlayer.play("ShieldBreak")


func _on_health_component_on_damage_received(damage):
#	print("dmg: "+str(damage)+" Health: "+ str(HealthComponent.health))
	pass
