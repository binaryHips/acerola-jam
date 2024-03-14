extends Node3D



func _ready():
	Gamemaster.max_connected_wards += 3
	
func _exit_tree():
	Gamemaster.max_connected_wards -= 3
