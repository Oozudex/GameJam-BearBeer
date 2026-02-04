extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# -----------------------------
# Temperature system (Banquise)
# -----------------------------
@export var temp_max: int = 100
@export var cold_damage: int = 10  # perte de température
var temp: int = 100               # <-- plus exporté

@onready var temp_bar: ProgressBar = $"../HUD/HBoxContainer/TempBar"

var is_dead: bool = false

# Glissade sur la glace
@export var accel: float = 900.0
@export var decel: float = 1100.0
var ice_control: float = 1.0



func _ready() -> void:
	# Toujours démarrer à fond
	temp = temp_max
	_update_temp_bar()


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
	GameState.reset_level_only()

	if GameState.is_game_over():
		get_tree().call_deferred("change_scene_to_file", "res://Scene/main_menu.tscn")
	else:
		get_tree().call_deferred("reload_current_scene")



func _update_temp_bar() -> void:
	if temp_bar:
		temp_bar.max_value = temp_max
		temp_bar.value = temp

func set_ice_control(value: float) -> void:
	ice_control = value


# ----------------------------------------
# Timer signal (ColdTimer -> timeout())
# ----------------------------------------
func _on_cold_timer_timeout() -> void:
	print("cold tick:", temp)
	remove_temp(cold_damage)
