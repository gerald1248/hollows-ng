extends Node

const CONFIG_PATH = "user://hollows.data"
const LIVES_MAX = 5
const TILE_LENGTH = 16

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
var is_ipad

func _ready():
	load_config()
	set_music(music)
	safe_area = OS.get_window_safe_area()
	safe_area_position = Vector2(safe_area.position.x/4, safe_area.position.y/4)
	safe_area_size = Vector2(safe_area.size.x/4, safe_area.size.y/4)
	viewport_size = Vector2(OS.window_size.x/4, OS.window_size.y/4)

	# iPad requires an exception for custom drawing
	# TODO: check if later versions report OS name as iPad OS?
	is_ipad = OS.get_name() == "iOS" && viewport_size.x/viewport_size.y < 1.34

	# adjust for devices with base width * 1.5 and up
	# always apply on iOS
	if viewport_size.x > 480 || OS.get_name() == "iOS":
		safe_area_size = Vector2(320, 180)
		viewport_size = Vector2(320 + safe_area_position.x, 240 if is_ipad else 180)

func load_config():
	var file = File.new()
	if not file.file_exists(CONFIG_PATH): return
	file.open(CONFIG_PATH, File.READ)
	highscore = file.get_var()
	fx = file.get_var()
	music = file.get_var()
	file.close()

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
