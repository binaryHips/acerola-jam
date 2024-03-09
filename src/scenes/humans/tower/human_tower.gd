extends Node3D

#booo duplicated code
@onready var tower = $tower/human_tower_head

enum TEAM {plants, humans}

const DAMAGE := 50.0

var target

func _ready():
	shoot.call_deferred()

func _physics_process(delta):
	
	tower.position.y = 4.565 + sin(Time.get_ticks_msec()/800.0)/5.0
	
	if is_instance_valid(target):
		tower.look_at(target.global_position, Vector3.UP, true)

func _on_shooting_range_body_entered(body):
	
	shoot()

func find_new_target():
	
	for k in $shooting_range.get_overlapping_areas():
		
		if k.team == TEAM.plants:
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
