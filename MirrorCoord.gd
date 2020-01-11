extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var local_coord

# Called when the node enters the scene tree for the first time.
func _ready():
	local_coord = Transform()

func transform_coord(global_coord):
	#print(global_transform)
	#print(' GC ', global_coord)
	local_coord = global_coord.affine_inverse() * global_transform
	print('Test ', local_coord)
	#return local_coord
