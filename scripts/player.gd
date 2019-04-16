extends Area2D

const TURN_SPEED = 180 # how fast the ship will turn
const MOVE_SPEED = 150 # ship's speed
const ACC = 0.05 # acceleration %
const DEC = 0.01 # deceleration %
var motion = Vector2(0,0) # ship's actual move direction (not the desired move direction)
var screen_size # set in _ready()
var screen_buffer = 8 # how far off screen before it wraps
var grav = Vector2(0, 0.1)
var reloading = 0.0

const BULLET_LASER = preload("res://scenes/laser.tscn")
const RELOAD_TIME = 0.2

func _ready():
	screen_size = get_viewport_rect().size
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
	
	# SCREEN WRAP
	# wraps position to the other side of the screen when moving off
	position.x = wrapf(position.x, -screen_buffer, screen_size.x + screen_buffer)
	position.y = wrapf(position.y, -screen_buffer, screen_size.y + screen_buffer)

	# FIRE
	reloading -= delta
	if Input.is_key_pressed(KEY_SPACE):
		fire()

func fire():
	if reloading <= 0.0:
		var bullet = BULLET_LASER.instance()
		bullet.global_position = global_position
		bullet.rotation = rotation
		get_parent().add_child(bullet)
		reloading = RELOAD_TIME
	