extends Area3D
class_name ResourceArea

@export var resources:Vector3i

var max_resources:Vector3i
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("resource")
	max_resources = resources



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
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
