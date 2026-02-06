extends Area2D

@export var temp_gain: int = 10
@onready var pickup_sfx: AudioStreamPlayer2D = $PickupSFX

var taken := false

func _on_body_entered(body: Node2D) -> void:
	if taken:
		return
	taken = true

	# Gameplay
	if body.has_method("drink_beer"):
		body.drink_beer(temp_gain)

	# Son + disparition propre
	if pickup_sfx and pickup_sfx.stream:
		pickup_sfx.play()

	hide()
	$CollisionShape2D.set_deferred("disabled", true)

	# Attendre la fin du son (si tu veux)
	if pickup_sfx and pickup_sfx.stream:
		await pickup_sfx.finished

	queue_free()
