extends Node2D

const SPEED := 60.0
var direction := 1

@onready var ray_cast_l: RayCast2D = $RayCastL
@onready var ray_cast_r: RayCast2D = $RayCastR
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var sfx_distance: float = 200.0
@onready var step_sfx: AudioStreamPlayer2D = $StepSFX

var player: Node2D = null


func _ready() -> void:
	# Recherche robuste du Player (fonctionne même si la scène s'appelle GameDev)
	player = get_tree().root.find_child("Player", true, false) as Node2D

	# Réglages audio "safe" (tu peux ajuster après)
	if step_sfx:
		step_sfx.autoplay = false
		step_sfx.volume_db = 10.0
		step_sfx.max_distance = 2000.0
		step_sfx.attenuation = 1.0


func _physics_process(delta: float) -> void:
	# IMPORTANT: pas de elif (comme ton script qui marchait)
	if ray_cast_r.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true

	if ray_cast_l.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false

	position.x += direction * SPEED * delta


func _process(_delta: float) -> void:
	if not player or not step_sfx:
		return

	var dist := global_position.distance_to(player.global_position)

	# Play / Stop direct (pas de fondu)
	if dist <= sfx_distance:
		if not step_sfx.playing:
			step_sfx.play()
	else:
		if step_sfx.playing:
			step_sfx.stop()
