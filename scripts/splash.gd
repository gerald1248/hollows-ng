extends TextureRect

var rng = RandomNumberGenerator.new()

var fx_button
var music_button
var viewportSize

func _ready():
	fx_button = get_node("vbox").get_node("hbox_controls").get_node("fx_button")
	music_button = get_node("vbox").get_node("hbox_controls").get_node("music_button")
	update_button_labels()
	viewportSize = Vector2(get_parent().size.x/4, get_parent().size.y/4)
	global.set_viewport_size(viewportSize)
	#$player.position = Vector2(viewportSize.x/2, viewportSize.y/2 - 16)
	rng.randomize()
	var rand = rng.randf_range(0.0, 1.0)
	#$player.rotation_degrees = 360 * rand
	#$weight.position = $player.position + Vector2(25 * cos(2 * PI * -rand), 25 * sin(2 * PI * -rand))
	#$weight.rotation_degrees = 360 * rand
	if global.highscore > 0:
		var footer = get_node("/root/splash/vbox/hbox_footer/footer")
		footer.set_text(String("High score %d" % global.highscore))
		footer.rect_size.x = viewportSize.x

func _draw():
	pass
	#draw_line($player.position, $weight.position, Color.white, 1.2, false)
	
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
