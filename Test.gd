extends Spatial


func _input(event):
	if event.is_action_pressed("ui_up"):
		$CameraTop.current = true
		$CameraSide.current = false
	elif event.is_action_pressed("ui_right"):
		$CameraTop.current = false
		$CameraSide.current = true
