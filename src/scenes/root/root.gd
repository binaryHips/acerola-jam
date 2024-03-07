extends Node3D

const TIME_TO_GROW_ONE_ROOT = 0.2
const DIST_BETWEEN_ROOTS = 2.0

#those are setup by the rootmanager before entering the scene.
var start_position:Vector3
var end_position:Vector3


var ROOT = preload("res://resources/meshes/root_1.tscn")

func _ready():
	
	start_position.y = 0
	end_position.y = 0 #just in case
	
	var len:float = start_position.distance_to(end_position)
	
	var n:int = floor(len / DIST_BETWEEN_ROOTS)
	for i in n:
		var pos:= start_position.move_toward(end_position, DIST_BETWEEN_ROOTS * (i+1))
		
		await spawn_root(pos)
	

func destroy_root():
	for i in get_children():
		var tween = get_tree().create_tween()
		tween.tween_property(i, "position", Vector3(0, -5, 0), TIME_TO_GROW_ONE_ROOT/2.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	
		tween.play()
		await tween.finished
		
	queue_free() #works strangely (?)


var last_rand :=  0.0; #used for visual consistency 
func spawn_root(pos:Vector3):
	
	var root = ROOT.instantiate() as Node3D
	add_child(root)
	root.position  = pos
	
	root.look_at(end_position)
	
	#introduce some random
	
	root.position.x += last_rand
	var new_rand := randf_range(-0.4, 0.4)
	root.rotate_y(new_rand)
	last_rand = new_rand
	root.scale = Vector3(randf_range(0.9, 1.1), randf_range(0.9, 1.1), randf_range(0.9, 1.1))
	
	
	var mesh = root.get_child(0) as Node3D #dirty but fuck it

	var tween = get_tree().create_tween()
	tween.tween_property(mesh, "position", Vector3.ZERO, TIME_TO_GROW_ONE_ROOT).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	#tween.tween_property(mesh, "rotation.x", 90.0, TIME_TO_GROW_ONE_ROOT)
	
	tween.play()
	await tween.finished
