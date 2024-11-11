extends Node3D
class_name Heal

@export var amount = 0
var regen = 0
@export var collision : Area3D
@export var one_time = false

signal freed

func _ready():
	collision.body_entered.connect(_on_area_body_entered)

func init():
	collision.body_entered.connect(_on_area_body_entered)

func _on_area_body_entered(body):
	if body is Player:
		var healed = body.HealthComponent.heal(self)
		if healed && one_time:
			emit_signal("freed")
			queue_free()
