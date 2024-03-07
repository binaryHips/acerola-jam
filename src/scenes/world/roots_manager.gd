extends Node3D


var connections: Array = []

const ROOT = preload("res://src/scenes/root/root.tscn")

func _ready():
	Gamemaster.roots_manager = self


func add_connection(w1:Ward, w2:Ward):
	
	if [w1, w2] in connections: return #zlready connected?
	
	connections.append([w1, w2])
	
	var new_root = ROOT.instantiate()
	new_root.start_position = w1.global_position
	new_root.end_position = w2.global_position
	add_child(new_root)
	
	

func remove_conections(ward:Ward):
	
	for k in range(len(connections)-1, 0, -1):
		print(k)
		if ward in connections[k]:
			
			#using the fact that children are added in order.
			connections.remove_at(k)
			get_children()[k].destroy_root()
			
