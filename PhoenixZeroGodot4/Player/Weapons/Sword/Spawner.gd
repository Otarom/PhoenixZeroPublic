extends Marker3D

@export var Weapon : Weapon
@export var Sound : AudioStreamPlayer
@onready var Mount_Count = get_child_count()
# This code need to be revamped later on Inventory Update
# to better fit gun needs and ease gun creation.

func shoot():
	$"../Sprite3D".play("default")
	$"../Sprite3D".visible = true
	$"../Sprite3D".timer = 0.1
	for i in range(0, Mount_Count, 1):
		var mount = get_child(i)
		for n in range(0, Weapon.shots, 1):
			Sound.start()
			var bullet = Weapon.Bullet.instantiate()
			Weapon.main.add_child(bullet)
			bullet.MainNode = Weapon.WeaponHolder.Player
			bullet.transform = mount.global_transform
			bullet.transform.origin.y = 0
			bullet.damage = Weapon.WeaponHolder.StatHandler.damage
			bullet.range = Weapon.range/Weapon.shots*(n+1)
			bullet.ap = Weapon.armour_penetration
			bullet.piercing = Weapon.piercing
			bullet.speed = Weapon.bullet_speed
			if i == 1:
				bullet.speed = 0
				bullet.damage = Weapon.WeaponHolder.StatHandler.damage/6
			bullet.direction = mount.get_child(0).global_transform.origin - global_transform.origin
			bullet.origin = global_transform.origin
			var newrot = bullet.get_rotation()
			bullet.newrot = newrot
	if Weapon.WeaponHolder.ammo <= 0:
		$"../Sprite3D".visible = false
