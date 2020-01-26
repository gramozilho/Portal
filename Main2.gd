extends Spatial

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
	
	portal_X.orient = orient
	print('or ', portal_X.orient)
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
	mirror_cam_A.global_transform.origin = mirror_B.global_transform.origin + mirror_B.orient*.1
	mirror_cam_B.global_transform.origin = mirror_A.global_transform.origin + mirror_A.orient*.1
	
	mirror_cam_A.global_transform.basis.x *= -1
	mirror_cam_B.global_transform.basis.x *= -1
	

func teleport(body, original_portal):
	var target_portal
	if original_portal == $MirrorA:
		target_portal = $MirrorB
	else:
		target_portal = $MirrorA
	print('Teleport ' + body.name)
	target_portal.start_timer()
	var target_pos = target_portal.global_transform.origin + target_portal.orient*0.01
	print('4 ', target_portal.rotation)
	var target_orient = target_portal.rotation.normalized()
	var origin_orient = original_portal.rotation.normalized()
	
	#$Player.global_transform.origin = target_pos + target_portal.orient*.1 # Vector3(0, 0, 0.5)#+ target_orient * 2
	
	# Align player
	var old_rot = $Player/CameraAnchor.rotation.y
	$Player.global_transform = target_portal.global_transform * original_portal.global_transform.affine_inverse()*$Player.global_transform
	$Player/CameraAnchor.rotate_y(PI) #-target_orient.angle_to(origin_orient))
	#$Player.look_at = $Player.global_transform.rotated(Vector3(0,1,0), PI/2)
	#var old_angle = original_portal.orient.angle_to()
	#$Player.look_at(target_portal.orient, Vector3(0,1,0))
	#$Player.global_transform.origin = target_pos + target_portal.orient*.1 # Vector3(0, 0, 0.5)#+ target_orient * 2
	

func teleportB(body, original_portal):
	var target_portal
	if original_portal == $MirrorA:
		target_portal = $MirrorB
	else:
		target_portal = $MirrorA
	print('Teleport ' + body.name)
	target_portal.start_timer()
	var target_pos = target_portal.global_transform.origin 
	print('4 ', target_portal.rotation)
	var target_orient = target_portal.rotation.normalized()
	$Player.global_transform.origin = target_pos + target_portal.orient*.1 # Vector3(0, 0, 0.5)#+ target_orient * 2
	
	# Align player
	var old_angle = original_portal.orient.angle_to()
	$Player.look_at(target_portal.orient, Vector3())
	# Rotate
	var dir_rot = $Player/CameraAnchor.rotation.y# + 120 # keep original rot
	dir_rot += -(1-original_portal.rotation.normalized().dot(target_portal.rotation.normalized()))*90 # account for different portal angles
	print('a: ', original_portal.rotation.normalized().dot(target_portal.rotation.normalized()))
	$Player/CameraAnchor.rotate_y(deg2rad(dir_rot))
