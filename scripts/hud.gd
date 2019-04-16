extends CanvasLayer

var alertCount = 0

func _ready():
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
