extends Spatial


func _ready():
	pass # Replace with function body.

func update_cam(update_cam_transform):
	$Mirror/PlayerCopy.global_transform = update_cam_transform #* Transform().rotated(Vector3(1, 0, 0), -PI/2)
	
	# DummyCamA
	var pos_relative_mirror_to_player = $Mirror.global_transform.inverse() * update_cam_transform
	$Mirror/Inverse.global_transform = pos_relative_mirror_to_player.affine_inverse() * $Mirror.global_transform # * Transform().rotated(Vector3(1, 0, 0), PI/2)
	
	# DummyCamB
	var pos_relative_mirror_to_player_2 = $Mirror2.global_transform.inverse() * update_cam_transform
	$Mirror2/Inverse2.global_transform = pos_relative_mirror_to_player_2.affine_inverse() * $Mirror.global_transform # * Transform().rotated(Vector3(1, 0, 0), PI/2)
	
