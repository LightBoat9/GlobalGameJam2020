extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	if not EventHandler.checklist.alex_apples:
		$FramesFix.queue_free()
