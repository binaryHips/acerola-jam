extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	(
	func ():
		$resources.texture = ResourcesManager.resource_UI.get_node("SubViewport").get_texture()
		
	).call_deferred()
	Gamemaster.UI = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$debug_text.text = str(ResourcesManager.mutagen) + " | " +  str(ResourcesManager.metal) + " | " +  str(ResourcesManager.oil)
	$debug_text.text = str(Engine.get_frames_per_second())
	
	$maxplants.text = "[center]" + str(len(Gamemaster.linked)) + "\n" + str(Gamemaster.max_connected_wards)


func _on_help_pressed():
	get_tree().paused = $help.button_pressed
	$Help_UI.visible = $help.button_pressed
