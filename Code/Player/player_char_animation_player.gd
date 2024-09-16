extends AnimationPlayer

const ANIMATIONS: Dictionary = {
		IDLE = "Idle",
		WALK = "Walk",
		DRAW_BOW = "DrawBow",
		BOW_DRAWN = "BowDrawn",
		FIRE_BOW = "FireBow",
		DEATH = "Death",
		}


func _on_current_animation_changed(anim_name: StringName):
	print("animation is now: ", anim_name)


func _on_animation_changed(_old_name: StringName, new_name: StringName):
	print("animation from queue, is now: ", new_name)
