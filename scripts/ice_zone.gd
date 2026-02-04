extends Area2D

@export var ice_control: float = 0.1 # 0.2 = contrôle très faible (ça glisse)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("set_ice_control"):
		body.set_ice_control(ice_control)


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("set_ice_control"):
		body.set_ice_control(1.0)
