extends CanvasLayer

var alertCount = 0

func _ready():
	layout(global.viewport_size)
	update_score(global.score)

	if global.lives < 5:
		get_node("player04").hide()
	if global.lives < 4:
		get_node("player03").hide()
	if global.lives < 3:
		get_node("player02").hide()
	if global.lives < 2:
		get_node("player01").hide()

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
	$alert.rect_size.x = viewport.x
	$player01.transform.origin.x = viewport.x - 4
	$player02.transform.origin.x = viewport.x - 12
	$player03.transform.origin.x = viewport.x - 20
	$player04.transform.origin.x = viewport.x - 28
	$"training-fire".rect_size.x = viewport.x
	$"training-turn".rect_size.x = viewport.x / 2
	$"training-thrust".margin_left = viewport.x / 2
	$"training-thrust".rect_size.x = viewport.x / 2
	$"training-fire-rect".rect_size.x = viewport.x
	$"training-fire-rect".rect_pivot_offset.x = viewport.x/2
	$"training-fire-rect".rect_pivot_offset.y = viewport.y/4
	$"training-turn-rect".rect_size.x = viewport.x/2
	$"training-turn-rect".rect_position.y = viewport.y/2
	$"training-turn-rect".rect_pivot_offset.x = viewport.x/4
	$"training-turn-rect".rect_pivot_offset.y = viewport.y/4
	$"training-thrust-rect".rect_size.x = viewport.x/2
	$"training-thrust-rect".rect_position.x = viewport.x/2
	$"training-thrust-rect".rect_position.y = viewport.y/2
	$"training-thrust-rect".rect_pivot_offset.x = viewport.x/4
	$"training-thrust-rect".rect_pivot_offset.y = viewport.y/4
	$credits.rect_position.y = viewport.y/2 + 20
	$credits.rect_size.x = viewport.x
	$"continue-container".rect_position.x = viewport.x/2 - 60
	$"continue-container".rect_position.y = viewport.y/2 - 8

func alert(s):
	alertCount = 100
	var alertNode = get_node("alert")
	alertNode.text = s
	alertNode.show()

func _process(delta):
	if alertCount > 1:
		alertCount = alertCount - 1
	elif alertCount == 1:
		get_node("alert").hide()
		alertCount = 0

func update_score(i):
	$score.text = String(i)
