extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	
	await Gamemaster.fade_to_black(0.5)
	
	Gamemaster.player.global_position = Vector3.ZERO
	Gamemaster.player.velocity = Vector3.ZERO
	Gamemaster.fade_from_black(0.5)
