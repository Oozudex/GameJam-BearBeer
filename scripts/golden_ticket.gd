extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# on check le joueur via une méthode que ton player a déjà
	if body.has_method("eat_food") or body.has_method("drink_beer"):
		GameState.has_golden_ticket = true
		queue_free()
