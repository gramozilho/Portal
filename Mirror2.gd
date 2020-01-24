extends MeshInstance

signal teleport
export (NodePath) var viewport_mirror

func _ready():
	pass #self.get_surface_material(0).set_shader_param("refl_tx", viewport_mirror)


func _on_Area_body_entered(body):
	if body.is_in_group('teleport'):
		print(self.name)
		emit_signal('teleport', body, self)
