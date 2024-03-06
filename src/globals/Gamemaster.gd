extends Node

#player ref
var player

#plant nexus
var nexus

@onready var world = get_tree().get_first_node_in_group("world") #TODO change this when possible

var wards:Array[Ward] = []

var connections:Dictionary = {}

var max_connected_wards:int = 10


func add_ward(ward:Ward):
	wards.append(ward)

	connections[ward] = []
	
	
	for w in wards:
		if ward != w && can_connect(w, ward):
			connections[ward].append(w)
			connections[w].append(ward)
			
			print("connecté: ", w.tag, " - ", ward.tag)
	
	recompute_connexity()

#TODO the visual link between plants will be handled totally separately. Just have to connect to it later.
func remove_ward(ward:Ward):
	wards.erase(ward)
	
	for c in connections:
		if ward in connections[c]:
			connections[c].erase(c)
	
	recompute_connexity()

func can_connect(w1:Ward, w2:Ward):
	var dist := w1.global_position.distance_to(w2.global_position)
	return dist <= max(w1.range, w2.range)

func get_closest(ward):
	
	var dist:float = INF
	var candidate:Ward
	
	for w in wards:
		if ward.global_position.distance_squared_to(w) < dist**2:
			dist = ward.global_position.distance_squared_to(w)
			candidate = ward
			
	
	return candidate

func recompute_connexity():
	if not nexus: return
	
	var stack := [nexus]

	var not_visited:Array[Ward] = wards.duplicate()
	for m in max_connected_wards:
		if stack == []: break
		var ward = stack.pop_front()
		
		
		for i in connections[ward]:
			if not (i in stack) && (i in not_visited):
				stack.append(i)
				
		
		
		not_visited.erase(ward)
		ward.is_linked_to_base = true
	
	for w in not_visited:
		w.is_linked_to_base = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
