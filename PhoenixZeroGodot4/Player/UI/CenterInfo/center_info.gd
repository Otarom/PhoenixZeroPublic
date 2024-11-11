extends Control

@export var MainNode : Control
@export var delay = 5
@export_group("Health")
@export var HealthBar : TextureProgressBar
@export var HealthBarUnder : TextureProgressBar
@export_group("Energy")
@export var EnergyBar : TextureProgressBar
@export var EnergyBarUnder : TextureProgressBar
@export_group("Ammo")
@export var AmmoBar : TextureProgressBar
@export var AmmoBarUnder : TextureProgressBar



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	HealthBar.value = 100*(MainNode.health/MainNode.max_health)
	if MainNode.hit:
		HealthBarUnder.timer = delay
		
	EnergyBar.value = 100*(MainNode.steam/MainNode.max_steam)
	if MainNode.skill:
		EnergyBarUnder.timer = delay
		
	AmmoBar.value = 100*(float(MainNode.ammo)/float(MainNode.max_ammo))
	if MainNode.shot:
		MainNode.shot=false
		AmmoBarUnder.timer = delay/2
