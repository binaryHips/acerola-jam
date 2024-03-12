extends Node3D

#const place_plant = preload("res://ressources/sound/place_plant.mp3")
#const place_animal = preload("res://ressources/sound/place_animal.mp3")
const RAY_DIST := 50
var velocity := Vector3(0, 0, 0)

var zoom_velocity := 0.0
var rotate_velocity := 0.0

const MAX_DIST = 950
var moving:=false
var last_pos:Vector3

var zoom_acc := 0.1

@export var is_active := false:
	set(v):
		if v:
			$Path/PathFollow/Camera.make_current()
		else:
			$Path/PathFollow/Camera.clear_current()
		
		is_active = v
		
		visible = v
		$UI.visible = v



@onready var camera =  $Path/PathFollow/Camera

var new_pos #contains mouse pos

var last_screen_pos:Vector2



func _ready():
	Gamemaster.player = self

var can_place_plant := true
func handle_cursor():
	
	if not Gamemaster.is_in_range_from_plants($cursor.global_position):
		$cursor/Sprite3D.modulate = Color.YELLOW
		can_place_plant = false
	
	elif is_cursor_space_occupied():
		$cursor/Sprite3D.modulate = Color.DARK_RED
		can_place_plant = false
		
		print("bodies: ", $cursor/Area3D.get_overlapping_bodies())
		print("areas: ", $cursor/Area3D.get_overlapping_areas())
	else:
		$cursor/Sprite3D.modulate = Color.WHITE
		can_place_plant = true

func _physics_process(delta):
	
	handle_cursor()
	
	if !is_active: return
	
	new_pos = get_3d_mouse_pos()
	
	if new_pos != Vector3.INF:
		$cursor.global_position = new_pos
	if moving && new_pos != Vector3.INF:
		
		last_screen_pos = camera.get_viewport().get_mouse_position()
		
		if (last_pos - new_pos).length_squared() > 0.05:
			velocity += (last_pos - new_pos)
		
		last_pos = get_3d_mouse_pos()
	
	if abs(zoom_velocity) >= 0.05:
		$Path/PathFollow.progress_ratio = clamp($Path/PathFollow.progress_ratio + zoom_velocity / 10.0 , 0.1, 0.9)
		zoom_velocity = move_toward(zoom_velocity, 0.0, delta * 1.0)
	
	if abs(rotate_velocity) >= 0.05:
		rotate_y(rotate_velocity/10.0)
		rotate_velocity = move_toward(rotate_velocity, 0.0, delta * 10.0)
	
	
	velocity = velocity.move_toward(Vector3.ZERO, delta * 5.0)
	#transform.origin = lerp(transform.origin, transform.origin+velocity, 0.5)
	transform.origin = transform.origin+velocity
	global_transform.origin.x = clamp(global_transform.origin.x, -MAX_DIST, MAX_DIST)
	global_transform.origin.z = clamp(global_transform.origin.z, -MAX_DIST, MAX_DIST)
	global_transform.origin.y = 0
	
func _unhandled_input(event):
	if !is_active: return
	if event.is_action_pressed("move_camera"):
		
		var newpos = get_3d_mouse_pos()
		if newpos != Vector3.INF:
			last_pos = newpos
			last_screen_pos = camera.get_viewport().get_mouse_position()
			moving = true
			
		
	if event.is_action_released("move_camera"):
		moving = false
		
	if event is InputEventMouseMotion && Input.is_action_pressed("rotate_camera"):
		rotate_velocity += event.relative.x/100.0 #in pixels so it's much higher than needed
	
	if event.is_action_pressed("unzoom"):
		zoom_velocity -= zoom_acc
	
	if event.is_action_pressed("zoom"):
		zoom_velocity += zoom_acc
	
	
	if event.is_action_pressed("interact") && new_pos != null:
		
		if get_tree().paused: return
		
		if ResourcesManager.selected_shop_item != null:
			ResourcesManager.try_buy()
		
		#if Invocables.buy(
			#new_pos
		#):
			#if GameMaster.animal_selected:
				#play_sound(place_animal)
			#else:
				#play_sound(place_plant)



func get_3d_mouse_pos() -> Vector3:
	var mouse_coords = camera.get_viewport().get_mouse_position()
	
	var from = camera.project_ray_origin(mouse_coords)
	var to = from + camera.project_ray_normal(mouse_coords) * (RAY_DIST + RAY_DIST * $Path/PathFollow.progress_ratio)
	var space = get_world_3d().direct_space_state
	
	var params = PhysicsRayQueryParameters3D.new()
	
	params.from = from
	params.to = to
	params.exclude = []
	params.collision_mask = 2 #32768 ?
	
	var intersection = space.intersect_ray(params)
	if intersection:
		return intersection["position"]
	else:
		return Vector3.INF

func is_cursor_space_occupied():
	return ($cursor/Area3D.has_overlapping_bodies()
	|| $cursor/Area3D.has_overlapping_bodies()
	)

func play_sound(sound):
	$cursor.get_node("audio").stream = sound
	$cursor.get_node("audio").play()
