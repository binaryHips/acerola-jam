extends Node3D

@export var start_time_sec:int = 100
@export var time_between_spawns:float = 30


@export var violence:float = 1
@export var violence_progression_fac = 1.1

@export var number_of_simultaneous_spawns:int = 3

const SOLDIER = preload("res://src/scenes/humans/soldier/soldier.tscn")

func _ready():
	$Timer.wait_time = time_between_spawns
	$Timer.start()


func _on_timer_timeout():
	var time: float = Time.get_ticks_msec() / 1000.0
	
	violence *= violence_progression_fac
	
	
	if time > start_time_sec:
		for k in number_of_simultaneous_spawns + round(violence-1):
			print("SPAWNED SOLDIER")
			var soldier := SOLDIER.instantiate()
			get_tree().get_root().add_child(soldier)
			#
			soldier.global_position = global_position + Vector3.LEFT * k
