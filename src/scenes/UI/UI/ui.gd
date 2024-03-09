extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	#(
	#func ():
		#$resources.texture = ResourcesManager.resource_UI.get_node("SubViewport").get_texture()
		#
	#).call_deferred()
	Gamemaster.UI = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$debug_text.text = str(ResourcesManager.mutagen) + " | " +  str(ResourcesManager.metal) + " | " +  str(ResourcesManager.oil)
	$debug_text.text = str(Engine.get_frames_per_second())
