extends Node3D



func _ready():
	pass

func start_intro():
	
	$intro.play("intro")
	visible = true
	
func _intro_finished():
	
	await Gamemaster.fade_to_black(1.0)
	
	Gamemaster.player.is_active = true
	visible = false
	
	await Gamemaster.fade_from_black(1.0)
	
