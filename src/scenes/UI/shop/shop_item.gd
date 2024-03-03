extends Control

@export var item_name:String = ""
@export var scene:PackedScene 
@export var price: Vector3i;

@export var img:ImageTexture;


# Called when the node enters the scene tree for the first time.
func _ready():
	if img:
		$TextureButton.texture_normal = img
	$RichTextLabel.text = "[center]" + item_name
	
	ResourcesManager.selected_changed.connect(
		func (selected):
			if selected != self: $TextureRect.hide()
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass






func _on_texture_button_pressed():
	ResourcesManager.selected_shop_item = self
	$TextureRect.show()
