extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.has_method("die"):
		return

	# Pas assez de miel -> message
	if GameState.honey_count < GameState.target_honey:
		var hud = get_tree().current_scene.get_node_or_null("HUD")
		if hud and hud.has_method("show_message"):
			hud.show_message("Il te manque des pots de miel ! (%d/%d)" % [GameState.honey_count, GameState.target_honey])
		return

	# ✅ Victoire -> 2 win screens
	if GameState.has_golden_ticket:
		get_tree().call_deferred("change_scene_to_file", "res://Scene/win_ticket.tscn")
	else:
		get_tree().call_deferred("change_scene_to_file", "res://Scene/win_normal.tscn")
