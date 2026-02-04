extends Area2D

@export var honey_value: int = 1

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_temp"): # petite astuce: ton Player a déjà add_temp -> ça l'identifie
		GameState.add_honey(honey_value)
		print("Miel:", GameState.honey_count, "/", GameState.target_honey)
		queue_free()
