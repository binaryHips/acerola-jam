extends Node3D

const CRAWLER = preload("res://src/scenes/plants/crawler/crawler.tscn")

@export var number_by_launch := 1

func _spawn():
	
	if Gamemaster.n_crawlers > 40: return
	
	for k in number_by_launch:
		var c = CRAWLER.instantiate()
		c.position.x += 1
		add_child(c)

func _enter_tree():
	Gamemaster.n_incubators += 1
	
func _exit_tree():
	Gamemaster.n_incubators -= 1
