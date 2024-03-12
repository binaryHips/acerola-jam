extends Area3D

enum TEAM {plants, humans}

@export var team:TEAM = TEAM.plants
@export var MAX_HP := 100.0

@export var passive_regen := 0.5

@export var HP = MAX_HP


func _ready():
	$Sprite3D.visible = Gamemaster.has_game_started
	Gamemaster.game_started.connect(_game_started)

func _game_started():
	$Sprite3D.show()


func damage(d:float):
	HP -= d
	update_lifebar()
	
	if HP <= 1:
		die()
	
func _process(delta):
	if HP < MAX_HP: # regenerate passively
		HP = min(HP+passive_regen * delta, MAX_HP)
		update_lifebar()
		

func update_lifebar():
	$Sprite3D.scale.x = HP / MAX_HP

func die():
	print("DEAD")
	
	if get_parent().has_method("die"):
		get_parent().die()
		return
		
	#TODO remove this when it's not needed anymore
	get_parent().queue_free()
