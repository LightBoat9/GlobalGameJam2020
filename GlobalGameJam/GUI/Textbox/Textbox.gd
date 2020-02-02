extends Control

signal dialogue_finished

const SLOW_CHAR = 0.05
const FAST_CHAR = 0.01

var fast_mode: bool = false

var speaker_name: String = "Gump" setget set_speaker_name
var speaker_pic: Texture setget set_speaker_pic

var _queue: Array = []

var prep_finished: bool = false

const PICTURES: Dictionary = {
	"gump": preload("res://Player/gump_pic.tres"),
	"nayomi": preload("res://Characters/Nayomi/nayomi_pic.tres"),
	"will": preload("res://Characters/Will/Will.tres"),
	"alex": preload("res://Characters/Alex/Alex.tres"),
	"maz": preload("res://Characters/Maz/Maz.tres")
}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if $Tween.is_active() and not fast_mode:
			fast_mode = true
			$Tween.remove_all()
			var text = $Box/HBox/TextContainer/Text
			$Tween.interpolate_property(text, "percent_visible", text.percent_visible, 1, len(text.text) * FAST_CHAR)
			$Tween.start()
		elif not $Tween.is_active():
			if prep_finished:
				prep_finished = false
				visible = false
				get_tree().set_input_as_handled()
				emit_signal("dialogue_finished")
				return
			else:
				go_next()
				

			
func set_speaker_name(speaker: String) -> void:
	speaker_name = speaker
	$NameContainer/NameLabel.text = speaker
	
func set_speaker_pic(pic: Texture) -> void:
	speaker_pic = pic
	$Box/HBox/PictureContainer/Picture.texture = pic

func play_from_json(json: String) -> void:
	var file = File.new()
	json = "res://" + json
	file.open(json, File.READ)
	var text = file.get_as_text()
	var dict = {}
	dict = parse_json(text)
	file.close()
	start_queue(dict["content"])
	
func start_queue(queue: Array) -> void:
	get_tree().get_nodes_in_group("player")[0].input_disabled = true
	_queue = queue
	visible = true
	go_next()

func is_active() -> bool:
	return not _queue.empty() and not $Tween.is_active()

func go_next() -> void:
	if _queue.empty():
		return
		
	var text = $Box/HBox/TextContainer/Text
	var next: Dictionary = _queue.pop_front()
	
	if _queue.empty():
		prep_finished = true
	
	set_speaker_pic(PICTURES[next["speaker"]])
	set_speaker_name(next["speaker"])
	text.text = next["text"]
	
	$Tween.interpolate_property(text, "percent_visible", 0, 1, len(text.text) * SLOW_CHAR)
	$Tween.start()
	
	fast_mode = false
