extends CharacterBody3D

const SHOOT_RANGE = 2.0
var DAMAGE := 5.0
enum TEAM {plants, humans}

var movement_speed: float = 6.0
var movement_target_position: Vector3 = Vector3(0.0,0.0,-20000.0) #just makes them go forward for a tiny bit
var team := TEAM.plants


var target:Node3D

func _ready():
	spawn.call_deferred()

func spawn():
	#$AI_agent.set_movement_target(global_position + Vector3.FORWARD * 4)

	#await $AI_agent.target_reached
	pass
	#$Action_timer.start()

func _physics_process(delta):
	pass
	
	
#TODO priorize targets that can attack
func find_new_target():
	if not is_instance_valid(target): target = null
	
	
	for k in $detection_range.get_overlapping_areas():
		
		if k.team == TEAM.humans:
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
		$AI_agent.run_for_enemy_base()
		

func shoot():
	target.damage(DAMAGE)
