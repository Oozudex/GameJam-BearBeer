extends Area2D

func _ready() -> void:
	print("ForestZone READY")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.has_method("set_meter_mode"):
		return

	body.set_meter_mode(body.MeterMode.ALCOHOL)

	# Effet caméra léger à l'entrée de la forêt
	if body.has_method("forest_camera_effect"):
		body.forest_camera_effect()

	# Message UNE SEULE FOIS si trop ivre
	if body.alc >= body.alc_max and not body.forest_warning_shown:
		var hud = get_tree().current_scene.get_node_or_null("HUD")
		if hud and hud.has_method("show_message"):
			hud.show_message("⚠️ Tu as trop bu ! Mange du poisson pour aller mieux 🐟", 4.0)
		body.forest_warning_shown = true
