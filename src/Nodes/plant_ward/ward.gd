extends Node3D
class_name Ward


static var debugview := true


@export var tag:String = ""

var is_linked_to_base:bool = false

@export var range:float = 15

func _ready():
	Gamemaster.add_ward(self)
	if debugview:
		debug_view()

func debug_view():
	
	var v := MeshInstance3D.new()
	v.mesh = CylinderMesh.new()
	v.scale.x = range*2.0
	v.scale.z = range*2.0
	v.material_override = load("res://resources/materials/debug.tres")
	add_child(v)


func _exit_tree():
	
	Gamemaster.remove_ward(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


