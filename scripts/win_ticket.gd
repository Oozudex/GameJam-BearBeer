extends CanvasLayer

@onready var code_label: Label = $Overlay/Center/CodeLabel
@onready var win_sfx: AudioStreamPlayer = $WinSFX

func _ready() -> void:
	get_tree().paused = true
	code_label.text = "Code partenaire : BEAR-BEER-2025" # ton code
	
	# si ton écran met le jeu en pause, l'audio doit quand même marcher
	process_mode = Node.PROCESS_MODE_ALWAYS

	if win_sfx:
		win_sfx.play()

func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	GameState.reset_run()
	get_tree().change_scene_to_file("res://Scene/game_dev.tscn") # adapte

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	GameState.reset_run()
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn") # adapte
