extends StaticBody

var queued = false

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		if not EventHandler.checklist.will_intro or (EventHandler.checklist.box_opened and not EventHandler.checklist.will_nails):
			body.pointing_to = self

func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		if body.pointing_to == self:
			body.pointing_to = null
		
func pointing_started():
	$Pointer.visible = true
	
func pointing_ended():
	$Pointer.visible = false
	
func pointing_selected():
	var textbox = get_tree().get_nodes_in_group("textbox")[0]
	if not textbox.is_active() and not queued:
		if not EventHandler.checklist.will_intro:
			textbox.play_from_json("Dialogue/will_intro.json")
			get_tree().get_nodes_in_group("player")[0].input_disabled = true
			EventHandler.checklist.will_intro = true
			get_tree().get_nodes_in_group("player")[0].pointing_to = null
		elif not EventHandler.checklist.will_nails:
			textbox.play_from_json("Dialogue/will_nails.json")
			get_tree().get_nodes_in_group("player")[0].input_disabled = true
			queued = true
			yield(textbox, "dialogue_finished")
			get_tree().get_nodes_in_group("player_fade")[0].blink()
			yield(get_tree().create_timer(1.0), "timeout")
			queue_free()
			EventHandler.checklist["items"].append("nails")
			EventHandler.checklist.will_nails = true
