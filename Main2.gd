extends Spatial

const portal = preload("res://Portal.tscn")
var typeA = true
var portal_list = []
#var last_portal_is_A = false
var portal_X
var normal_X
var mirror_X
var up_X
var rotation_vec = Vector3()

onready var mirror_A = $MirrorA
onready var mirror_B = $MirrorB

onready var dummy_cam_A = $MirrorA/DummyCam
onready var dummy_cam_B = $MirrorB/DummyCam

onready var mirror_cam_A = $MirrorA/Viewport/Camera
onready var mirror_cam_B = $MirrorB/Viewport/Camera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
	if Input.is_action_just_pressed("ui_restart"):
		get_tree().reload_current_scene()

# Move portal to click location
func _on_KinematicBody_new_portal(coord, orient, is_portal_A):
	orient = Vector3(round(orient[0]), round(orient[1]), round(orient[2]))
	print('1 New portal at: ', coord, orient)
	if is_portal_A:
		# Move portal B
		portal_X = $MirrorB
	else:
		# Move portal A
		portal_X = $MirrorA
	
	portal_X.global_transform = Transform()
	portal_X.global_transform.origin = coord + orient*.001
	
	portal_X.look_at(coord + Vector3(0,1,0), Vector3(0,1,0))
	if orient[1] == -1:
		print('ceiling')
		portal_X.global_transform *= Transform(Vector3(1,0,0), Vector3(0,-1,0), Vector3(0,0,1), Vector3(0,0,0))

# Update viewport
func update_cam(main_cam_transform):
	mirror_A.scale.y *= -1
	mirror_B.scale.y *= -1
	
	dummy_cam_A.global_transform = main_cam_transform
	dummy_cam_B.global_transform = main_cam_transform
	
	mirror_A.scale.y *= -1
	mirror_B.scale.y *= -1

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
	#mirror_A.global_transform = mirror_B.global_transform
	#mirror_B.global_transform = mirror_A.global_transform
