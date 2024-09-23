class_name PlayerCharacter
extends CharacterBody2D


func play_animation(animation: String):
	%AnimationPlayer.play(animation)

func trigger_death():
	$HealthC.remove_health($HealthC.curr_health)
	%SimpleBow.visible = false
