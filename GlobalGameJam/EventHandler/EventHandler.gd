extends Node

# Be false by default
const DEFAULT_CHECKLIST = {
	"intro": false,
	"mailbox_fixed": false,
	"bed_fixed": false,
	"nayomi_intro": false,
}

const ItemTextures = {
	"hammer": preload("res://Items/Hammer/Hammer.png"),
	"nails": preload("res://Items/Nails/Nails.png")
}

var checklist = DEFAULT_CHECKLIST

export var items: PoolStringArray = ["hammer", "nails"] setget set_items
var current_item: int = 0 setget set_current_item

func _enter_tree():
	var dir = Directory.new()
	delete_save()
	var file = File.new()
	if dir.file_exists("ggj_save.sav"):
		file.open("ggj_save.sav", File.READ)
		checklist = parse_json(file.get_as_text())
	else:
		file.open("ggj_save.sav", File.WRITE)
		file.store_string(JSON.print(checklist))
	file.close()
		
func save_game():
	var file = File.new()
	file.open("ggj_save.sav", File.WRITE)
	file.store_string(JSON.print(checklist))
	file.close()
	
func delete_save():
	var dir = Directory.new()
	if dir.file_exists("ggj_save.sav"):
		dir.remove("ggj_save.sav")

func set_player_position(pos: Vector3):
	get_tree().get_nodes_in_group("player")[0].translation = pos
	
func set_items(arr: PoolStringArray) -> void:
	items = arr
	
func set_current_item(to: int) -> void:
	if to >= items.size():
		current_item = 0
	else:
		current_item = to
		
	if items.size() > 0:
		get_tree().get_nodes_in_group("item_texture")[0].texture = EventHandler.ItemTextures[items[current_item]]
		get_tree().get_nodes_in_group("player_item_texture")[0].texture = EventHandler.ItemTextures[items[current_item]]
