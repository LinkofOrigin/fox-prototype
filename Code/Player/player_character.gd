class_name PlayerCharacter
extends CharacterBody2D


func play_animation(animation: String):
	%AnimationPlayer.play(animation)


func get_animation_finished_signal():
	return %FoxAnimSprite.animation_finished
