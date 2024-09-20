extends AnimationPlayer

const ANIMATIONS: Dictionary = {
		IDLE = "Idle",
		WALK = "Walk",
		DRAW_BOW = "DrawBow",
		BOW_DRAWN = "BowDrawn",
		FIRE_BOW = "FireBow",
		DEATH = "Death",
		}


func _on_current_animation_changed(_anim_name: StringName):
	#print("animation is now: ", anim_name)
	pass


func _on_animation_changed(_old_name: StringName, _new_name: StringName):
	#print("animation from queue, is now: ", new_name)
	pass
