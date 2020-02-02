extends StaticBody

onready var grass = preload("res://Props/GrassAreas/Grass.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var mesh_size = $FloorMesh.mesh.size
	for i in range(1000):
		var x = rand_range(-mesh_size.x/2, mesh_size.x/2)
		var z = rand_range(-mesh_size.z/2, mesh_size.z/2)
		var inst = grass.instance()
		add_child(inst)
		inst.translation = Vector3(x, 0.5, z)
