extends Node3D

const BALL = preload("res://src/scenes/UI/resource_ball/resource_ball.tscn")

const TIME := 0.1
# Called when the node enters the scene tree for the first time.
func _ready():
	ResourcesManager.resource_UI = self
	
	add_mutagen(ResourcesManager.mutagen)


func add_mutagen(n:int):
	
	for i in n:
		var ball = BALL.instantiate()
		$mutagen.add_child(ball)
		ball.position.z += randf_range(-0.5, 0.5)
		
		await get_tree().create_timer(TIME).timeout
		
		
func add_metal(n:int):
	for i in n:
		var ball = BALL.instantiate()
		$metal.add_child(ball)
		ball.position.z += randf_range(-0.5, 0.5)
		await get_tree().create_timer(TIME).timeout
		
		

func add_oil(n:int):
	for i in n:
		var ball = BALL.instantiate()
		$oil.add_child(ball)
		ball.position.z += randf_range(-0.5, 0.5)
		await get_tree().create_timer(TIME).timeout
		
		
	
func remove_mutagen(n:int):
	
	for i in n:
		if $mutagen.get_child_count() == 0: return
		
		$mutagen.get_child(0).queue_free()
		
		await get_tree().create_timer(TIME).timeout

func remove_metal(n:int):
	
	for i in n:
		if $metal.get_child_count() == 0: return
		
		$metal.get_child(0).queue_free()
		
		await get_tree().create_timer(TIME).timeout

func remove_oil(n:int):
	
	for i in n:
		if $oil.get_child_count() == 0: return
		
		$oil.get_child(0).queue_free()
		
		await get_tree().create_timer(TIME).timeout
