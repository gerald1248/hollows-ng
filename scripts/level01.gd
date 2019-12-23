extends TileMap

const towers_n = []
const bricks = [Vector2(7, -2), Vector2(8, -2), Vector2(9, -2), Vector2(10, -2), Vector2(7, -1), Vector2(10, -1), Vector2(7, 0), Vector2(10, 0), Vector2(7, 1), Vector2(8, 1), Vector2(9, 1), Vector2(10, 1)]
const player_start = Vector2(-0.5, -0.5)
const weight_start = Vector2(8.5, -0.5)
const player_rotation = PI * 1.5
const gravity = 0.0
const training = true
const greeting = "Training mission"

func _ready():
	pass
