extends KinematicBody

const GRAVITY: int = 10
const MOVESPEED: int = 15

var velocity: Vector3
var direction: Vector2 = Vector2.ONE
var _flip: float setget set_flip
var _lean: float setget set_lean

var input_disabled: bool = false setget set_input_disabled

onready var sprite: Sprite3D = $Sprite3D
onready var camera: Camera = $Camera
onready var tween: Tween = $Tween
onready var bop_tween: Tween = $BopTween

var pointing_to: Node = null setget set_pointing_to

func _ready() -> void:
	EventHandler.current_item = EventHandler.current_item
	_start_bop()
	bop_tween.connect("tween_all_completed", self, "_on_BopTween_tween_completed")
	
	var textbox = get_tree().get_nodes_in_group("textbox")[0]
	
	textbox.connect("dialogue_finished", self, "_on_textbox_end", [textbox])
	
func _input(event):
	if not input_disabled:
		if event.is_action_pressed("ui_accept") and event.pressed:
			if pointing_to and pointing_to.has_method("pointing_selected"):
				pointing_to.pointing_selected()
		elif event.is_action_pressed("item"):
			EventHandler.current_item += 1
		elif event.is_action_pressed("ui_cancel"):
			EventHandler.save_game()
	
func _on_textbox_end(textbox):
	input_disabled = false
	
func _start_bop():
	bop_tween.interpolate_property(self, "_lean", _lean, 10, 0.5)
	bop_tween.interpolate_property(self, "_lean", 10, -10, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
	bop_tween.start()

func _physics_process(delta: float) -> void:
	update_movement(delta)
	
func update_movement(delta: float) -> void:
	velocity.y -= GRAVITY * delta
	
	var move_input: Vector2
	if not input_disabled:
		move_input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		move_input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	move_input = move_input.normalized()
	
	velocity.x = move_input.x * MOVESPEED
	velocity.z = move_input.y * MOVESPEED
	
	camera.look_at(translation, Vector3.UP)
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if move_input.x == 0 and move_input.y == 0:
		bop_tween.stop_all()
	elif not bop_tween.is_active():
		bop_tween.resume_all()
	
	if direction.y == 1 and move_input.y < 0:
		direction.y = -1
	elif direction.y == -1 and move_input.y > 0:
		direction.y = 1
		
	if direction.x == 1 and move_input.x < 0:
		direction.x = -1
		tween.interpolate_property(self, "_flip", _flip, -180, 0.3)
		tween.start()
	elif direction.x == -1 and move_input.x > 0:
		direction.x = 1
		tween.interpolate_property(self, "_flip", _flip, 0, 0.3)
		tween.start()

func set_input_disabled(to: bool) -> void:
	input_disabled = to

func set_flip(to: float) -> void:
	_flip = to
	sprite.rotation_degrees.y = _flip
	
func set_lean(to: float) -> void:
	_lean = to
	sprite.rotation_degrees.z = _lean

func _on_BopTween_tween_completed():
	_start_bop()

func set_pointing_to(pt: Node) -> void:
	if pointing_to and pointing_to.has_method("pointing_ended"):
		pointing_to.pointing_ended()
		
	pointing_to = pt
	
	if pointing_to and pointing_to.has_method("pointing_started"):
		pointing_to.pointing_started()

