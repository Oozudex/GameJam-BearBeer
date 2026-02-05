extends Node

@onready var bgm: AudioStreamPlayer = $BGM

func _ready() -> void:
	# IMPORTANT en Web: pas d'autoplay, on attend une interaction
	# Donc on ne play pas ici.
	pass

func play_bgm() -> void:
	if not bgm:
		return
	if not bgm.playing:
		bgm.play()

func stop_bgm() -> void:
	if bgm and bgm.playing:
		bgm.stop()
