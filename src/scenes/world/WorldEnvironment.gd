extends WorldEnvironment



func _ready():
	
	Gamemaster.game_started.connect(_start_cycle)


func _start_cycle():
	get_parent().play("cycle")
