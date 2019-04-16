extends Node

const TILE_LENGTH = 16
const SCORE_PATH = "user://highscore.data"

var LIVES_MAX = 5
var lives = LIVES_MAX
var level_index = 0 # 0 for training mission
var level_count = 6
var loop = false
var fx = true
var loops = [ "loop-i", "loop-ii", "loop-iii", "loop-iv", "loop-v", "blue-danube" ]
var loop_index = 0
var score = 0
var highscore = 0

func _ready():
	load_highscore()
	update_loop_index()

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

func set_highscore(new_value):
	highscore = new_value
	save_highscore()

func update_loop_index():
	loop_index = level_index % loops.size()	

func next_level():
	level_index = (level_index + 1) % level_count
	if level_index == 0: # skip training on replay
		level_index = 1
	update_loop_index()

func add_to_score(i):
	score = score + i
	get_node("/root/main/hud").update_score(score)
	if score > highscore:
		set_highscore(score)