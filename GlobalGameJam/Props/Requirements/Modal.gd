extends Spatial

func set_texture(tex: Texture):
	$Tool.texture = tex

func _enter_tree():
	scale = Vector3(0.5, 0.5, 0.5)
