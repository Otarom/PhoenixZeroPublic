extends Area3D

@export var active = false
@export var damage = 300
@export var ticktime = 0.1

var players = []
var hitdelay = 0
var hit

# Called when the node enters the scene tree for the first time.
func _ready():
	hit = Hit.new()
	hit.damage = damage


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if active:
		hitdelay-=delta
		if hitdelay <= 0:
			for p in players:
				p.HealthComponent.damage(hit)
				hitdelay = ticktime


func _on_body_entered(body):
	if body is Player:
		players.append(body)


func _on_body_exited(body):
	if body is Player:
		players.erase(body)
