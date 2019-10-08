extends CanvasLayer

var alertCount = 0

func _ready():
	layout(global.viewport_size)
	update_score(global.score)

	if global.lives < 5:
		get_node("vbox/topbar/right4/player04").hide()
	if global.lives < 4:
		get_node("vbox/topbar/right3/player03").hide()
	if global.lives < 3:
		get_node("vbox/topbar/right2/player02").hide()
	if global.lives < 2:
		get_node("vbox/topbar/right1/player01").hide()

	# training
	if global.level_index == 0:
		get_node("training-fire").show()
		get_node("training-turn").show()
		get_node("training-thrust").show()
		get_node("training-fire-rect").show()
		get_node("training-turn-rect").show()
		get_node("training-thrust-rect").show()
		get_node("training-animation").play("training")
	
	#$vbox.rect_position = OS.get_window_safe_area().position
	#$vbox.rect_size = OS.get_window_safe_area().size
	get_node("vbox/topbar").rect_size.x = $vbox.rect_size.x/4

func layout(viewport):
	pass
#	$alert.rect_size.x = viewport.x
#	$player01.transform.origin.x = viewport.x - 4
#	$player02.transform.origin.x = viewport.x - 12
#	$player03.transform.origin.x = viewport.x - 20
#	$player04.transform.origin.x = viewport.x - 28
#	$"training-fire".rect_size.x = viewport.x
#	$"training-turn".rect_size.x = viewport.x / 2
#	$"training-thrust".margin_left = viewport.x / 2
#	$"training-thrust".rect_size.x = viewport.x / 2
#	$"training-fire-rect".rect_size.x = viewport.x
#	$"training-fire-rect".rect_pivot_offset.x = viewport.x/2
#	$"training-fire-rect".rect_pivot_offset.y = viewport.y/4
#	$"training-turn-rect".rect_size.x = viewport.x/2
#	$"training-turn-rect".rect_position.y = viewport.y/2
#	$"training-turn-rect".rect_pivot_offset.x = viewport.x/4
#	$"training-turn-rect".rect_pivot_offset.y = viewport.y/4
#	$"training-thrust-rect".rect_size.x = viewport.x/2
#	$"training-thrust-rect".rect_position.x = viewport.x/2
#	$"training-thrust-rect".rect_position.y = viewport.y/2
#	$"training-thrust-rect".rect_pivot_offset.x = viewport.x/4
#	$"training-thrust-rect".rect_pivot_offset.y = viewport.y/4
#	$credits.rect_position.y = viewport.y/2 + 20
#	$credits.rect_size.x = viewport.x
#	$"continue-container".rect_position.x = viewport.x/2 - 60
#	$"continue-container".rect_position.y = viewport.y/2 - 8

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
	get_node("vbox/topbar/left/score").text = String(i)
