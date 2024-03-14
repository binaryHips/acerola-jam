extends Area3D
class_name ResourceArea

@export var resources:Vector3i

var max_resources:Vector3i
var main_type:int = 0

var light:OmniLight3D
func _ready():
	add_to_group("resource")
	max_resources = resources
	for i in [1, 2]: #used for puddles scaling
		if max_resources[i] > max_resources[main_type]:
			main_type = i
	assert(max_resources[main_type] > 0, "resource area not configured right!!")
	light = OmniLight3D.new()
	add_child(light)
	light.light_energy = 8
	light.position.y += 3
	light.light_color = Color.RED
	#light.omni_attenuation *= 3.0
	light.hide()
	ResourcesManager.selected_changed.connect(_selected_changed)

func extract():
	if resources[0] > 0:
		resources[0] -= 1
		ResourcesManager.add_mutagen(1)
		
	if resources[1] > 0:
		resources[1] -= 1
		ResourcesManager.add_metal(1)
	
	if resources[2] > 0:
		resources[2] -= 1
		ResourcesManager.add_oil(1)
	
	for k in get_children():
		if not k is CollisionShape3D:
			k.scale = Vector3.ONE * resources[main_type] / float(max_resources[main_type])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _selected_changed(s):
	
	if !is_instance_valid(s):
		light.hide()
		return
	
	if s.item_name in ["Extractor", "Mega extractor"]:
		light.show()
	else:
		light.hide()
