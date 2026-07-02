extends CharacterBody2D

@export var speed := 75
@export var animation_tree : AnimationTree

var pause_menu := preload("res://ui/Pause_Menu.tscn")

var pause_menu_exists := false
var pause_menu_instance = null

var input
var playback : AnimationNodeStateMachinePlayback

var infection_increase_accumulator := 0.0
var infection_decrease_accumulator := 0.0

func _ready():
	GameData.player_speed = speed
	playback = animation_tree["parameters/playback"]

func _physics_process(delta: float) -> void:
	# Movement
	input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input * speed
	move_and_slide()
	select_animation()
	update_animation_parameters()
	
	# Infection
	if GameData.player_in_bunker == false and GameData.infection_value < 100.0:
		increase_infection(delta)
	elif GameData.player_in_bunker == true and GameData.infection_value != 0.0:
		decrease_infection(delta)

func decrease_infection(delta_time : float):
	infection_decrease_accumulator += delta_time
	if infection_decrease_accumulator >= 2:
		GameData.infection_value -= 1
		infection_decrease_accumulator = 0
		print(GameData.infection_value)

func increase_infection(delta_time : float):
	infection_increase_accumulator += delta_time
	if infection_increase_accumulator >= 2:
		GameData.infection_value += 1
		infection_increase_accumulator = 0
		print(GameData.infection_value)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if pause_menu_exists == false:
			pause_menu_instance = pause_menu.instantiate()
			get_tree().root.add_child(pause_menu_instance)
			pause_menu_instance.connect("pause_menu_closed", set_pause_menu)
			get_tree().paused = true
			pause_menu_exists = true

func set_pause_menu():
	pause_menu_exists = false

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
