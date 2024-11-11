extends Node3D

var enemies : Array = []
var extra : Array = []
@export var Weapon : Weapon
var shooting = false

func _physics_process(delta):
	if Weapon.WeaponHolder:
		if Weapon.WeaponHolder.ammo == 1:
			$NormalHitboxes/Hit2.disabled = false
			$NormalHitboxes/Hit3.disabled = false
			$ExtraHit/Hit.disabled = false
		else:
			$NormalHitboxes/Hit2.disabled = true
			$NormalHitboxes/Hit3.disabled = true
			$ExtraHit/Hit.disabled = true
	
		if Weapon.WeaponHolder.ammo == 2:
			$NormalHitboxes/Hit4.disabled = false
			$NormalHitboxes/Hit5.disabled = false
			$NormalHitboxes/Hit6.disabled = false
			$NormalHitboxes/Hit7.disabled = false
		else:
			$NormalHitboxes/Hit4.disabled = true
			$NormalHitboxes/Hit5.disabled = true
			$NormalHitboxes/Hit6.disabled = true
			$NormalHitboxes/Hit7.disabled = true
		
		if Weapon.WeaponHolder.ammo == 3:
			$NormalHitboxes/Hit8.disabled = false
			$NormalHitboxes/Hit9.disabled = false
			$NormalHitboxes/Hit10.disabled = false
			$NormalHitboxes/Hit11.disabled = false
		else:
			$NormalHitboxes/Hit8.disabled = true
			$NormalHitboxes/Hit9.disabled = true
			$NormalHitboxes/Hit10.disabled = true
			$NormalHitboxes/Hit11.disabled = true
	

# Called when the node enters the scene tree for the first time.
func shoot():
	if Weapon.WeaponHolder.ammo == 0:
		$"../Sound".pitch_scale = 1.3
		$"../AnimationHandler".play("CombinedSlash")
	elif Weapon.WeaponHolder.ammo == 1:
		$"../Sound".pitch_scale = 1.1
		$"../AnimationHandler".play("Slash2")
	elif Weapon.WeaponHolder.ammo == 2:
		$"../Sound".pitch_scale = 1.1
		$"../AnimationHandler".play("Slash")
	for e in enemies:
		var hit = Hit.new()
		Weapon.main.add_child(hit)
		hit.global_position = e.global_position
		hit.global_position.y +=1
		hit.damage = Weapon.WeaponHolder.StatHandler.damage
		hit.piercing = Weapon.piercing
		hit.ap = Weapon.armour_penetration
		hit.MainNode = Weapon.WeaponHolder.Player
		
		e.HealthComponent.damage(hit)
	
	for e in extra:
		var hit = Hit.new()
		Weapon.main.add_child(hit)
		hit.global_position = e.global_position
		hit.global_position.y +=2
		hit.damage = Weapon.WeaponHolder.StatHandler.damage
		hit.piercing = Weapon.piercing
		hit.ap = Weapon.armour_penetration
		hit.MainNode = Weapon.WeaponHolder.Player
		
		e.HealthComponent.damage(hit)
		
	pass


func _on_normal_hitboxes_body_entered(body):
	enemies.append(body)
	pass # Replace with function body.


func _on_extra_hit_body_entered(body):
	extra.append(body)
	pass # Replace with function body.


func _on_normal_hitboxes_body_exited(body):
	enemies.erase(body)
	pass # Replace with function body.


func _on_extra_hit_body_exited(body):
	extra.erase(body)
	pass # Replace with function body.
