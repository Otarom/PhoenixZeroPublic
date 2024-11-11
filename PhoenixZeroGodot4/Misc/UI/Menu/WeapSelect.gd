extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	$Machinegun.visible = false
	$EnergySword.visible = false
	$Saw.visible = false
	$Sniper.visible = false
	$Laser.visible = false
	$Cluster.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start():
	$"..".timer = 1
	$"../../../SplashAnimations/Music".stop()
	$"../Loading".visible = true
	

func _on_mg_select_pressed():
	Global.playerWeapon = 0
	start()
	pass # Replace with function body.

func _on_es_select_pressed():
	Global.playerWeapon = 1
	start()
	pass # Replace with function body.


func _on_ds_select_pressed():
	Global.playerWeapon = 2
	start()
	pass # Replace with function body.


func _on_sr_select_pressed():
	Global.playerWeapon = 3
	start()
	pass # Replace with function body.

func _on_lb_select_pressed():
	Global.playerWeapon = 4
	start()
	pass # Replace with function body.

func _on_cs_select_pressed():
	Global.playerWeapon = 5
	start()
	pass # Replace with function body.





func _on_cancel_pressed():
	visible = false
	$Machinegun.visible = false
	$EnergySword.visible = false
	$Saw.visible = false
	$Sniper.visible = false
	$Laser.visible = false
	$Cluster.visible = false
	pass # Replace with function body.






