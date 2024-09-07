class_name PlayerCharacter
extends CharacterBody2D


func play_animation(animation: String):
	if animation == "player_death":
		$FoxAnimSprite.play("Death")


func get_animation_finished_signal():
	return $FoxAnimSprite.animation_finished
