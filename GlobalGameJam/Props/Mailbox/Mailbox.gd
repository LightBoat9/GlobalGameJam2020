tool
extends CSGCombiner

export var broken: bool = false setget set_broken

func _ready():
	set_broken(not EventHandler.checklist.mailbox_fixed)

func set_broken(br: bool) -> void:
	broken = br
	$Top.translation = Vector3(1, -2.2, 0) if br else Vector3(0, 0.4, 0)
	$Requirements.visible = false
	
func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		body.pointing_to = self

func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		body.pointing_to = null
		
func pointing_started():
	if broken:
		if EventHandler.checklist.nayomi_intro:
			$Requirements.visible = true
	
func pointing_ended():
	$Requirements.visible = false
	
func pointing_selected():
	for req in $Requirements.list:
		if not req in EventHandler.items:
			return
			
	self.broken = false
	EventHandler.checklist.mailbox_fixed = true
