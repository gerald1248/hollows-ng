extends RigidBody2D

var deactivated = false

func _ready():
	if deactivated:
		mode = RigidBody2D.MODE_STATIC
		hide()


