extends Node

@export var HealthComponent : HealthComponent

@onready var HitSound = $HitSound
@onready var Death = $Death

# Called when the node enters the scene tree for the first time.
func _ready():
	HealthComponent.on_invulnerability_change.connect(inv_change)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func inv_change(inv):
	if inv:
		HitSound.pitch_scale = 0.4
	else:
		HitSound.pitch_scale = 0.8

func _on_health_component_on_hit(Hit):
	if not HealthComponent.Invulnerable:
		if not HitSound.is_playing():
			HitSound.pitch_scale = 0.8
			HitSound.play()
	else: 
		if not HitSound.is_playing():
			HitSound.pitch_scale = 0.4
			HitSound.play()
	pass # Replace with function body.
