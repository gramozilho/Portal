extends KinematicBody

const GRAVITY = -9.8 
const SPEED = 10
const ACCELERATION = 3
const DE_ACCELERATION = 5 

var velocity = Vector3()
var camera

var camera_angle
var mouse_sensibility = 0.2

signal new_portal

func _ready():
	camera = get_node("CameraAnchor").get_global_transform()


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
			
			#var space_state = get_world().direct_space_state
			#var result = space_state.intersect_ray(Vector3(0, 0, 0), Vector3(50, 100, 0))
			#print(result)
	
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

func _input(event):
	camera = get_node("CameraAnchor").get_global_transform()
	if event is InputEventMouseMotion:
		$CameraAnchor.rotate_y(-deg2rad(event.relative.x * mouse_sensibility))
		$CameraAnchor/Camera.rotate_x(-deg2rad(event.relative.y * mouse_sensibility))
		camera = get_node("CameraAnchor").get_global_transform()
	
	#if event is InputEventMouseButton:
	#	$CameraAnchor/Camera/RayCast.enabled = true
	#	print('1')
