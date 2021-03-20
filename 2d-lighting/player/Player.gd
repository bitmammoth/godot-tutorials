class_name Player
extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 120
export var GRAVITY = 2550.5

enum {
	MOVE
}

onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

var velocity = Vector2.ZERO
var last_direction = Vector2.ZERO
var state = MOVE
var default_speed = 1

func _physics_process(delta):
	match state:
		MOVE:	
			move_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		last_direction = input_vector
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = Vector2.ZERO
	animation_tree.set("parameters/Idle/blend_position", last_direction.normalized())
	animation_tree.set("parameters/Run/blend_position", last_direction.normalized())
	if velocity != Vector2.ZERO:
		animation_state.travel("Run")
	else:
		animation_state.travel("Idle")
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity)

