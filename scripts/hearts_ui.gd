extends HBoxContainer

@export var full_heart: Texture2D
@export var empty_heart: Texture2D

@onready var hearts := [$Heart1, $Heart2, $Heart3]

func _ready() -> void:
	set_lives(GameState.lives) # affiche tout de suite

func set_lives(lives: int) -> void:
	for i in range(hearts.size()):
		hearts[i].texture = full_heart if i < lives else empty_heart
