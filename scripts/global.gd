extends Node

const TILE_LENGTH = 16
const SCORE_PATH = "user://highscore.data"

var LIVES_MAX = 5
var lives = LIVES_MAX
var level_index = 5 # 0 for training mission
var level_count = 6
var fx = true
var music = false
var score = 0
var highscore = 0

func _ready():
	load_highscore()

func load_highscore():
	var file = File.new()
	if not file.file_exists(SCORE_PATH): return
	file.open(SCORE_PATH, File.READ)
	highscore = file.get_var()
	file.close()

func save_highscore():
	var file = File.new()
	file.open(SCORE_PATH, File.WRITE)
	file.store_var(highscore)
	file.close()

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