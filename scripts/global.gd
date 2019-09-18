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
var viewport_size

func _ready():
	load_config()
	set_music(music)

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
