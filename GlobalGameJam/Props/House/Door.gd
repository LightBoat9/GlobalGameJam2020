extends Sprite3D

export var next_scene: String
export var player_pos: Vector3
export var checklist_req: PoolStringArray

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
	
func events_met() -> bool:
	for e in checklist_req:
		if not EventHandler.checklist[e]:
			return false
			
	return true
	
func pointing_selected():
	if checklist_req.empty() or events_met():
		get_tree().get_nodes_in_group("player_fade")[0].fade_out()
		get_tree().get_nodes_in_group("player")[0].input_disabled = true
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().change_scene(next_scene)
		EventHandler.call_deferred("set_player_position", player_pos)
	else:
		var textbox = get_tree().get_nodes_in_group("textbox")[0]
		textbox.play_from_json("Dialogue/nayomi_intro_first.json")
