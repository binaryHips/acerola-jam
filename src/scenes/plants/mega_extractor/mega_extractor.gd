extends Node3D







func _on_timer_timeout():
	if $Ward.is_linked_to_base:
		for i in $Area3D.get_overlapping_areas():
			if i.is_in_group("resource"):
				
				i.extract()
