extends Control

@export var bar_path: NodePath
@export var label_path: NodePath

@onready var bar: TextureProgressBar = get_node(bar_path) as TextureProgressBar
@onready var label: Label = get_node(label_path) as Label

@export var cold_progress_texture: Texture2D
@export var alcohol_progress_texture: Texture2D


func set_mode(mode: String) -> void:
	if mode == "COLD":
		if cold_progress_texture:
			bar.texture_progress = cold_progress_texture
	else:
		if alcohol_progress_texture:
			bar.texture_progress = alcohol_progress_texture


func set_value(current: int, max_value: int) -> void:
	if not bar or not label:
		return
	bar.max_value = max_value
	bar.value = current
	label.text = "%d/%d" % [current, max_value]
