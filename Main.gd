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

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
	if Input.is_action_just_pressed("ui_restart"):
		get_tree().reload_current_scene()

func _on_KinematicBody_new_portal(coord, orient, is_portal_A):
	orient = Vector3(round(orient[0]), round(orient[1]), round(orient[2]))
	print('1 New portal at: ', coord, orient)
	if is_portal_A:
		# Move portal B
		portal_X = $Mirror
		#mirror_X = $PortalHolder/M/Mirror
		#normal_X = $PortalHolder/M/Mirror/MeshInstance
		#up_X = $PortalHolder/Mirror/Up
	else:
		# Move portal A
		portal_X = $PortalHolder/Mirror2
		normal_X = $PortalHolder/Mirror2/Normal2
		#up_X = $PortalHolder/Mirror2/Up2
	
	#portal_X.global_transform = Transform()
	portal_X.global_transform.origin = coord + orient*.001
	#portal_X.look_at(portal_X.global_transform.origin - orient, Vector3(0,1,0))
	self.transform = self.transform.looking_at(portal_X.global_transform.origin - orient, Vector3(0,1,0))
	
	#portal_X.global_transform *= Transform(Vector3(-PI/2, 0, 0), Vector3(), Vector3(), Vector3())
	if orient[1] == -1:
		print('Ceiling')
		self.transform = self.transform.looking_at(portal_X.global_transform.origin - orient, Vector3(0,-1,0))
	
	
	
	#normal_X.look_at(orient, Vector3(0,1,0))

func testee(coord, orient, portal_X):
	if orient[1] < -0.9:
		print('-z')
		portal_X.global_transform *= Transform().rotated(Vector3(0,0,1), PI)
	elif orient[2] > 0.9:
		print('+x')
		portal_X.global_transform.basis *= Transform().rotated(Vector3(1,0,0), PI/2)
	elif orient[2] < -0.9:
		print('-x')
		portal_X.global_transform.basis *= Transform().rotated(Vector3(1,0,0), -PI/2)
		
		#rotation_vec = Vector3(-1, 0, 0)
	#portal_X.global_transform *= Transform().rotated(rotation_vector, -PI/2)
	#orient = Vector3(orient[2], orient[0], orient[1])
	var normal_vec = Vector3(0, 1, 0)
	#var extra_rotation = Vector3(0, 0, -PI/2)
	#if orient[1] > 0.5 or orient[1] < .5:
	#	extra_rotation = Vector3(0, PI/2, -PI/2)
	#	print('aaaaaa', portal_X.rotation)
	#	normal_vec = Vector3(0, 0, 1)
	#portal_X.look_at_from_position(coord, coord - orient, normal_vec)
	#portal_X.global_transform *= Transform().rotated(orient, PI/2)
	#portal_X.global_transform = portal_X.global_transform * Transform().rotated(Vector3(1,1,0), PI/2)
	#portal_X.rotation = orient.normalized()
	#last_portal_is_A = !last_portal_is_A

func _on_KinematicBody_new_portal_old(coord, orient):
	var new_portal = portal.instance()
	new_portal.global_transform.origin = coord
	var normal_vec = Vector3(0, 1, 0)
	if orient[1] > 0.5 or orient[1] < .5:
	#print('aaaaaa', new_portal.normal_vec)
		normal_vec = Vector3(0, 0, 1)
	new_portal.look_at_from_position(coord, coord - orient, normal_vec)
	print(orient)
	new_portal.typeA = typeA
	typeA = !typeA
	# connect teleport signal
	new_portal.connect("teleport", self, "teleport")
	
	# add normal
	new_portal.normal_vec = orient
	
	# handle multiple portals
	portal_list.append(new_portal)
	if len(portal_list)>2:
		portal_list[0].queue_free()
		portal_list.pop_front()
	
	self.add_child(new_portal)

func teleport_old(pType):
	if len(portal_list) > 1:
		# Find typeA on listvar 
		var idxB = 0
		var idxA = 1
		if portal_list[0].typeA:
			idxA = 0
			idxB = 1
		
		# Teleport
		var target_portal = Vector3()
		var original_portal = Vector3()
		if pType: #is on typeA, go to B
			target_portal = portal_list[idxB]
			original_portal = portal_list[idxA]
		else:
			target_portal = portal_list[idxA]
			original_portal = portal_list[idxB]
		var target_pos = target_portal.global_transform.origin 
		var target_orient = target_portal.normal_vec
		$Player.global_transform.origin = target_pos + target_orient * 1
		
		# Rotate
		var dir_rot = $Player/CameraAnchor.rotation.y + 180 # keep original rot
		dir_rot += -(1-original_portal.normal_vec.dot(target_portal.normal_vec))*90 # account for different portal angles
		print('a: ', original_portal.normal_vec.dot(target_portal.normal_vec))
		$Player/CameraAnchor.rotate_y(deg2rad(dir_rot))
		
		# Update render
		


func _on_Player_new_portal():
	pass # Replace with function body.


func _on_Area_body_entered(body):
	pass # teleport($PortalHolder/Mirror, $PortalHolder/Mirror2)

func teleport(original_portal, target_portal):
		var target_pos = target_portal.global_transform.origin 
		print('4 ', target_portal.rotation)
		var target_orient = target_portal.rotation.normalized()
		$Player_v2.global_transform.origin = target_pos + Vector3(0, 0, 0.5)#+ target_orient * 2
		
		# Rotate
		var dir_rot = $Player_v2/CameraAnchor.rotation.y + 120 # keep original rot
		dir_rot += -(1-original_portal.rotation.normalized().dot(target_portal.rotation.normalized()))*90 # account for different portal angles
		print('a: ', original_portal.rotation.normalized().dot(target_portal.rotation.normalized()))
		$Player_v2/CameraAnchor.rotate_y(deg2rad(dir_rot))


func _on_Area2_body_entered(body):
	pass #teleport($PortalHolder/Mirror2, $PortalHolder/Mirror)
