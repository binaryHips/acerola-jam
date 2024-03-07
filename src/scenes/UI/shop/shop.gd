extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_resources_pressed():
	$resources_plants.show()
	$attack_plants.hide()
	$defense_plants.hide()


func _on_defense_pressed():
	$resources_plants.hide()
	$defense_plants.show()
	$attack_plants.hide()

func _on_attack_pressed():
	$resources_plants.hide()
	$defense_plants.hide()
	$attack_plants.show()
