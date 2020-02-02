extends Spatial

func _ready():
	if not EventHandler.checklist.intro:
		EventHandler.checklist.intro = true
		var textbox = get_tree().get_nodes_in_group("textbox")[0]
		textbox.play_from_json("Dialogue/intro.json")
		
	if EventHandler.checklist.nayomi_intro:
		$Nayomi.queue_free()
