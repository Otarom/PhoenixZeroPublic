extends Skill

var active = false
var timer = 0
var active_timer = 0
@onready var collision = $Area3D

func _ready():
	active = false
	var heal = Heal.new()
	heal.amount = amount
	heal.collision = collision
	heal.one_time = false
	heal.init()
	collision.monitoring = false

func use():
	active = true
	active_timer = duration
	collision.monitoring = false
	collision.monitoring = true
	$AnimationPlayer.play("Heal")
	pass
	
func _physics_process(delta):
	if active:
		active_timer-=delta
		if active_timer<=0:
			active = false
			collision.monitoring = false
			
