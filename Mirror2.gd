extends MeshInstance

export (NodePath) var viewport_mirror

func _ready():
	self.get_surface_material(0).set_shader_param("refl_tx", viewport_mirror)
