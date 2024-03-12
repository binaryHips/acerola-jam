extends Node3D


#booo duplicated code
enum TEAM {plants, humans}

const DAMAGE := 2


func _on_timer_timeout():

	for t in $shooting_range.get_overlapping_areas():
		if t.team == TEAM.humans:
			t.damage(DAMAGE)
			$CPUParticles3D.emitting = true
			if not $AudioStreamPlayer3D.playing:
				$AudioStreamPlayer3D.play()
