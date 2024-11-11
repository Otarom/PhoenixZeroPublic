extends Marker3D

@export var Weapon : Weapon
@onready var Mount_Count = get_child_count()
# This code need to be revamped later on Inventory Update
# to better fit gun needs and ease gun creation.

func shoot():
	for i in range(0, Mount_Count, 1):
		var mount = get_child(i)
		var mflash = Weapon.Muzzle_Flash.instantiate()
		Weapon.main.add_child(mflash)
		mflash.transform = mount.global_transform
		mflash.transform.origin.y = 0
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
			bullet.direction = mount.get_child(0).global_transform.origin - global_transform.origin
			bullet.origin = global_transform.origin
			var rotchang = (60/Weapon.shots)
			var newrot = bullet.get_rotation()
			var chknumeven = (Weapon.shots % 2) -1
			newrot.y -= deg_to_rad(rotchang * (Weapon.shots/2 + (0.5 * chknumeven)))
			newrot.y += deg_to_rad(rotchang) * n
			bullet.newrot = newrot
			bullet.numshots = Weapon.shots
			bullet.shotnum = n
