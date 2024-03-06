extends Node3D

const BALL = preload("res://src/scenes/UI/resource_ball/resource_ball.tscn")

const MUTAGEN_MATERIAL = preload("res://resources/materials/envrionment/resources balls/mutagenball.tres")
const METAL_MATERIAL = preload("res://resources/materials/envrionment/resources balls/metalball.tres")
const OIL_MATERIAL = preload("res://resources/materials/envrionment/resources balls/oilball.tres")
const TIME := 0.1
# Called when the node enters the scene tree for the first time.
func _ready():
	ResourcesManager.resource_UI = self
	


func add_mutagen(n:int):
	
	for i in n:
		var ball = BALL.instantiate()
		(ball.get_node("MeshInstance3D") as MeshInstance3D).material_override = MUTAGEN_MATERIAL
		$mutagen.add_child(ball)
		ball.position.z += randf_range(-0.5, 0.5)
		await get_tree().create_timer(TIME).timeout
		
		
func add_metal(n:int):
	for i in n:
		var ball = BALL.instantiate()
		(ball.get_node("MeshInstance3D") as MeshInstance3D).material_override = METAL_MATERIAL
		(ball.get_node("CollisionShape3D") as CollisionShape3D).scale *= 1.5
		$metal.add_child(ball)
		ball.position.z += randf_range(-0.5, 0.5)
		await get_tree().create_timer(TIME*1.5).timeout
		
		

func add_oil(n:int):
	for i in n:
		var ball = BALL.instantiate()
		(ball.get_node("MeshInstance3D") as MeshInstance3D).material_override = OIL_MATERIAL
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
