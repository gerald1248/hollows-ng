extends Node2D

func _ready():
	get_tree().set_auto_accept_quit(false)
	get_tree().set_quit_on_go_back(false)
	get_tree().get_root().connect("size_changed", self, "on_window_resized")
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
		MainLoop.NOTIFICATION_WM_ABOUT:
			show_credits()

func show_credits():
	var dialog = get_node("hud/credits_dialog")
	dialog.get_close_button().hide()
	dialog.set_text(global.CREDITS_FULL)
	dialog.set_as_toplevel(true)
	dialog.popup_centered_minsize()

func pause():
	get_node("hud/continue-container").show()
	get_tree().paused = true

func on_window_resized():
	var size = get_viewport().get_visible_rect().size
	$player.screensize = size
	$hud.layout(size)
