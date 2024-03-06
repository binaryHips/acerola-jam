extends Node3D



func _ready():
	Gamemaster.max_connected_wards += 4
	
func _exit_tree():
	Gamemaster.max_connected_wards -= 4
