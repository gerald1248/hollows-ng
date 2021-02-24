extends CanvasLayer

var alertCount = 0

func _ready():
	$vbox.rect_position = Vector2()
	$vbox.rect_size = global.viewport_size

	if global.is_iphone_x:
		get_node("vbox/topbar/padding-left").rect_min_size = Vector2(global.hud_padding, 0)
		get_node("vbox/topbar/padding-right").rect_min_size = Vector2(global.hud_padding, 0)
		get_node("vbox/padding-top").rect_min_size = Vector2(0.0, global.hud_padding)
	else:
		get_node("vbox/topbar/padding-left").hide()
		get_node("vbox/topbar/padding-right").hide()
		get_node("vbox/padding-top").hide()

	layout(get_viewport().get_visible_rect().size)
	update_score(global.score)

	var idx = 0
	for i in global.lives:
		var n = get_node("/root/main/hud/vbox/topbar/righttemplate").duplicate()
		n.name = "right" + str(idx)
		n.get_node("playerbmp").offset.x = idx * 8
		get_node("/root/main/hud/vbox/topbar/").add_child(n)
		get_node("/root/main/hud/vbox/topbar/").move_child(n, 3)
		idx += 1
	get_node("/root/main/hud/vbox/topbar/righttemplate").hide()

	# training
	if global.level_index == 0 && !global.is_desktop:
		get_node("training-fire-rect").show()
		get_node("training-turn-rect").show()
		get_node("training-thrust-rect").show()
		get_node("training-animation").play("training")
	
	# desktop
	if global.is_desktop:
		$"turn-indicator".hide()
		$"fire-indicator".hide()
		$"thrust-indicator".hide()
		if global.level_index == 0:
			$"desktop-training".show()

func layout(size):
	$vbox.rect_size = size

	$"training-turn-rect".rect_size.x = size.x/2
	$"training-turn-rect".rect_size.y = size.y * 0.3	
	$"training-turn-rect".rect_position.x = 0.0
	$"training-turn-rect".rect_position.y = size.y * 0.7
	$"training-turn-rect".rect_pivot_offset.x = size.x/4
	$"training-turn-rect".rect_pivot_offset.y = size.y * 0.15

	$"training-fire-rect".rect_size.x = size.x * 0.25
	$"training-fire-rect".rect_size.y = size.y * 0.3
	$"training-fire-rect".rect_position.x = size.x * 0.5
	$"training-fire-rect".rect_position.y = size.y * 0.7
	$"training-fire-rect".rect_pivot_offset.x = size.x/8
	$"training-fire-rect".rect_pivot_offset.y = size.y * 0.15

	$"training-thrust-rect".rect_size.x = size.x * 0.25
	$"training-thrust-rect".rect_size.y = size.y * 0.3
	$"training-thrust-rect".rect_position.x = size.x * 0.75
	$"training-thrust-rect".rect_position.y = size.y * 0.7
	$"training-thrust-rect".rect_pivot_offset.x = size.x/8
	$"training-thrust-rect".rect_pivot_offset.y = size.y * 0.15

	$"turn-indicator".offset.x = size.x/4
	$"turn-indicator".offset.y = size.y * 0.85
	$"fire-indicator".offset.x = size.x/2 + size.x/8
	$"fire-indicator".offset.y = size.y * 0.85
	$"thrust-indicator".offset.x = size.x - size.x/8
	$"thrust-indicator".offset.y = size.y * 0.85

	$credits.rect_position.y = size.y/2 + 16
	$credits.rect_size.x = size.x
	$"desktop-training".rect_position.y = size.y/2 + 16
	$"desktop-training".rect_size.x = size.x
	$"continue-container".rect_position.x = size.x/2 - 60
	$"continue-container".rect_position.y = size.y/2 - 8
	
	# if landscape *and* iPhone X, hide top padding
	if global.is_iphone_x:
		if size.x > size.y:
			get_node("vbox/padding-top").hide()
		else:
			get_node("vbox/padding-top").show()


func alert(s):
	alertCount = 100
	var alertNode = get_node("vbox/alertbar/alert")
	alertNode.text = s
	alertNode.show()

func _process(delta):
	if alertCount > 1:
		alertCount = alertCount - 1
	elif alertCount == 1:
		get_node("vbox/alertbar/alert").hide()
		alertCount = 0

func update_score(i):
	var value = String(i) if !global.DEBUG_SCREEN_RESOLUTION else String(global.viewport_size.x) + "x" + String(global.viewport_size.y) + " (" + OS.get_model_name() + ")"
	get_node("vbox/topbar/left/score").text = value
