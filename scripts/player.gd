extends Area2D

const TURN_SPEED = 180 # how fast the ship will turn
const TURN_SPEED_DRAG = 5
const MOVE_SPEED = 150 # ship's speed
const ACC = 0.05 # acceleration %
const DEC = 0.01 # deceleration %

enum {TOUCH_IDLE, TOUCH_DOWN, TOUCH_DRAG}
const TOUCH_DURATION_THRESHOLD = 6
const TOUCH_MAX = 4
const TOUCH_THRUST_DENOMINATOR = 3

var motion = Vector2(0,0) # ship's actual move direction (not the desired move direction)
var screen_size # set in _ready()
var grav = Vector2(0, 0.1)
var reloading = 0.0
# TODO: limit arrays to TOUCH_MAX
var array_touch_state = []
var array_touch_frames = []
var movedir = Vector2(0, 0)

const BULLET_LASER = preload("res://scenes/laser.tscn")
const RELOAD_TIME = 0.2

func _ready():
	screen_size = get_viewport_rect().size
	position = Vector2(screen_size.x/2, screen_size.y/2)
	rotation = 1.5 * PI
	for i in range (TOUCH_MAX):
		array_touch_state.append(TOUCH_IDLE)
		array_touch_frames.append(0)

func _process(delta):
	# TURNING
	if Input.is_action_pressed("ui_left"): # if the left arrow key is pressed...
		rotation_degrees -= TURN_SPEED * delta # turn left by TURN_SPEED (* delta, for uniform timing)
	if Input.is_action_pressed("ui_right"):
		rotation_degrees += TURN_SPEED * delta	

	# MOVEMENT
	movedir = Vector2(1,0).rotated(rotation) # desired move direction
	
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
	
	# TOUCH ACCELERATION
	for i in range (TOUCH_MAX):
		if (array_touch_state[i] == TOUCH_DOWN || array_touch_state[i] == TOUCH_DRAG):
			array_touch_frames[i] = array_touch_frames[i] + 1

		if (array_touch_frames[i] > TOUCH_DURATION_THRESHOLD):
			movedir = Vector2(1,0).rotated(rotation)
			motion = motion.linear_interpolate(movedir, ACC/TOUCH_THRUST_DENOMINATOR)

func _unhandled_input(event):
	if (event.get_class() == "InputEventScreenDrag"):
		var index = event.get_index()
		array_touch_state[index] = TOUCH_DRAG
		var relativePosition = event.get_relative()
		if (relativePosition.x < 0):
			 rotation_degrees -= TURN_SPEED_DRAG
		elif (relativePosition.x > 0):
			rotation_degrees += TURN_SPEED_DRAG
	elif (event.get_class() == "InputEventScreenTouch"):
		var index = event.get_index()
		if (index >= TOUCH_MAX):
			return
		if (event.pressed): # down
			array_touch_state[index] = TOUCH_DOWN
			array_touch_frames[index] = 0
		else: # up
			# fire if appropriate
			# update state
			if (array_touch_frames[index] < TOUCH_DURATION_THRESHOLD):
				fire()
			array_touch_state[index] = TOUCH_IDLE
			array_touch_frames[index] = 0

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