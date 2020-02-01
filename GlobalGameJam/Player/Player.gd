extends KinematicBody

const GRAVITY: int = 10
const MOVESPEED: int = 15

var velocity: Vector3

onready var camera: Camera = $Camera

func _physics_process(delta: float) -> void:
	velocity.y -= GRAVITY * delta
	
	var move_input: Vector2
	move_input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	move_input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	move_input = move_input.normalized()
	
	velocity.x = move_input.x * MOVESPEED
	velocity.z = move_input.y * MOVESPEED
	
	camera.look_at(translation, Vector3.UP)
	
	velocity = move_and_slide(velocity, Vector3.UP)
