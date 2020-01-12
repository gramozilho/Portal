extends Camera

var colliding_object
var hidden_list = []

func _ready():
	#$RayCast.set_cast_to(rotation.normalized()*1000)
	pass

func update_cull_mask(idx):
	colliding_object = get_node("RayCast").get_collider()
	if false and colliding_object:
		colliding_object = colliding_object.get_parent()
		#print('Portal ', idx, 'colliding with ', colliding_object.name)
		if colliding_object.is_in_group('hide'):
			print('Colliding with hide: ', colliding_object.name)
			# Only remove form camera to mirror
			if !colliding_object.is_in_group('mirrors'):
				print('Hidding ', colliding_object.name)
				colliding_object.set_layer_mask_bit(idx-1, false)
				if !hidden_list.has(colliding_object):
					print('New colliding')
					hidden_list.append(colliding_object)
				if hidden_list[0] != colliding_object:
					hidden_list[0].set_layer_mask_bit(idx-1, true)
					# Remove from list
					hidden_list.pop_front()
					print('Remove colliding')
				
				#hidden_list.remove(hidden_list.find(element))
	# If detected not in vector, add and set CULL to off 
	
	
	# If element of vector not in detected, remove and set CULL to on
	
	
