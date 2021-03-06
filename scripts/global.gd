extends Node

const CONFIG_PATH = "user://hollows.data"
const LIVES_MAX = 4
const TILE_LENGTH = 16
const DEBUG_SCREEN_RESOLUTION = false
const CREDITS_FULL = """

Soundtrack The Adventure Lights by Skip Cloud, CCA 3.0

Sound effects by @Shades, CC0 1.0

Explosions by Akimasa Shimobayashi, CC BY 3.0

Background by Westbeam, CC0 1.0

Mouse support by FranchuFranchu

Godot Engine by Juan Linietsky, Ariel Manzur
and Godot Engine Contributors, MIT

Links to sources and licenses:
github.com/gerald1248/hollows-ng/blob/master/COPYING

Hollows is free to copy and modify at:
github.com/gerald1248/hollows-ng
"""

const notch_padding = 12.5
var lives = LIVES_MAX
var level_index = 0 # 0 for training mission
var level_count = 7
var fx = true
var music = true
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
var is_desktop
var hud_padding
const random_array = [ 0.0, 0.6, 0.2, 0.1, 0.3, 0.9, 1.0, 0.8, 0.4, 0.5, 0.7 ]
var random_array_size = random_array.size()
var random_array_index = 0
var white_noise_max_volume = -35.0
var white_noise_min_volume = -80.0

func _ready():
	load_config()
	set_music(music)
	set_fx(fx)
	safe_area = OS.get_window_safe_area()
	safe_area_position = Vector2(safe_area.position.x/4, safe_area.position.y/4)
	safe_area_size = Vector2(safe_area.size.x/4, safe_area.size.y/4)	
	viewport_size = get_viewport().get_visible_rect().size
	
	is_ios = OS.get_name() == "iOS"
	is_ipad = is_ios && viewport_size.x/viewport_size.y < 1.34
	is_iphone_x = is_ios && max(viewport_size.x, viewport_size.y)/min(viewport_size.x, viewport_size.y) > 1.8
	is_android = OS.get_name() == "Android"
	is_desktop = !is_ios && !is_android
	
	hud_padding = notch_padding if is_iphone_x else 0.0
	
	if !is_desktop:
		return

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
	var node = get_node("music")
	match b:
		true:
			node.play()
		false:
			node.stop()

func set_fx(b):
	var node = get_node("white-noise")
	match b:
		true:
			node.volume_db = -80.0
			node.play()
		false:
			node.stop()

func set_engine_sound_on():
	get_node("white-noise").volume_db = white_noise_max_volume

func set_engine_sound_off():
	get_node("white-noise").volume_db = white_noise_min_volume

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

func get_random():
	random_array_index = (random_array_index + 1) % (random_array_size - 1)
	return random_array[ random_array_index ]
