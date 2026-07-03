extends CanvasLayer

@onready var close_button := $Close
@onready var lore_button := $LorePage
@onready var information_label := $InformationLabelDEBUG
@onready var lore_label := $LoreLabelDEBUG

var letter_scene := preload("res://items/Letter.tscn")

signal letter_instance_close

func _ready() -> void:
	lore_button.pressed.connect(_on_lore_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)

func _on_lore_button_pressed():
	var information_label_tween := information_label.create_tween()
	var lore_label_tween := lore_label.create_tween()

	information_label_tween.tween_property(information_label, "modulate:a", 0, 0.5)
	lore_label_tween.tween_property(lore_label, "modulate:a", 1, 0.5)

func _on_close_button_pressed():
	get_tree().paused = false
	letter_instance_close.emit()
	self.queue_free()
	
