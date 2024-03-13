extends Node

#player ref
var player

#plant nexus
var nexus

#human tank
var tank

#roots manager
var roots_manager

#UI root
var UI

@onready var world = get_tree().get_first_node_in_group("world") #TODO change this when possible

var wards:Array[Ward] = []

var connections:Dictionary = {}

var linked:Array[Ward] = [nexus]

var max_connected_wards:int = 10


var n_crawlers:int = 0

func add_ward(ward:Ward):
	wards.append(ward)

	connections[ward] = []
	
	
	for w in wards:
		if ward != w && can_connect(w, ward):
			connections[ward].append(w)
			connections[w].append(ward)
			
			#print("connecté: ", w.tag, " - ", ward.tag)
	
	recompute_connexity()

#TODO the visual link between plants will be handled totally separately. Just have to connect to it later.
func remove_ward(ward:Ward):
	wards.erase(ward)
	
	roots_manager.remove_connections(ward)
	for c in connections.keys():
		
		if ward in connections[c]:
			connections[c].erase(ward)
	
	recompute_connexity()

func can_connect(w1:Ward, w2:Ward) -> bool:
	var dist := w1.global_position.distance_to(w2.global_position)
	return dist <= max(w1.range, w2.range)

func get_closest_connected(ward) -> Ward:
	
	var dist:float = INF
	var candidate:Ward
	
	for w in connections[ward]:
		if w.is_linked_to_base && ward.global_position.distance_squared_to(w.global_position) < dist**2:
			dist = ward.global_position.distance_squared_to(w.global_position)
			candidate = w
	return candidate

func get_closest_in(ward, array) -> Ward:
	
	var dist:float = INF
	var candidate:Ward
	
	for w in connections[ward]:
		if w != ward && w in array && ward.global_position.distance_squared_to(w.global_position) < dist**2:
			dist = ward.global_position.distance_squared_to(w.global_position)
			candidate = w
	return candidate

func is_in_range_from_plants(position:Vector3) -> bool:
	
	for w in linked:
		if w.global_position.distance_to(position) <= w.range:
			return true
	return false


func recompute_connexity():
	
	if not nexus: return
	
	var stack := [nexus]
	linked = [] #recompute linked


	var not_visited:Array[Ward] = wards.duplicate()
	for m in max_connected_wards:
		if stack == []: break
		var ward = stack.pop_front()
		
		
		for i in connections[ward]:
			if not (i in stack) && (i in not_visited):
				stack.append(i)
		
		not_visited.erase(ward)
		ward.is_linked_to_base = true
		linked.append(ward)
	
	for w in not_visited:
		w.is_linked_to_base = false
		roots_manager.remove_connections(w)
	
	
	#second pass for roots.
	var visited = [nexus]
	
	linked.sort_custom(
		func (a:Ward, b:Ward):
			
			return a.global_position.distance_squared_to(nexus.position) >  b.global_position.distance_squared_to(nexus.position)
	)
	
	for ward in linked:
		if connections[ward] == []: continue #fixes a first-frame problem. it's 2am and idc anymore
		
		for w in connections[ward]:
			
			if not w in visited:
				roots_manager.add_connection(get_closest_in(w, visited), w)
				visited.append(w)
		
		#debug
		#(ward.get_parent().get_node("MeshInstance3D") as MeshInstance3D).material_override = preload("res://resources/materials/envrionment/mutagen.tres")
		#await get_tree().create_timer(2.0).timeout
# Called when the node enters the scene tree for the first time.

func fade_to_black(time):
	
	var tween = get_tree().create_tween()
	tween.tween_property(fade, "color", Color(0, 0, 0, 1), time)
	tween.play()
	await tween.finished
	return

func fade_from_black(time):
	
	var tween = get_tree().create_tween()
	tween.tween_property(fade, "color", Color(0, 0, 0, 0), time)
	tween.play()
	await tween.finished
	return


var has_game_started := false
signal game_started

var fade: ColorRect
func _ready():
	fade = ColorRect.new()
	Control
	fade.color = Color.BLACK
	fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	fade.mouse_filter =Control.MOUSE_FILTER_IGNORE
	get_parent().get_node("main").add_child(fade) #dirty
	
	var audio:AudioStreamPlayer = get_parent().get_node("main").get_node("general_player_1") as AudioStreamPlayer
	
	audio.stream = preload("res://resources/sound/intro/intro_pad.mp3")
	audio.volume_db = -80
	audio.play()
	var tween = get_tree().create_tween()
	tween.tween_property(audio, "volume_db", -30, 1.5)
	tween.play()
	
	fade_from_black(1.5)

func game_won():
	print("WON")
	fade_to_black(3.0)

func game_lost():
	print("LOST")
	fade_to_black(3.0)
