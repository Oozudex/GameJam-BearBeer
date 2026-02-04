extends CanvasLayer

func _ready() -> void:
	get_tree().paused = true

func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	GameState.reset_run()
	get_tree().change_scene_to_file("res://Scene/game.tscn") # adapte

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	GameState.reset_run()
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn") # adapte
