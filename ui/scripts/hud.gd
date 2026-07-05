extends CanvasLayer

@onready var fps_counter := $FPS
@onready var health_bar := $HUDMargin/HealthBar
@onready var infection_meter := $HUDMargin/InfectionMeterDEBUG

func _process(_delta: float) -> void:
	health_bar.value = GameData.player_health
	infection_meter.value = GameData.infection_value
	fps_counter.text = str(Engine.get_frames_per_second())
