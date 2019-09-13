extends TileMap

const towers_n = [Vector2(-4, 1), Vector2(0, -9)]
const bricks = [Vector2(5, -10), Vector2(6, -10), Vector2(7, -10), Vector2(7, -9), Vector2(7, -8)]
const player_start = Vector2(11.0, 21.0)
const weight_start = Vector2(11.0, 23)
const player_rotation = PI * 1.5
const gravity = 0.75
const training = false
const greeting = "Level 3"

func _ready():
	pass