extends Node3D


#booo duplicated code
enum TEAM {plants, humans}




func _on_shooting_range_body_entered(body):
	if body.team == TEAM.plants && body.DAMAGE: #collision layer should be enough to discriminate but just in case
		body.DAMAGE *= 2.0



func _on_shooting_range_body_exited(body):
	if body.team == TEAM.plants:
		body.DAMAGE /= 2.0
