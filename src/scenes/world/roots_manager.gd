extends Node3D


var connections: Array = []
var connected:Array = []

const ROOT = preload("res://src/scenes/root/root.tscn")

func _ready():
	Gamemaster.roots_manager = self


func add_connection(w1:Ward, w2:Ward):
	
	if ! (is_instance_valid(w1) && is_instance_valid(w2)): return #just in case?
	
	if w2 in connected: return #zlready connected?
	
	connected.append(w2)
	connections.append([w1, w2])
	
	var new_root = ROOT.instantiate()
	new_root.start_position = w1.global_position
	new_root.end_position = w2.global_position
	add_child(new_root)
	
	

func remove_connections(ward:Ward):
	connected.erase(ward)
	for k in range(len(connections)-1, 0, -1):
		print(k)
		if ward in connections[k]:
			
			#using the fact that children are added in order.
			connections.remove_at(k)
			get_children()[k].destroy_root()
			
