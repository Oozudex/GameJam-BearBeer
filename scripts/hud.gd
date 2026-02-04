extends CanvasLayer

@onready var honey_label: Label = $HBoxContainer/HoneyLabel
@onready var ticket_label: Label = $HBoxContainer/TicketLabel

func _process(_delta: float) -> void:
	honey_label.text = "Miel : %d/%d" % [GameState.honey_count, GameState.target_honey]
	ticket_label.text = "Ticket : ✅" if GameState.has_golden_ticket else "Ticket : ❌"
