extends KinematicBody

const GRAVITY = -9.8 
const SPEED = 10
const ACCELERATION = 3
const DE_ACCELERATION = 5 

var velocity = Vector3()
var camera

var camera_angle
var mouse_sensibility = 0.2

onready var raycast = get_node("CameraAnchor/Camera/RayCast")

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
		if raycast.is_colliding():
			var coord = raycast.get_collision_point()
			var orient = raycast.get_collision_normal()
			emit_signal('new_portal', coord, orient, true)
	if Input.is_action_just_pressed("click2"):
		if raycast.is_colliding():
			var coord = raycast.get_collision_point()
			var orient = raycast.get_collision_normal()
			emit_signal('new_portal', coord, orient, false)
	
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
