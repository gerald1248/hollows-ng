extends Area2D

func _ready():
	if global.is_dark_level():
		$Sprite.modulate = Color("#111")
		
func _on_brick_area_entered(area):
	pass # laser registers collision more reliably

func _on_brick_body_entered(body):
	match body.name:
		"player":
			get_parent().get_node("player").explode()
		"weight":
			destroy()
			global.add_to_score(100)
			if global.fx:
				get_node("/root/main/sample-explosion-brick").play()

func destroy():
	queue_free()