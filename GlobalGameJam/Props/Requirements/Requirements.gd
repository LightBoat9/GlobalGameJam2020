extends Spatial

const MODAL = preload("res://Props/Requirements/Modal.tscn")

export var list: PoolStringArray setget set_list

func set_list(to: PoolStringArray) -> void:
	list = to
	for x in range(list.size()):
		var inst = MODAL.instance()
		inst.set_texture(EventHandler.ItemTextures[list[x]])
		inst.translation.x = (-1 * (list.size()-1)) + (2 * x)
		$Modals.add_child(inst)
