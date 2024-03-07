extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Gamemaster.nexus = $Ward
	$Ward.is_linked_to_base = true
	Gamemaster.recompute_connexity() #just have to do it one time by hand.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
