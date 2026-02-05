extends Node

@onready var bgm: AudioStreamPlayer = $BGM

func _ready() -> void:
	bgm.bus = "Music"
	bgm.play()
