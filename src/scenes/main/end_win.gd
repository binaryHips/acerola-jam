extends Node3D




static var activated = false

func _win():
	if not activated:
		activated = true
		await Gamemaster.fade_to_black(1.5)
		
		Gamemaster.player.is_active = false
		$Camera3D.make_current()
		$AnimationPlayer.play("end_win")
		Gamemaster.fade_from_black(2.0)

func _lose():
	if not activated:
		activated = true
		await Gamemaster.fade_to_black(1.5)
		
		Gamemaster.player.is_active = false
		$Camera3D.make_current()
		$AnimationPlayer.play("end")
		Gamemaster.fade_from_black(2.0)

func _end():
	get_tree().paused = true
