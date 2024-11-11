extends Marker3D

@export var Weapon : Weapon
@onready var Mount_Count = get_child_count()
var timer = 2
var shooting = false
var shot = false
var init = false
# This code need to be revamped later on Inventory Update
# to better fit gun needs and ease gun creation.
	
func shoot():
	timer+=1
	Weapon.Sound.pitch_scale+=0.1
	shooting = true
	$"../Sprite".visible = true
	if not init:
		init = true
		Weapon.WeaponHolder.on_reload.connect(reloaded)
		Weapon.WeaponHolder.on_release.connect(release)

func reloaded():
	shot = false
	Weapon.Sound.pitch_scale=1.2

func release():
	if not shot and shooting:
		shot = true
		shooting = false
		Weapon.WeaponHolder.ammo = 0
		$"../Sprite".visible = false
		for i in range(0, Mount_Count, 1):
			var mount = get_child(i)
#			var mflash = Weapon.Muzzle_Flash.instantiate()
#			Weapon.main.add_child(mflash)
#			mflash.transform = mount.global_transform
#			mflash.transform.origin.y = 0
			for n in range(0, Weapon.shots, 1):
				var bullet = Weapon.Bullet.instantiate()
				Weapon.main.add_child(bullet)
				bullet.MainNode = Weapon.WeaponHolder.Player
				bullet.transform = mount.global_transform
				bullet.transform.origin.y = 0
				bullet.damage = Weapon.WeaponHolder.StatHandler.damage
				bullet.range = Weapon.range
				bullet.ap = Weapon.armour_penetration
				bullet.piercing = Weapon.piercing
				bullet.speed = Weapon.bullet_speed
				bullet.timer = timer
				bullet.direction = mount.get_child(0).global_transform.origin - global_transform.origin
				bullet.origin = global_transform.origin
				var newrot = bullet.get_rotation()
				bullet.newrot = newrot
				bullet.connect_recall()
		timer = 2
		
