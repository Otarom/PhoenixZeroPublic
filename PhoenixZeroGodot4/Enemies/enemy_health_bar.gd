extends ProgressBar
class_name EnemyHealthBar

@export var MainNode : Node3D
@export var HealthComponent : HealthComponent
@export var StatHandler : StatHandler
@export var ShowValue : bool = true
@export var AlwaysActive : bool = false
@onready var HealthBar = $Health
@onready var HealthBarUnder = self
@onready var HealthBarText = $LifeText
var delay = 1
var timer = 0

var health
var max_health

var hit = false

func _ready():
	HealthComponent.on_damage_received.connect(_on_health_component_on_damage_received)

func _process(delta):
	health = HealthComponent.health
	max_health = StatHandler.max_health
	
	if health == max_health and not AlwaysActive:
		visible = false
	else:
		visible = true
	
	timer-=delta
	HealthBarText.visible = ShowValue
	
	HealthBar.value = 100*(health/max_health)
	HealthBarText.text = str(round(health))
	if hit:
		hit=false
		timer = delay
	
	if timer <= 0:
		HealthBarUnder.value = move_toward(HealthBarUnder.value,HealthBar.value,1/(HealthBar.value/HealthBarUnder.value))


func _on_health_component_on_damage_received(damage):
	hit = true
