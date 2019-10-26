extends Node

const CONFIG_PATH = "user://hollows.data"
const LIVES_MAX = 5
const TILE_LENGTH = 16
const DEBUG_SCREEN_RESOLUTION = false

var lives = LIVES_MAX
var level_index = 0 # 0 for training mission
var level_count = 7
var fx = false
var music = false
var score = 0
var highscore = 0
var safe_area
var safe_area_position
var safe_area_size
var viewport_size
var is_ios
var is_ipad
var is_iphone_x
var is_android
var hud_padding

func _ready():
	load_config()
	set_music(music)
	safe_area = OS.get_window_safe_area()
	safe_area_position = Vector2(safe_area.position.x/4, safe_area.position.y/4)
	safe_area_size = Vector2(safe_area.size.x/4, safe_area.size.y/4)
	viewport_size = Vector2(OS.window_size.x/4, OS.window_size.y/4)
	hud_padding = safe_area_position.x

	# iPad requires an exception for custom drawing
	is_ios = OS.get_name() == "iOS"
	is_ipad = is_ios && viewport_size.x/viewport_size.y < 1.34
	is_iphone_x = is_ios && viewport_size.x/viewport_size.y > 1.8

	is_android = OS.get_name() == "Android"

	# special case iPad
	if is_ipad:
		viewport_size = Vector2(320, 240)
	# iPhone X, 11, ...
	elif is_iphone_x:
		viewport_size = Vector2(390.0, 180.0)
	# iPhone 8 and older
	elif is_ios:
		viewport_size = Vector2(320.0, 180.0)
	# widescreen Android
	elif viewport_size.x > 330:
		viewport_size = adjust_viewport_size(viewport_size)

func flip_vector2(v2):
	return Vector2(v2.y, v2.x)

func load_config():
	var file = File.new()
	if not file.file_exists(CONFIG_PATH): return
	file.open(CONFIG_PATH, File.READ)
	highscore = file.get_var()
	fx = file.get_var()
	music = file.get_var()
	file.close()

func adjust_viewport_size(size):
	var long_side = max(size.x, size.y)
	var short_side = min(size.x, size.y)
	return Vector2(180.0 * round(long_side/short_side), 180.0)

func save_config():
	var file = File.new()
	file.open(CONFIG_PATH, File.WRITE)
	file.store_var(highscore)
	file.store_var(fx)
	file.store_var(music)
	file.close()

func set_viewport_size(v2):
	viewport_size = v2

func set_music(b):
	var node = get_node("blue-danube")
	match b:
		true:
			node.play()
		false:
			node.stop()

func set_highscore(new_value):
	highscore = new_value

func next_level():
	level_index = (level_index + 1) % level_count
	if level_index == 0: # skip training on replay
		level_index = 1

func add_to_score(i):
	score = score + i
	get_node("/root/main/hud").update_score(score)
	if score > highscore:
		set_highscore(score)
