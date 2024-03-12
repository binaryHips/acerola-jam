extends Node3D



func _ready():
	pass

func start_intro():
	
	$intro.play("intro")
	visible = true
	
func _intro_finished():
	
	await Gamemaster.fade_to_black(2.0)
	Gamemaster.game_started.emit()
	Gamemaster.has_game_started = true
	Gamemaster.player.is_active = true
	visible = false
	
	await Gamemaster.fade_from_black(2.0)
	
