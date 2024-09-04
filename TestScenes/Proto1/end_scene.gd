extends Node2D



func _on_left_transition_body_entered(body: Node2D):
	get_tree().change_scene_to_file.call_deferred("res://TestScenes/Proto1/combat_scene.tscn")
