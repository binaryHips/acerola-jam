extends CharacterBody3D

const SHOOT_RANGE = 9.0
const DAMAGE := 10.0
enum TEAM {plants, humans}

var movement_speed: float = 3.5
var movement_target_position: Vector3 = Vector3(-3.0,0.0,2.0)
var team := TEAM.humans


var target:Node3D

func _ready():
	pass

func _physics_process(delta):
	look_at(global_position+velocity) # 9 hours left
	rotate_y(PI/2.0)


func find_new_target():
	if not is_instance_valid(target): target = null
	
	
	for k in $detection_range.get_overlapping_areas():
		
		if k.team == TEAM.plants:
			if (
				(not target)
				or 
				( target && target.global_position.distance_to(global_position) > k.global_position.distance_to(global_position))
				): #change if no previous target or if this one is closer.
				
				target = k

func _on_action_timer_timeout():
	find_new_target()
	if is_instance_valid(target):
		
		$AI_agent.run_to_target(target)
		
		if target.global_position.distance_squared_to(global_position) < SHOOT_RANGE**2:
			shoot()
	else:
		target = Gamemaster.nexus.get_parent().get_node("hitbox") #nexus is the ward!
		$AI_agent.run_for_enemy_base()
		

func shoot():
	target.damage(DAMAGE)
	$AudioStreamPlayer3D.play()
	$particles.emitting = true
