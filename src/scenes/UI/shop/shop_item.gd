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
			if selected != self: $select_highlight.hide()
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ResourcesManager.has_enough_resources(price):
		$cantbuy_overlay.hide()
		$TextureButton.disabled = false
	else:
		$cantbuy_overlay.show()
		$TextureButton.disabled = true
		if ResourcesManager.selected_shop_item == self:
			ResourcesManager.selected_shop_item  = null






func _on_texture_button_pressed():
	ResourcesManager.selected_shop_item = self
	$select_highlight.show()
