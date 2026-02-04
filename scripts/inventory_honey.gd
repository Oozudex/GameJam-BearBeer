extends Control

@onready var count_label: Label = $TextureRect/CountLabel

func set_count(current: int, target: int) -> void:
	count_label.text = "%d/%d" % [current, target]
