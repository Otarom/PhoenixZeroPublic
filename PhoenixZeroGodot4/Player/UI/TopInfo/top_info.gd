extends Control

@export var MainNode : Control
@export var delay = 5
@export_group("Health")
@export var HealthBar : TextureProgressBar
@export var HealthBarUnder : TextureProgressBar
@export var HealthBarText : RichTextLabel
@export_group("Energy")
@export var EnergyBar : TextureProgressBar
@export var EnergyBarUnder : TextureProgressBar
@export var EnergyBarText : RichTextLabel



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	HealthBar.value = 100*(MainNode.health/MainNode.max_health)
	HealthBarText.text = str(round(MainNode.health))
	if MainNode.hit:
		MainNode.hit=false
		HealthBarUnder.timer = delay
		
	EnergyBar.value = 100*(MainNode.steam/MainNode.max_steam)
	EnergyBarText.text = str(round(MainNode.steam))
	if MainNode.skill:
		MainNode.skill=false
		EnergyBarUnder.timer = delay
