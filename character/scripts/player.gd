extends CharacterBody2D

@export var speed := 35
@export var animation_tree : AnimationTree

var input
var playback : AnimationNodeStateMachinePlayback

func _ready():
	playback = animation_tree["parameters/playback"]

func _physics_process(_delta: float) -> void:
	input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input != Vector2.ZERO:
		velocity = input * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	select_animation()
	update_animation_parameters()

func select_animation():
	if velocity == Vector2.ZERO:
		playback.travel("Idle")
	else:
		playback.travel("Walk")

func update_animation_parameters():
	if input == Vector2.ZERO:
		return

	animation_tree["parameters/Idle/blend_position"] = input
	animation_tree["parameters/Walk/blend_position"] = input
