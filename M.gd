extends Spatial


export (NodePath) var viewport_mirror


# Called when the node enters the scene tree for the first time.
func _ready():
	#var new_texture = load("res://MirrorA.tres")
	#$Mirror.get_surface_material(0).set_shader_param("refl_tx").set_viewport_path_in_scene(viewport)
	$Mirror.get_surface_material(0).set_shader_param("refl_tx", viewport_mirror)
	#$Mirror.get_surface_material(0).set_viewport_path_in_scene(viewport)
	#new_texture.viewporttex viewport_path = "PortalHolder/Mirror2/View"
	#$Mirror.material_override = new_texture
	#$Mirror.material_override.set_shader_param("viewport_path", "PortalHolder/Mirror2/View")
	#$Mirror.material_override.set_shader_param("viewport_path", "PortalHolder/Mirror2/View")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
