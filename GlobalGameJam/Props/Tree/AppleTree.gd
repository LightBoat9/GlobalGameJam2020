tool
extends Spatial

export var picked: bool = false setget set_picked

func _ready():
	set_picked(EventHandler.checklist.apples_picked)

func set_picked(br: bool) -> void:
	picked = br
	
	$Apples.visible = not picked
	
	$Pointer.visible = false
	
func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		if not picked and EventHandler.checklist.nayomi_apples:
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
	self.picked = true
	EventHandler.checklist["items"].append("apples")
	EventHandler.checklist.apples_picked = true
