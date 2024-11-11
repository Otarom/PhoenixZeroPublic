extends Marker3D

var enemies : Array = []
@export var Weapon : Weapon
var shooting = false
var init = false

var reloading
var timer = 0.2
var reloadtimer = 0.1
var noammo = false

@onready var Laser : Sprite3D = $Laser
@onready var Area : CollisionShape3D = $Area3D/Dmg


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	timer-=delta
	if timer <= 0:
		Laser.visible = false

func _physics_process(delta):
	
	if noammo:
		reloadtimer-= delta
		if reloadtimer<=0:
			noammo = false
			Weapon.WeaponHolder.reload()
	
	if reloading:
		reloadtimer-= delta
		if reloadtimer<=0:
			reloadtimer=0.05
			Weapon.WeaponHolder.ammo = clamp(Weapon.WeaponHolder.ammo+1,0,Weapon.max_ammo)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func shoot():
	reloading = false
	timer = 0.2
	if not init:
		init = true
		Weapon.WeaponHolder.on_release.connect(release)
	Laser.visible = true
	var lockMark = Weapon.WeaponHolder.lockMark
	var pos = to_local(lockMark.global_position)
	
	var size = position.distance_to(pos)
	
	
	Laser.scale.z = size*0.4
	Laser.position.z = size/2
	
	Area.shape.size.z = size
	Area.position.z = size/2
	
	var extra = 1
	
	Laser.modulate = Color.html("#00a5bf")
	if Weapon.WeaponHolder.ammo < Weapon.max_ammo/2:
		var bleed = 2
		extra = 1.5
		Laser.modulate = Color.html("#9e9800")
		if Weapon.WeaponHolder.ammo < Weapon.max_ammo/4:
			bleed = 5
			Laser.modulate= Color.html("#f35a00")
			extra = 2
		if (Weapon.WeaponHolder.Player.HealthComponent.health - bleed) > 0:
			Weapon.WeaponHolder.Player.HealthComponent.bleed(bleed)
	
	for e in enemies:
		var hit = Hit.new()
		Weapon.main.add_child(hit)
		hit.global_position = e.global_position
		hit.global_position.y +=1
		var dmg = Weapon.WeaponHolder.StatHandler.damage
#		var dist = position.distance_to(to_local(e.global_position))
		hit.damage = clamp(dmg / (size/7) * extra, dmg / 10, dmg*extra)
		hit.damage = roundi(hit.damage)
		hit.piercing = Weapon.piercing
		hit.ap = Weapon.armour_penetration
		hit.MainNode = Weapon.WeaponHolder.Player
		
		e.HealthComponent.damage(hit)
	
	if Weapon.WeaponHolder.ammo <= 0:
		noammo = true
		reloadtimer = 5
	
	pass

func release():
	if not noammo:
		reloadtimer = 1
		reloading = true

func _on_area_3d_body_entered(body):
	enemies.append(body)
	pass # Replace with function body.


func _on_area_3d_body_exited(body):
	enemies.erase(body)
	pass # Replace with function body.
