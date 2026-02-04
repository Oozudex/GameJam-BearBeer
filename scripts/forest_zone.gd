extends Area2D

func _ready() -> void:
	body_entered.connect(_on_enter)

func _on_enter(body: Node2D) -> void:
	if body.has_method("set_meter_mode"):
		body.set_meter_mode(body.MeterMode.ALCOHOL)
