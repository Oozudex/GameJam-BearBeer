extends Node

var honey_count: int = 0
var target_honey: int = 5

var lives_max: int = 3
var lives: int = 3

var has_golden_ticket: bool = false

func reset() -> void:
	honey_count = 0
	has_golden_ticket = false
	
func reset_run() -> void:
	# Reset complet quand on relance une "partie"
	honey_count = 0
	lives = lives_max
	
func reset_level_only() -> void:
	# Reset quand on meurt mais qu'on continue
	honey_count = 0

func add_honey(amount: int = 1) -> void:
	honey_count = clamp(honey_count + amount, 0, target_honey)

func add_ticket() -> void:
	has_golden_ticket = true

func lose_life() -> void:
	lives = max(lives - 1, 0)

func is_game_over() -> bool:
	return lives <= 0
