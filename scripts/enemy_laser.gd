extends Area2D

const VELOCITY_MULTIPLIER = 200
var velocity = Vector2()
var from = Vector2()
var to = Vector2()
var deactivated = false
onready var ttl = 50

func _ready():
	velocity = VELOCITY_MULTIPLIER * (to - from).normalized()

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
	if area.name.find("tower") != -1:
		return
	explode()

func _on_laser_body_entered(body):
	if deactivated:
		return

	match body.get_name():
		"player":
			get_node("/root/main/player").explode()
		"terrain":
			if global.fx:
				get_node("/root/main/sample-explosion-surface").play()
		"weight":
			if global.fx:
				get_node("/root/main/sample-explosion-weight").play()
	explode()

func explode():
	deactivated = true
	var sprite = get_node("explosion").get_node("Sprite")
	sprite.position = position
	sprite.show()
	get_node("explosion").play("explosion")
	self.hide()
