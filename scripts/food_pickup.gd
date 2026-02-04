extends Area2D

@export var reduce_amount: int = 10

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("eat_food"):
		body.eat_food(reduce_amount)
	queue_free()
