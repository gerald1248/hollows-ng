extends Node2D

func _ready():
	get_tree().set_auto_accept_quit(false)
	get_tree().set_quit_on_go_back(false)

	var playLoop = global.loop

	# finale
	if global.level_index == global.level_count - 1 && global.loop || global.fx:
		playLoop = true

	if playLoop:
		var loop = global.loops[global.loop_index]
		get_node(loop).play()
	if global.fx:
		get_node("/root/main/sample-fly").play()

func _notification(what):
	match (what):
		MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			pause()
		MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
			pause()
		MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
			get_tree().quit()

func pause():
	get_node("hud/continue-container").show()
	get_tree().paused = true