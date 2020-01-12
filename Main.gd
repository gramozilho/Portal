extends Spatial

const portal = preload("res://Portal.tscn")
var typeA = true
var portal_list = []
var last_portal_is_A = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
	if Input.is_action_just_pressed("ui_restart"):
		get_tree().reload_current_scene()

func _on_KinematicBody_new_portal(coord, orient):
	pass

func _on_KinematicBody_new_portal_old(coord, orient):
	var new_portal = portal.instance()
	new_portal.global_transform.origin = coord
	var normal_vec = Vector3(0, 1, 0)
	if orient[1] > 0.5 or orient[1] < .5:
	#print('aaaaaa', new_portal.normal_vec)
		normal_vec = Vector3(0, 0, 1)
	new_portal.look_at_from_position(coord, coord - orient, normal_vec)
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

func teleport(pType):
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
		
