extends Control

@export var item_name:String = ""
@export var scene:PackedScene 
@export var price: Vector3i;

@export var thumbnail:Texture;
@export_multiline var desc_tooltip:String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	if thumbnail:
		$TextureButton.texture_normal = thumbnail
	$RichTextLabel.text = "[center]" + item_name
	
	$TextureButton.tooltip_text = ( #TODO use a custom popup better formatted for this.
		item_name
		+ "\n" + "Cost    MUTAGEN    METAL    OIL"
		+ "\n            " + str(price[0]) + "                   " + str(price[1]) + "              " + str(price[2])
		+ "\n\n"
	
	)
	$TextureButton.tooltip_text += "\n" + desc_tooltip

	
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
