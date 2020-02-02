extends Spatial

func _ready():
	if not EventHandler.checklist.intro:
		EventHandler.checklist.intro = true
		var textbox = get_tree().get_nodes_in_group("textbox")[0]
		textbox.play_from_json("Dialogue/intro.json")
		
	if EventHandler.checklist.nayomi_intro:
		$Nayomi.queue_free()
		
	if not EventHandler.checklist.nayomi_hammer:
		$Will.queue_free()
		$Crate.queue_free()
		
	if not EventHandler.checklist.mailbox_fixed or EventHandler.checklist.maz_intro:
		$Maz.queue_free()
		
	if EventHandler.checklist.alex_apples:
		$Alex.queue_free()
		
	if EventHandler.checklist.will_nails:
		$Will.queue_free()
