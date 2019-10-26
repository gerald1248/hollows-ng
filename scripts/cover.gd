extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draw():
	# iPad _only_ requires a y-adjustment to the line drawn
	# 30 seems to be a workable offset
	draw_line($player.get_global_position(), $weight.get_global_position(), Color.white, 4, false)