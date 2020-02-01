extends Camera

var angle: float = 0

func _process(delta):
	angle += delta
	
	translation = Vector3(2, 0.25, 2) * Vector3(cos(angle), sin(angle), sin(angle))
	look_at(Vector3(), Vector3.UP)
