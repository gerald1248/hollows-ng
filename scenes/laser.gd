extends Sprite

const VELOCITY_MULTIPLIER = 200
onready var player = get_node("/root/main/player")
onready var velocity = Vector2(VELOCITY_MULTIPLIER * cos(player.rotation), VELOCITY_MULTIPLIER * sin(player.rotation)) + VELOCITY_MULTIPLIER * player.motion
onready var screen_size = get_viewport_rect()

func _process(delta):
	move(delta)
	removeWhenOffScreen()

func move(delta):
	global_position += velocity * delta

func removeWhenOffScreen():
	if !screen_size.has_point(global_position):
		queue_free()
