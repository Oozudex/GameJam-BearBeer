extends CharacterBody2D

# -----------------------------
# PARAMÈTRES
# -----------------------------
@export var speed: float = 80.0
@export var patrol_distance: float = 100.0  # distance totale en pixels
@export var bob_amplitude: float = 8.0       # mouvement vertical (vol)
@export var bob_speed: float = 3.0

# -----------------------------
# ÉTAT
# -----------------------------
var start_x: float
var direction: int = 1
var t: float = 0.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Killzone


# -----------------------------
# READY
# -----------------------------
func _ready() -> void:
	start_x = global_position.x
	hitbox.body_entered.connect(_on_hitbox_body_entered)


# -----------------------------
# PHYSICS
# -----------------------------
func _physics_process(delta: float) -> void:
	# Mouvement horizontal
	velocity.x = speed * direction

	# Mouvement vertical (effet vol)
	t += delta
	velocity.y = sin(t * bob_speed) * bob_amplitude

	move_and_slide()

	# Demi-tour quand on dépasse la distance
	if abs(global_position.x - start_x) >= patrol_distance:
		direction *= -1

	# Flip du sprite
	if sprite:
		sprite.flip_h = direction < 0
	
	# Orientation du sprite (INVERSE)
	if direction > 0:
		sprite.flip_h = true   # allait à droite → on FLIP
	elif direction < 0:
		sprite.flip_h = false  # allait à gauche → normal



# -----------------------------
# HIT PLAYER
# -----------------------------
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		body.die()
