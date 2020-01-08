extends Spatial

const colorA = Color(1.0, 133.0/255, 25.0/255)
const colorB = Color(0.0, 80.0/255, 233.0/255)

var typeA = true
var normal_vec = Vector3()

const materialA = preload("res://PortalA.tres")
const materialB = preload("res://PortalB.tres")

signal teleport

func _ready():
	if typeA:
		$Area/Mesh.set_material_override(materialA)
	else:
		$Area/Mesh.set_material_override(materialB)


func _on_Area_body_entered(body):
	print('Body enter portal: ', body.name)
	if body.is_in_group("teleport"):
		print('Teleport this body: ', body)
		emit_signal("teleport", typeA)
		#body.global_transform.origin += Vector3(0, 10, 0) 
