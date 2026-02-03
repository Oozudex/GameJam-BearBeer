extends Area2D

@export var ice_control: float = 0.2 # 0.2 = contrôle très faible (ça glisse)


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	print("bodyshape") # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	print("bodyenter") # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	print("body exit") # Replace with function body.
