extends Area2D

const DISTANCE_CUTOFF = 200
const ENEMY_LASER = preload("res://scenes/enemy_laser.tscn")

func _on_tower_n_area_entered(area):
	pass # Replace with function body.

func _on_tower_n_body_entered(body):
	match body.name:
		"player":
			get_parent().get_node("player").explode()
		"weight":
			destroy()
			if global.fx:
				get_node("/root/main/sample-explosion-tower").play()

func destroy():
	queue_free()

func _on_schedule_timeout():
	var tower_position = position + Vector2(0, -2)
	var player_position = get_parent().get_node("player").position
	if tower_position.y > player_position.y + global.TILE_LENGTH/2.0:
		return
	var d = distance(tower_position, player_position)
	if d > DISTANCE_CUTOFF:
		return
	var angle = angle(tower_position, player_position)

	if global.fx:
		get_parent().get_node("/root/main/sample-enemy-laser").play()
	var bullet = ENEMY_LASER.instance()
	bullet.global_position = tower_position
	bullet.from = tower_position + Vector2(global.TILE_LENGTH/2, global.TILE_LENGTH/2)
	bullet.to = player_position
	get_parent().add_child(bullet)

func distance(p1, p2):
	var dx = p2.x - p1.x
	var dy = p2.y - p1.y
	return sqrt(pow(dx, 2)  + pow(dy,2))

func angle(p1, p2):
	return p1.angle_to_point(p2)
