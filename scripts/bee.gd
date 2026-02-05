extends CharacterBody2D

# -----------------------------
# PARAMÈTRES
# -----------------------------
@export var speed: float = 80.0
@export var patrol_distance: float = 100.0  # distance totale en pixels
@export var bob_amplitude: float = 8.0      # mouvement vertical (vol)
@export var bob_speed: float = 3.0

@export var buzz_distance: float = 150.0     # distance à laquelle on entend le bzz

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Killzone
@onready var buzz_sfx: AudioStreamPlayer2D = $BuzzSFX

# -----------------------------
# ÉTAT
# -----------------------------
var start_x: float
var direction: int = 1
var t: float = 0.0

var player: Node2D = null


# -----------------------------
# READY
# -----------------------------
func _ready() -> void:
	start_x = global_position.x

	# Connexion hitbox
	if hitbox:
		hitbox.body_entered.connect(_on_hitbox_body_entered)

	# Récupère le player une fois
	player = get_tree().current_scene.find_child("Player", true, false) as Node2D
	print("BEE READY | player=", player, " buzz_sfx=", buzz_sfx)
	
	print("BUZZ STREAM =", buzz_sfx.stream)
	buzz_sfx.volume_db = 0
	buzz_sfx.max_distance = 100000
	buzz_sfx.attenuation = 0.0
	buzz_sfx.play()


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

	# Orientation du sprite (INVERSE, comme tu voulais)
	if sprite:
		# direction > 0 = droite => flip TRUE
		# direction < 0 = gauche => flip FALSE
		sprite.flip_h = direction > 0


# -----------------------------
# HIT PLAYER
# -----------------------------
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		body.die()


# -----------------------------
# SFX
# -----------------------------
func _process(_delta: float) -> void:
	if not player or not buzz_sfx:
		return

	var dist := global_position.distance_to(player.global_position)

	if dist <= buzz_distance:
		if not buzz_sfx.playing:
			buzz_sfx.play()
	else:
		if buzz_sfx.playing:
			buzz_sfx.stop()
