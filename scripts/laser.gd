extends Area2D

const VELOCITY_MULTIPLIER = 250
onready var player = get_node("/root/main/player")
onready var velocity = Vector2(VELOCITY_MULTIPLIER * cos(player.rotation), VELOCITY_MULTIPLIER * sin(player.rotation)) + player.linear_velocity
onready var ttl = 80
var deactivated = false

func _process(delta):
	move(delta)
	removeIfDue()

func move(delta):
	position += velocity * delta
	ttl -= 1

func removeIfDue():
	if ttl <= 0:
		queue_free()

func _on_laser_area_entered(area):
	if deactivated:
		return
	var name = area.name
	if name.find("tower") != -1:
		area.destroy()
		global.add_to_score(1500)
		if global.fx:
			get_node("/root/main/sample-explosion-tower").play()
	elif name.find("brick") != -1:
		area.destroy()
		global.add_to_score(100)
		if global.fx:
			get_node("/root/main/sample-explosion-brick").play()
	elif name.find("laser") != -1 && name.find("en") == -1:
		return
	explode()

func _on_laser_body_entered(body):
	if deactivated:
		return
	match body.get_name():
		"player":
			return
		"terrain":
			if global.fx:
				get_node("/root/main/sample-explosion-surface").play()
		"weight":
			if global.fx:
				get_node("/root/main/sample-explosion-weight").play()
	explode()

func explode():
	deactivated = true
	velocity = Vector2()
	var sprite = get_node("explosion").get_node("Sprite")
	sprite.position = position
	sprite.show()
	get_node("explosion").play("explosion")
	$Sprite.hide()
