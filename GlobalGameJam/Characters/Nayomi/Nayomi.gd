extends StaticBody

var queued = false

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		body.pointing_to = self

func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		body.pointing_to = null
		
func pointing_started():
	$Pointer.visible = true
	
func pointing_ended():
	$Pointer.visible = false
	
func pointing_selected():
	var textbox = get_tree().get_nodes_in_group("textbox")[0]
	if not textbox.is_active() and not queued:
		if not EventHandler.checklist.nayomi_intro:
			textbox.play_from_json("Dialogue/nayomi_intro.json")
			get_tree().get_nodes_in_group("player")[0].input_disabled = true
			queued = true
			yield(textbox, "dialogue_finished")
			get_tree().get_nodes_in_group("player_fade")[0].blink()
			yield(get_tree().create_timer(1.0), "timeout")
			queue_free()
			EventHandler.checklist.nayomi_intro = true
		elif not EventHandler.checklist.nayomi_hammer:
			textbox.play_from_json("Dialogue/nayomi_hammer.json")
			get_tree().get_nodes_in_group("player")[0].input_disabled = true
			yield(textbox, "dialogue_finished")
			EventHandler.checklist["items"].append("hammer")
			EventHandler.update_items()
			EventHandler.checklist.nayomi_hammer = true
		elif not EventHandler.checklist.nayomi_apples:
			if EventHandler.checklist.alex_intro:
				textbox.play_from_json("Dialogue/nayomi_apples.json")
				get_tree().get_nodes_in_group("player")[0].input_disabled = true
				yield(textbox, "dialogue_finished")
				EventHandler.checklist.nayomi_apples = true
		elif not EventHandler.checklist.nayomi_frame:
			if EventHandler.checklist.alex_apples:
				textbox.play_from_json("Dialogue/nayomi_frame.json")
				get_tree().get_nodes_in_group("player")[0].input_disabled = true
				yield(textbox, "dialogue_finished")
				EventHandler.checklist.nayomi_frame = true
		elif not EventHandler.checklist.nayomi_screws:
			if EventHandler.checklist.alex_apples:
				textbox.play_from_json("Dialogue/nayomi_screws.json")
				get_tree().get_nodes_in_group("player")[0].input_disabled = true
				yield(textbox, "dialogue_finished")
				EventHandler.checklist.nayomi_screws = true
				EventHandler.checklist["items"].append("screws")
				
		$Pointer.visible = false
