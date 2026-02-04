extends Area2D

@export var win_scene_path: String = "res://Scene/win_screen.tscn" # adapte le chemin

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# On ne réagit que si c'est le joueur
	if not body.has_method("die"):
		return

	if GameState.honey_count >= GameState.target_honey:
		# victoire
		get_tree().call_deferred("change_scene_to_file", win_scene_path)
	else:
		# message "il manque du miel"
		var hud = get_tree().current_scene.get_node_or_null("HUD")
		if hud and hud.has_method("show_message"):
			hud.show_message("Il te manque des pots de miel ! (%d/%d)" % [GameState.honey_count, GameState.target_honey])

	# ✅ victoire
	if GameState.has_golden_ticket:
		get_tree().change_scene_to_file("res://Scene/win_ticket.tscn")
	else:
		get_tree().change_scene_to_file("res://Scene/win_normal.tscn")
