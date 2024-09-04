class_name CutsceneResource
extends Resource


signal player_pressed_to_progress


var cutscene_steps: Array:
	set = set_cutscene_steps,
	get = get_cutscene_steps
var dialogue_base: DialogueBase:
	set = set_dialogue_base


func set_cutscene_steps(full_steps: Array):
	cutscene_steps = full_steps


func get_cutscene_steps() -> Array:
	return cutscene_steps


func set_dialogue_base(new_dialogue_base: DialogueBase):
	dialogue_base = new_dialogue_base
