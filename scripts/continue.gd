extends Button

func _ready():
	pass

func _pressed():
	get_parent().hide()
	get_tree().paused = false
