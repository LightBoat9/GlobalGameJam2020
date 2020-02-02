tool
extends Spatial

export var broken: bool = true setget set_broken
export var dont_load: bool = false

func _ready():
	if not dont_load:
		set_broken(not EventHandler.checklist.bed_fixed)
	
func set_broken(br: bool) -> void:
	broken = br
	$Fixed.set_deferred("visible", not broken)
	$Broken.set_deferred("visible", broken)
	$Requirements.visible = false
	
func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		body.pointing_to = self

func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		body.pointing_to = null
		
func pointing_started():
	if broken:
		$Requirements.visible = true
	
func pointing_ended():
	$Requirements.visible = false
	
func pointing_selected():
	for req in $Requirements.list:
		if not req in EventHandler.checklist["items"]:
			return
			
	self.broken = false
	EventHandler.checklist.bed_fixed = true
