extends RigidBody2D

export (int) var engine_thrust
export (int) var spin_thrust

enum {TOUCH_IDLE, TOUCH_THRUST_ON, TOUCH_THRUST_OFF, TOUCH_FIRE, TOUCH_DRAG_LEFT, TOUCH_DRAG_RIGHT}
enum {TOUCH_AREA_NONE, TOUCH_AREA_FIRE, TOUCH_AREA_DRAG, TOUCH_AREA_THRUST}
const TOUCH_MAX = 3
const TOUCH_THRUST_DENOMINATOR = 3
const TURN_SPEED_DRAG = 4
const ROTATION_STEP = 0.5
const MAP_LIMIT = 512
const LIVES_MAX = global.LIVES_MAX

var array_touch_state = []
var array_touch_area = []

var thrust = Vector2()
var rotation_dir = 0
var screensize
var target_acquired
var joint
var terrain
var exploding = false
var game_over = false
var escape_shown = false

var record = {}

var reloading = 0.0
onready var weight_node = get_node("/root/main/weight")
onready var engine = get_node("engine/Sprite")

const LASER = preload("res://scenes/laser.tscn")
const JOINT = preload("res://scenes/joint.tscn")
const BRICK = preload("res://scenes/brick.tscn")
const TOWER_N = preload("res://scenes/tower_n.tscn")
const RELOAD_TIME = 1.0

func _ready():
	screensize = get_viewport().get_visible_rect().size
	target_acquired = false
	var idx = 0
		
	
	match global.level_index:
		0:
			terrain = load("res://scenes/level01.tscn").instance()
		1:
			terrain = load("res://scenes/level01-1.tscn").instance()	
		2:
			terrain = load("res://scenes/level02.tscn").instance()
		3:
			terrain = load("res://scenes/level03.tscn").instance()
		4:
			terrain = load("res://scenes/level04.tscn").instance()
		5:
			terrain = load("res://scenes/level02-inv.tscn").instance()
		6:
			terrain = load("res://scenes/level-finale.tscn").instance()
			get_parent().get_node("hud/credits").show()

	get_parent().call_deferred("add_child", terrain)

	weight_node.position = tileToPoint(terrain.weight_start)
	position = tileToPoint(terrain.player_start)
	rotation = terrain.player_rotation
	gravity_scale = terrain.gravity
	weight_node.gravity_scale = terrain.gravity
	
	for brick in terrain.bricks:
		var b = BRICK.instance()
		b.position = tileToPoint(brick)
		get_parent().call_deferred("add_child", b)

	for tower_n in terrain.towers_n:
		var tn = TOWER_N.instance()
		tn.position = tileToPoint(tower_n)
		get_parent().call_deferred("add_child", tn)

	get_parent().get_node("hud").alert(terrain.greeting)

	set_process(true)
	init_touch_state()

func tileToPoint(v2):
	return Vector2(v2.x * 16 + 8, v2.y * 16 + 8)

func init_touch_state():
	array_touch_state = []
	array_touch_area = []
	for i in range (TOUCH_MAX):
		array_touch_state.append(TOUCH_IDLE)
		array_touch_area.append(TOUCH_AREA_NONE)

func thrust_on():
	thrust = Vector2(engine_thrust, 0)
	play_thrust_animation()

func thrust_off():
	thrust = Vector2()

func turn_left(step = null):
	if step == null:
		rotation_dir -= ROTATION_STEP
	else:
		rotation_dir -= step

func turn_right(step = null):
	if step == null:
		rotation_dir += ROTATION_STEP
	else:
		rotation_dir += step

func get_input():
	var player_shown = get_node("Sprite").visible
	if Input.is_action_pressed("player_thrust") && player_shown:
		thrust_on()
	elif !Input.is_action_pressed("player_thrust"):
		thrust_off()
	rotation_dir = 0
	if Input.is_action_pressed("player_right") && player_shown:
		turn_right()
	if Input.is_action_pressed("player_left") && player_shown:
		turn_left()
	if Input.is_action_pressed("player_fire") && player_shown:
		fire()
	if Input.is_action_pressed("player_pause"):
		get_parent().pause()
	for i in range(TOUCH_MAX):
		match array_touch_state[i]:
			TOUCH_THRUST_ON:
				thrust_on()
			TOUCH_THRUST_OFF:
				thrust_off()
				array_touch_state[i] = TOUCH_IDLE
			TOUCH_FIRE:
				fire()
			TOUCH_DRAG_LEFT:
				turn_left()
			TOUCH_DRAG_RIGHT:
				turn_right()
			TOUCH_IDLE:
				pass

