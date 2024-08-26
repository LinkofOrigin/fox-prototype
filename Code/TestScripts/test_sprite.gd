extends Node2D

signal player_entered_shape


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		print("test sprite detected player")
		player_entered_shape.emit()
