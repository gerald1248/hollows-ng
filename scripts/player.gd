extends Area2D

const TURN_SPEED = 180 # how fast the ship will turn
const TURN_SPEED_DRAG = 5
const MOVE_SPEED = 150 # ship's speed
const ACC = 0.05 # acceleration %
const DEC = 0.01 # deceleration %
var motion = Vector2(0,0) # ship's actual move direction (not the desired move direction)
var screen_size # set in _ready()
var grav = Vector2(0, 0.1)
var reloading = 0.0

const BULLET_LASER = preload("res://scenes/laser.tscn")
const RELOAD_TIME = 0.2

func _ready():
	screen_size = get_viewport_rect().size
	position = Vector2(screen_size.x/2, screen_size.y/2)
	rotation = 1.5 * PI

func _process(delta):
	# TURNING
	if Input.is_action_pressed("ui_left"): # if the left arrow key is pressed...
		rotation_degrees -= TURN_SPEED * delta # turn left by TURN_SPEED (* delta, for uniform timing)
	if Input.is_action_pressed("ui_right"):
		rotation_degrees += TURN_SPEED * delta	
	# MOVEMENT
	var movedir = Vector2(1,0).rotated(rotation) # desired move direction
	
	if Input.is_action_pressed("ui_up"):
		motion = motion.linear_interpolate(movedir, ACC) # lerp towards desired move direction
	else:
		motion = motion.linear_interpolate(Vector2(0,0), DEC) # lerp towards stillness

	motion += grav * delta	
	position += motion * MOVE_SPEED * delta # move using actual move direction * speed
	
	# FIRE
	reloading -= delta
	if Input.is_key_pressed(KEY_SPACE):
		fire()

func _unhandled_input(event):
	if (event.get_class() == "InputEventScreenDrag"):
		var relativePosition = event.get_relative()
		if (relativePosition.x < 0):
			 rotation_degrees -= TURN_SPEED_DRAG
		elif (relativePosition.x > 0):
			rotation_degrees += TURN_SPEED_DRAG
	elif (event.get_class() == "InputEventScreenTouch"):
		if (event.pressed):
			print("saw screen touch event ON")
		else:
			print("screen touch event OFF")
		# extract to avoid duplication
		var movedir = Vector2(1,0).rotated(rotation) # desired move direction
		motion = motion.linear_interpolate(movedir, ACC) # lerp towards desired move direction

func fire():
	if reloading <= 0.0:
		var bullet = BULLET_LASER.instance()
		bullet.global_position = global_position
		bullet.rotation = rotation
		get_parent().add_child(bullet)
		reloading = RELOAD_TIME

func _on_player_body_entered(body):
	if (body.get_class() == "TileMap"):
		crash()

func crash():
	position = Vector2(screen_size.x/2, screen_size.y/2)