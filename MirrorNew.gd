extends Spatial

onready var mirror_A = $Mirror
onready var mirror_B = $Mirror2
onready var dummy_cam_A = $Mirror/DummyCam
onready var dummy_cam_B = $Mirror2/DummyCam
onready var mirror_cam_A = $Mirror/Viewport/Camera
onready var mirror_cam_B = $Mirror2/Viewport/Camera

func _ready():
	#$Mirror.add_to_group("mirrors")
	#$Mirror2.add_to_group("mirrors")
	#$Mirror/Viewport.size = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))
	#$Mirror2/Viewport.size = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))
	pass
	
func update_cam(main_cam_transform):
	$Mirror.scale.y *= -1
	$Mirror2.scale.y *= -1
	
	dummy_cam_A.global_transform = main_cam_transform
	dummy_cam_B.global_transform = main_cam_transform
	
	$Mirror.scale.y *= -1
	$Mirror2.scale.y *= -1

	# Orient cameras
	mirror_cam_A.global_transform = mirror_B.global_transform * mirror_A.global_transform.affine_inverse() * dummy_cam_A.global_transform
	mirror_cam_B.global_transform = mirror_A.global_transform * mirror_B.global_transform.affine_inverse() * dummy_cam_B.global_transform
	
	# Position cameras
	mirror_cam_A.global_transform.origin = mirror_B.global_transform.origin
	mirror_cam_B.global_transform.origin = mirror_A.global_transform.origin
	
	mirror_cam_A.global_transform.basis.x *= -1
	mirror_cam_B.global_transform.basis.x *= -1
	
	#mirror_cam_A.update_cull_mask(2)
	#mirror_cam_B.update_cull_mask(3)

func update_cam_2(main_cam_transform):
	#get_tree().call_group("mirrors", "transform_coord", main_cam_transform)
	#print(mirror_A.local_coord)
	#$Mirror.scale.y *= -1
	#$Mirror2.scale.y *= -1
	#var player_relative_to_mirror_A = mirror_A.global_transform.affine_inverse() * main_cam_transform
	#var inverted_camera_position_A =  player_relative_to_mirror_A.affine_inverse() * mirror_A.global_transform
	
	#dummy_cam_A.global_transform =  mirror_A.global_transform * mirror_A.local_coord # main_cam_transform
	#mirror_cam_A.global_transform =  inverted_camera_position_A
	#dummy_cam_B.global_transform = main_cam_transform
	
	#$Mirror.scale.y *= -1
	#$Mirror2.scale.y *= -1
	
	#mirror_cam_A.global_transform = dummy_cam_A.global_transform
	#mirror_cam_B.global_transform = dummy_cam_B.global_transform
	
	#mirror_cam_A.global_transform.basis.x *= -1
	#mirror_cam_B.global_transform.basis.x *= -1
	#dummy_cam_A.global_transform = main_cam_transform
	#$Mirror/DummyCam.global_transform = main_cam_transform #* Transform().rotated(Vector3(1, 0, 0), -PI/2)
	
	# DummyCamA
	var pos_relative_mirror_to_player = $Mirror.global_transform.affine_inverse() * main_cam_transform
	mirror_cam_A.global_transform = pos_relative_mirror_to_player.inverse() * $Mirror.global_transform # * Transform().rotated(Vector3(1, 0, 0), PI/2)
	
	# DummyCamB
	var pos_relative_mirror_to_player_2 = $Mirror2.global_transform.inverse() * main_cam_transform
	mirror_cam_B.global_transform = pos_relative_mirror_to_player_2.affine_inverse() * $Mirror.global_transform # * Transform().rotated(Vector3(1, 0, 0), PI/2)
	
	#mirror_cam_A.global_transform.basis.y *= -1



func _on_Player_new_portal(coord, orient):
	pass #print(coord, orient)

