extends ColorRect

onready var mod_init = modulate
onready var mod_init_a = Color(mod_init.r, mod_init.g, mod_init.b, 0)

func _ready():
	visible = true
	fade_in()

func fade_in():
	$Tween.interpolate_property(self, "modulate", mod_init, mod_init_a, 1)
	$Tween.start()
	
func fade_out():
	$Tween.interpolate_property(self, "modulate", mod_init_a, mod_init, 1)
	$Tween.start()

func blink():
	$Tween.interpolate_property(self, "modulate", mod_init_a, mod_init, 1)
	$Tween.interpolate_property(self, "modulate", mod_init, mod_init_a, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1)
	$Tween.start()
