extends Node3D


#booo duplicated code
enum TEAM {plants, humans}

const DAMAGE := 20.0

var target

func _ready():
	find_new_target()

func _on_shooting_range_body_entered(body):
	
	shoot()

func find_new_target():
	
	
	for k in $shooting_range.get_overlapping_areas():
		if k.team == TEAM.humans:
			if (
				(not target)
				or 
				( target && target.global_position.distance_to(global_position) > k.global_position.distance_to(global_position))
				): #change if no previous target or if this one is closer.
				
				target = k

func shoot():
	find_new_target()

	if is_instance_valid(target): #just in case the bro is dead already
		
		#play shooting animation
		print("SHOOT")
		target.damage(DAMAGE)
