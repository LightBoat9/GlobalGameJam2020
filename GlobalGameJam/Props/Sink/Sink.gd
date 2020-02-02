extends Spatial

export var fixed: bool = false setget set_fixed

func _ready():
	set_fixed(EventHandler.checklist.sink_fixed)

func set_fixed(br: bool) -> void:
	fixed = br
	
	$ASprite.visible = not br
	$Requirements.visible = false
	
func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		body.pointing_to = self

func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		body.pointing_to = null
		
func pointing_started():
	if not fixed:
		$Requirements.visible = true
	
func pointing_ended():
	$Requirements.visible = false
	
func pointing_selected():
	for req in $Requirements.list:
		if not req in EventHandler.checklist["items"]:
			return
			
	self.fixed = true
	EventHandler.checklist.sink_fixed = true
