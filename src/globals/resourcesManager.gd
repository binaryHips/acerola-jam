extends Node

var mutagen:int = 20
var metal:int = 0
var oil:int = 0


var resource_UI:Node3D

func has_enough_resources(res:Vector3i):
	
	return self.mutagen >= res[0] && self.metal >= res[1] && self.oil >= res[2];
	

func add_mutagen(mutagen:int):
	self.mutagen += mutagen
	resource_UI.add_mutagen(mutagen)
	
func add_metal(metal:int):
	self.metal += metal
	resource_UI.add_metal(metal)

func add_oil(oil:int):
	self.oil += oil
	resource_UI.add_oil(oil)
	
	
func remove_resources(res:Vector3i):
	self.mutagen = max(0, self.mutagen-res[0])
	self.metal = max(0, self.metal-res[1])
	self.oil = max(0, self.oil-res[2])
	
	#update UI
	resource_UI.remove_mutagen(res[0])
	resource_UI.remove_metal(res[1])
	resource_UI.remove_oil(res[2])
	
	

signal selected_changed(selected:Control)

var selected_shop_item:Control:
	set(val):
		selected_changed.emit(val)
		selected_shop_item = val

func try_buy():
	if has_enough_resources(selected_shop_item.price):
		
		var pos = Gamemaster.player.get_3d_mouse_pos()
		
		if pos == Vector3.INF: return
		var plant:Node3D = selected_shop_item.scene.instantiate()
		
		add_child(plant) #dirty but its fine
		plant.global_position = pos
		print("bought!")
		remove_resources(selected_shop_item.price)
	else:
		print("not_bought!")
