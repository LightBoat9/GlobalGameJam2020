extends Node

# Be false by default
const DEFAULT_CHECKLIST = {
	"items": [],
	"mailbox_fixed": false,
	"bed_fixed": false,
	"sink_fixed": false,
	"intro": false,
	"nayomi_intro": false,
	"nayomi_hammer": false,
	"will_intro": false,
	"will_nails": false,
	"box_opened": false,
	"nayomi_apples": false,
	"apples_picked": false,
	"alex_intro": false,
	"alex_apples": false,
	"nayomi_frame": false,
	"frame_hung": false,
	"nayomi_screws": false,
	"maz_intro": false,
}

const ItemTextures = {
	"hammer": preload("res://Items/Hammer/Hammer.png"),
	"nails": preload("res://Items/Nails/Nails.png"),
	"drill": preload("res://Items/Drill/Drill.png"),
	"screws": preload("res://Items/Screws/Screws.png"),
	"apples": preload("res://Items/Apples/Apples.png"),
	"wrench": preload("res://Items/Wrench/Wrench.png")
}

var checklist = DEFAULT_CHECKLIST

var current_item: int = 0 setget set_current_item

func _process(delta):
	if checklist.sink_fixed and checklist.mailbox_fixed and checklist.bed_fixed:
		set_process(false)
		get_tree().get_nodes_in_group("player_fade")[0].fade_out()
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().change_scene("res://GUI/EndScreen/EndScreen.tscn")

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
	
func update_items():
	if current_item >= checklist["items"].size():
		current_item = 0
		
	if checklist["items"].size() > 0:
		get_tree().get_nodes_in_group("item_texture")[0].texture = EventHandler.ItemTextures[checklist["items"][current_item]]
		get_tree().get_nodes_in_group("player_item_texture")[0].texture = EventHandler.ItemTextures[checklist["items"][current_item]]
	
func set_current_item(to: int) -> void:
	if to >= checklist["items"].size():
		current_item = 0
	else:
		current_item = to
		
	update_items()
