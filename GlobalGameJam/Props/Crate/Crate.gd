tool
extends Spatial

export var open: bool = false setget set_open

func _ready():
	set_open(EventHandler.checklist.box_opened)

func set_open(br: bool) -> void:
	open = br
	
	$CSGCombiner/CSGBox3.visible = not open
	$CSGCombiner/CSGBox4.visible = not open
	$Requirements.visible = false
	
func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		if not open and EventHandler.checklist.will_intro:
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
			
	self.open = true
	EventHandler.checklist.box_opened = true
