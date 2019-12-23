extends CanvasLayer

var alertCount = 0

func _ready():
	$vbox.rect_position = Vector2()
	$vbox.rect_size = global.viewport_size
	get_node("vbox/topbar/padding-left").rect_min_size = Vector2(global.hud_padding, 0)
	get_node("vbox/topbar/padding-right").rect_min_size = Vector2(global.hud_padding, 0)

	layout(global.viewport_size)
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
	if global.level_index == 0:
		get_node("training-fire").show()
		get_node("training-turn").show()
		get_node("training-thrust").show()
		get_node("training-fire-rect").show()
		get_node("training-turn-rect").show()
		get_node("training-thrust-rect").show()
		get_node("training-animation").play("training")	

func layout(viewport):
	$"training-fire".rect_size.x = viewport.x
	$"training-fire".rect_size.y = viewport.y/2

	$"training-turn".rect_size.x = viewport.x/2
	$"training-turn".rect_size.y = viewport.y/2
	$"training-turn".rect_position.y = viewport.y/2

	$"training-thrust".rect_size.x = viewport.x/2
	$"training-thrust".rect_size.y = viewport.y/2
	$"training-thrust".rect_position.x = viewport.x/2
	$"training-thrust".rect_position.y = viewport.y/2

	$"training-fire-rect".rect_size.x = viewport.x
	$"training-fire-rect".rect_size.y = viewport.y/2
	$"training-fire-rect".rect_pivot_offset.x = viewport.x/2
	$"training-fire-rect".rect_pivot_offset.y = viewport.y/4

	$"training-turn-rect".rect_size.x = viewport.x/2
	$"training-turn-rect".rect_size.y = viewport.y/2
	$"training-turn-rect".rect_position.y = viewport.y/2
	$"training-turn-rect".rect_pivot_offset.x = viewport.x/4
	$"training-turn-rect".rect_pivot_offset.y = viewport.y/4

	$"training-thrust-rect".rect_size.x = viewport.x/2
	$"training-thrust-rect".rect_size.y = viewport.y/2
	$"training-thrust-rect".rect_position.x = viewport.x/2
	$"training-thrust-rect".rect_position.y = viewport.y/2
	$"training-thrust-rect".rect_pivot_offset.x = viewport.x/4
	$"training-thrust-rect".rect_pivot_offset.y = viewport.y/4

	$credits.rect_position.y = viewport.y/2 + 16
	$credits.rect_size.x = viewport.x
	$"continue-container".rect_position.x = viewport.x/2 - 60
	$"continue-container".rect_position.y = viewport.y/2 - 8

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