func _unhandled_input(event):
	var player_shown = get_node("Sprite").visible
	if (event.get_class() == "InputEventScreenDrag" && player_shown):
		var index = event.get_index()
		var relativePosition = event.get_relative()
		var position = event.position
		if position.y < (screensize.y/2) || position.x > (screensize.x/2):
			pass
		else:
			if (relativePosition.x < 0): # left
				array_touch_state[index] = TOUCH_DRAG_LEFT
			elif (relativePosition.x > 0): # right
				array_touch_state[index] = TOUCH_DRAG_RIGHT
			else: # no movement
				array_touch_state[index] = TOUCH_IDLE
	elif (event.get_class() == "InputEventScreenTouch" && player_shown):
		var index = event.get_index()
		var position = event.position
		if position.y < (screensize.y/2):
			array_touch_area[index] = TOUCH_AREA_FIRE
		elif position.x > (screensize.x/2):
			array_touch_area[index] = TOUCH_AREA_THRUST
		else:
			array_touch_area[index] = TOUCH_AREA_NONE

		if (index >= TOUCH_MAX):
			return
		if (event.pressed): # down
			match array_touch_area[index]:
				TOUCH_AREA_THRUST:
					array_touch_state[index] = TOUCH_THRUST_ON
				TOUCH_AREA_FIRE:
					array_touch_state[index] = TOUCH_FIRE
		else: # up; ignore player visibility
			match array_touch_area[index]:
				TOUCH_AREA_THRUST:
					array_touch_state[index] = TOUCH_THRUST_OFF
				_:
					array_touch_state[index] = TOUCH_IDLE
	
	elif (event.get_class() == "InputEventMouseButton" && player_shown):        
		# Use the mouse wheel to turn
		if (event.pressed):
			if event.button_index == BUTTON_WHEEL_UP:
				turn_left(ROTATION_STEP * 3)
			elif event.button_index == BUTTON_WHEEL_DOWN:
				turn_right(ROTATION_STEP * 3)

func _process(delta):
	get_input()
	engine.position = position
	engine.rotation = rotation
	get_parent().get_node("Light2D").position = position
	if reloading > 0.0:
		reloading -= 0.1
	update()

func _draw():
	if target_acquired:
		var node_b = get_node("/root/main/weight")
		var pos_a = transform.xform_inv(global_position)
		var pos_b = transform.xform_inv(node_b.global_position)
		draw_line(pos_a, pos_b, Color.white, 1.2, false)

func _integrate_forces(state):
	if exploding:
		self.apply_central_impulse(-self.linear_velocity)
		return

	var origin = state.transform.get_origin()

	if abs(origin.x) > MAP_LIMIT || abs(origin.y) > MAP_LIMIT :
		if target_acquired:
			if global.level_index > 0:
				global.add_to_score(5000)
			global.next_level()
		trigger_reset()
		return
	var collidingBodies = get_colliding_bodies()	
	for i in range(collidingBodies.size()):
		match (collidingBodies[i].name):
			"terrain":
				explode()
			"weight":
				acquire_target()
				if !escape_shown:
					get_parent().get_node("hud").alert("Escape")
					escape_shown = true


func _physics_process(delta):
	set_applied_force(thrust.rotated(rotation))
	set_applied_torque(rotation_dir * spin_thrust)


func fire():
	if reloading > 0.0 || exploding:
		return
	if global.fx:
		get_parent().get_node("sample-laser").play()
	var bullet = LASER.instance()
	bullet.global_position = global_position
	bullet.rotation = global_rotation
	get_parent().add_child(bullet)
	reloading = RELOAD_TIME

func acquire_target():
	if target_acquired || exploding:
		return
	global.add_to_score(500)
	if global.fx:
		get_parent().get_node("sample-coin").play()
	joint = JOINT.instance()
	add_child(joint)
	target_acquired = true

func play_thrust_animation():
	if exploding:
		return
	var animation = get_node("engine")
	animation.play("thrust")

func explode():
	if exploding:
		return
	exploding = true

	# ensure ship stops here
	gravity_scale = 0.0
	linear_velocity = Vector2()
	mode = RigidBody2D.MODE_STATIC

	can_sleep = true
	sleeping = true
	angular_velocity = 0.0

	init_touch_state()

	if target_acquired:
		target_acquired = false
		joint.queue_free()

	play_sound_once("sample-explosion")

	global.lives = global.lives - 1
	
	get_node("/root/main/hud/vbox/topbar").remove_child(get_node("/root/main/hud/vbox/topbar/right" + str(global.lives)))


	if global.lives <= 0:
		global.save_config()
		global.level_index = 0
		get_parent().get_node("hud").alert("Game over")
		global.lives = global.LIVES_MAX
		global.score = 0
		game_over = true
	

	var animation = get_node("explosion")
	var sprite = animation.get_node("Sprite")
	sprite.position = position
	sprite.show()
	animation.play("explosion")

func trigger_reset():
	if game_over:
		return get_tree().change_scene("res://scenes/splash.tscn")
	return get_tree().reload_current_scene()

func _on_player_body_entered(body):
	pass

func play_sound_once(s):
	if record.has(s) || !global.fx:
		return
	record[s] = true
	get_parent().get_node(s).play()
