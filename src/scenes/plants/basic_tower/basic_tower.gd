extends Node3D


#booo duplicated code
enum TEAM {plants, humans}

const DAMAGE := 20.0

var target
@onready var tower = $turret/tower
func _ready():
	find_new_target()

func _physics_process(delta):
	if is_instance_valid(target):
		tower.look_at(target.global_position, Vector3.UP, true)
		tower.rotate_y(PI/2) #because idk what to rotate to make it line up lol

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
		$AudioStreamPlayer3D.play()
		tower.get_node("particles").emitting = true
		target.damage(DAMAGE)
