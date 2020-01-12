extends KinematicBody

const GRAVITY = -9.8 
const SPEED = 10
const ACCELERATION = 3
const DE_ACCELERATION = 5 

var velocity = Vector3()
var dir = Vector3()
var camera

	
func _physics_process(delta):
	var dir = Vector3()
	if Input.is_action_pressed("ui_up"):
		dir += -camera.basis[2]
	if Input.is_action_pressed("ui_down"):
		dir += camera.basis[2]
	if Input.is_action_pressed("ui_left"):
		dir += -camera.basis[0]
	if Input.is_action_pressed("ui_right"):
		dir += camera.basis[0]
	if Input.is_action_just_pressed("click"):
		print('Portal spawn')
		if get_node("CameraAnchor/Camera/RayCast").is_colliding():
			var coord = get_node("CameraAnchor/Camera/RayCast").get_collision_point()
			var orient = get_node("CameraAnchor/Camera/RayCast").get_collision_normal()
			print(orient)
			
			emit_signal('new_portal', coord, orient)
	
	dir.y = 0
	dir = dir.normalized()
	
	velocity.y += delta * GRAVITY
	
	var hv = velocity
	hv.y = 0
	
	var new_pos = dir * SPEED
	var accel = DE_ACCELERATION
	
	if (dir.dot(hv) > 0):
		accel = ACCELERATION
	
	hv = hv.linear_interpolate(new_pos, accel * delta)
	
	velocity.x = hv.x
	velocity.z = hv.z
	
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))
