extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# -----------------------------
# Temperature system (Banquise)
# -----------------------------
enum MeterMode { COLD, ALCOHOL }
var meter_mode: MeterMode = MeterMode.COLD

@export var temp_max: int = 100
@export var cold_damage: int = 10  # perte de température
var temp: int = 100               # <-- plus exporté

@export var alc_max: int = 100
var alc: int = 0

var is_dead: bool = false
var controls_inverted: bool = false
var forest_warning_shown: bool = false

# Glissade sur la glace
@export var accel: float = 900.0
@export var decel: float = 1100.0
var ice_control: float = 1.0

@export var temperature_ui: Node


func _ready() -> void:
	temp = temp_max
	call_deferred("_update_temp_bar")

func _update_meter_ui() -> void:
	if not temperature_ui:
		return

	if meter_mode == MeterMode.COLD:
		if temperature_ui.has_method("set_mode"):
			temperature_ui.set_mode("COLD")
		if temperature_ui.has_method("set_value"):
			temperature_ui.set_value(temp, temp_max)
	else:
		if temperature_ui.has_method("set_mode"):
			temperature_ui.set_mode("ALCOHOL")
		if temperature_ui.has_method("set_value"):
			temperature_ui.set_value(alc, alc_max)

func set_meter_mode(new_mode: MeterMode) -> void:
	meter_mode = new_mode

	if meter_mode == MeterMode.ALCOHOL:
		alc = alc_max  # 100% direct en forêt

	_update_meter_ui()
	update_drunk_state()

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Horizontal movement
	var direction := Input.get_axis("ui_left", "ui_right")

	if controls_inverted:
		direction *= -1

	# Flip seulement quand le joueur appuie
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true

	var target_speed = direction * SPEED

	# Sur glace, accel/decel réduits -> glisse
	var a = accel * ice_control
	var d = decel * ice_control

	if direction != 0:
		velocity.x = move_toward(velocity.x, target_speed, a * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, d * delta)

	move_and_slide()


# --- Temperature helpers ---
func add_temp(amount: int) -> void:
	if is_dead:
		return
	temp = clamp(temp + amount, 0, temp_max)
	_update_temp_bar()


func remove_temp(amount: int) -> void:
	if is_dead:
		return
	temp = clamp(temp - amount, 0, temp_max)
	_update_temp_bar()

	if temp <= 0:
		die()

func die() -> void:
	if is_dead:
		return
	is_dead = true

	GameState.lose_life()

	if GameState.is_game_over():
		var death_screen = preload("res://Scene/death_screen.tscn").instantiate()
		get_tree().current_scene.add_child(death_screen)
	else:
		GameState.reset_level_only()
		get_tree().call_deferred("reload_current_scene")


func _update_temp_bar() -> void:
	if temperature_ui and temperature_ui.has_method("set_value"):
		temperature_ui.set_value(temp, temp_max)


func update_drunk_state() -> void:
	# Inversion UNIQUEMENT en forêt quand alcool = 100%
	if meter_mode == MeterMode.ALCOHOL and alc >= alc_max:
		controls_inverted = true
	else:
		controls_inverted = false

func drink_beer(amount: int) -> void:
	# banquise: réchauffe
	if meter_mode == MeterMode.COLD:
		add_temp(amount)
	else:
		# forêt: augmente l'alcoolémie
		alc = clamp(alc + amount, 0, alc_max)
		_update_meter_ui()

func eat_food(amount: int) -> void:
	# forêt: diminue l'alcoolémie
	if meter_mode == MeterMode.ALCOHOL:
		alc = clamp(alc - amount, 0, alc_max)
		_update_meter_ui()
		update_drunk_state()

func set_ice_control(value: float) -> void:
	ice_control = value


# ----------------------------------------
# Timer signal (ColdTimer -> timeout())
# ----------------------------------------
func _on_cold_timer_timeout() -> void:
	if meter_mode == MeterMode.COLD:
		remove_temp(cold_damage)
