extends Node2D

const SPEED := 60.0
var direction := 1

@onready var ray_cast_l: RayCast2D = $RayCastL
@onready var ray_cast_r: RayCast2D = $RayCastR
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var step_sfx: AudioStreamPlayer2D = $StepSFX

@export var sfx_distance: float = 150.0
@export var sfx_cooldown: float = 1.5

var player: Node2D = null
var sfx_timer: float = 0.0
var was_in_range: bool = false

func _ready() -> void:
	# Trouver le player (majuscule/minuscule)
	player = get_tree().current_scene.find_child("Player", true, false) as Node2D
	if not player:
		player = get_tree().current_scene.find_child("player", true, false) as Node2D

func _physics_process(delta: float) -> void:
	if ray_cast_r.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
	elif ray_cast_l.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false

	position.x += direction * SPEED * delta

func _process(_delta: float) -> void:
	if not player or not step_sfx:
		return

	var dist := global_position.distance_to(player.global_position)
	var in_range := dist <= sfx_distance

	# Entrée dans la zone -> play 1 fois
	if in_range and not was_in_range:
		step_sfx.play()

	was_in_range = in_range

	# On entre dans la zone -> on joue une fois direct
	if in_range and not was_in_range:
		step_sfx.play()
		sfx_timer = sfx_cooldown

	# On reste dans la zone -> rejoue toutes les X secondes
	if in_range and sfx_timer <= 0.0:
		step_sfx.play()
		sfx_timer = sfx_cooldown

	# On sort -> on ne stop pas, on reset juste l'état
	if not in_range and was_in_range:
		sfx_timer = 0.0

	was_in_range = in_range
