extends Sprite

const VELOCITY_MULTIPLIER = 200
onready var player = get_node("/root/main/player")
onready var velocity = Vector2(VELOCITY_MULTIPLIER * cos(player.rotation), VELOCITY_MULTIPLIER * sin(player.rotation)) + VELOCITY_MULTIPLIER * player.motion
onready var ttl = 50

func _process(delta):
	move(delta)
	removeWhenOffScreen()

func move(delta):
	global_position += velocity * delta
	ttl -= 1

func removeWhenOffScreen():
	if ttl <= 0:
		queue_free()
