extends CanvasLayer

@onready var hearts_label: Label = $HeartsLabel

func _process(_delta: float) -> void:
	hearts_label.text = "Vies : " + "❤️".repeat(GameState.lives)
