extends Node3D


func play():
	var mat = $MatSphere.material_overlay.duplicate()
	$MatSphere.material_overlay = mat
	$Body/CSGMesh3D3.material_overlay = mat
	$Body/Turbininha.material_overlay = mat
	$"Body/Mur-cego".material_overlay = mat
	$Anim.play("Blink")

func speed(speed):
	if speed > 0.8:
		$Anim.play("Blink")
		$Anim.speed_scale = speed
	else:
		$Anim.play("RESET")
