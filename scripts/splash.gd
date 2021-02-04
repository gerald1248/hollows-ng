extends TextureRect

var rng = RandomNumberGenerator.new()

var fx_button
var music_button
var title_box
var player_box
var player_box_size
var player
var weight
var line
var rand
var screensize
var is_ready = false

func _ready():
	fx_button = get_node("vbox").get_node("hbox_controls").get_node("fx_button")
	music_button = get_node("vbox").get_node("hbox_controls").get_node("music_button")
	update_button_labels()
	rng.randomize()
	rand = rng.randf_range(0.0, 1.0)
	global.set_engine_sound_off()
	
	set_screensize()
	
	title_box = get_node("vbox/hbox_title")
	player_box = get_node("vbox/hbox_player")
	player_box_size = player_box.rect_size
	player = get_node("vbox/hbox_player/player")
	weight = get_node("vbox/hbox_player/weight")
	line = get_node("vbox/hbox_player/line")
	update_player_position($vbox.rect_min_size.x)
	if global.highscore > 0:
		var footer = get_node("/root/splash/vbox/hbox_footer/footer")
		footer.set_text(String("High score %d" % global.highscore))
		footer.rect_size.x = global.viewport_size.x
	is_ready = true

func set_screensize():
	screensize = get_viewport().get_visible_rect().size
	$vbox.rect_min_size.x = screensize.x
	$starfield.offset = screensize/2

func update_player_position(width):
	player.position = Vector2(width / 2, player_box_size.y / 2)
	player.rotation_degrees = 360 * rand
	weight.position = player.position + Vector2(25 * cos(2 * PI * -rand), 25 * sin(2 * PI * -rand))
	weight.rotation_degrees = 360 * rand
	$vbox/hbox_player/line.set_point_position(0, player.position)
	$vbox/hbox_player/line.set_point_position(1, weight.position)

func update_button_labels():
	fx_button.text = "FX ON" if global.fx else "FX OFF"
	music_button.text = "Music ON" if global.music else "Music OFF"

func _on_start_button_pressed():
	get_tree().change_scene("res://scenes/main.tscn")

func _on_skip_button_pressed():
	global.level_index = 1
	_on_start_button_pressed()

func _on_fx_button_pressed():
	global.fx = !global.fx
	update_button_labels()
	global.set_fx(global.fx)
	global.save_config()

func _on_music_button_pressed():
	global.music = !global.music
	update_button_labels()
	global.set_music(global.music)
	global.save_config()

func _notification(what):
	match (what):
		MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
			get_tree().quit()
		NOTIFICATION_RESIZED: # fires before _ready()
			if is_ready:
				set_screensize()
				update_player_position(screensize.x)

func _on_credits_button_button_down():
	#var font_size = 3.0 if screensize.x > screensize.y else 4.0
	$credits_dialog.get_close_button().hide()
	$credits_dialog.set_text(global.CREDITS_FULL)
	#$credits_dialog.theme.default_font.set("size", font_size)
	#$credits_dialog.popup_centered_ratio(0.8)
	
	#$credits_dialog.show()
	$credits_dialog.popup_centered_minsize()
