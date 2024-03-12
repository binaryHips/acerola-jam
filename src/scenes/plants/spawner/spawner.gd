extends Node3D

const CRAWLER = preload("res://src/scenes/plants/crawler/crawler.tscn")

@export var number_by_launch := 1

func _spawn():
	for k in number_by_launch:
		add_child(CRAWLER.instantiate())
