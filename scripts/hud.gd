extends CanvasLayer

@onready var inventory_honey: Control = $Root/Panel/HBoxContainer/InventoryHoney

@onready var message_label: Label = $Root/MessageLabel
@onready var message_timer: Timer = $Root/MessageTimer

@onready var ticket_icon: TextureRect = $Root/Panel/HBoxContainer/TicketIcon

func _process(_delta: float) -> void:
	inventory_honey.set_count(GameState.honey_count, GameState.target_honey)
	if GameState.has_golden_ticket:
		ticket_icon.modulate = Color(1, 1, 1, 1)      # visible normal
	else:
		ticket_icon.modulate = Color(1, 1, 1, 0.25)   # grisé / transparent
	
	
func _ready() -> void:
	message_label.visible = false
	message_timer.timeout.connect(_on_message_timer_timeout)

func show_message(text: String) -> void:
	message_label.text = text
	message_label.visible = true
	message_timer.start()

func _on_message_timer_timeout() -> void:
	message_label.visible = false
