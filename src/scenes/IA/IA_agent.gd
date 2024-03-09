extends NavigationAgent3D

var movement_target_position: Vector3 = Vector3(-3.0,0.0,2.0)
var team:int


@onready var body = get_parent()

func _ready():
	
	team = body.team

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(Gamemaster.nexus.global_position)

func set_movement_target(movement_target: Vector3):
	set_target_position(movement_target)

func _physics_process(delta):
	
	if distance_to_target() < target_desired_distance:
		return
	
	var current_agent_position: Vector3 = body.global_position
	var next_path_position: Vector3 = get_next_path_position()

	body.velocity = current_agent_position.direction_to(next_path_position) * body.movement_speed
	body.move_and_slide()



func run_for_enemy_base():
	
	if team == 1: #humans
		body.target = Gamemaster.nexus.get_parent().get_node("hitbox")
		set_target_position(Gamemaster.nexus.global_position)
	else: #plants
		body.target = Gamemaster.tank.get_node("hitbox")
		set_target_position(Gamemaster.tank.global_position)

func run_to_target(target:Node3D):
	
	set_target_position(target.global_position)
