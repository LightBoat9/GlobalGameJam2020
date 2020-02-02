tool
extends Spatial

export var fixed: bool = false setget set_fixed

func _ready():
	set_fixed(EventHandler.checklist.frame_hung)

func set_fixed(br: bool) -> void:
	fixed = br
	
	$Wall.visible = not fixed
	$Ground.visible = fixed
	
func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		if EventHandler.checklist.nayomi_frame and not fixed and not EventHandler.checklist.frame_hung:
			body.pointing_to = self

func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		if body.pointing_to == self:
			body.pointing_to = null
		
func pointing_started():
	$Requirements.visible = true
	
func pointing_ended():
	$Requirements.visible = false
	
func pointing_selected():
	for req in $Requirements.list:
		if not req in EventHandler.checklist["items"]:
			return
			
	self.fixed = true
	get_tree().get_nodes_in_group("player")[0].pointing_to = null
	EventHandler.checklist.frame_hung = true
