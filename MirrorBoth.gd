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
	get_tree().call_group("mirrors", "transform_coord", main_cam_transform)
	#print(mirror_A.local_coord)
	$Mirror.scale.y *= -1
	$Mirror2.scale.y *= -1
	
	dummy_cam_A.global_transform =  mirror_A.global_transform * mirror_A.local_coord # main_cam_transform
	#dummy_cam_B.global_transform = main_cam_transform
	
	$Mirror.scale.y *= -1
	$Mirror2.scale.y *= -1
	
	mirror_cam_A.global_transform = dummy_cam_A.global_transform
	mirror_cam_B.global_transform = dummy_cam_B.global_transform
	
	mirror_cam_A.global_transform.basis.x *= -1
	mirror_cam_B.global_transform.basis.x *= -1
