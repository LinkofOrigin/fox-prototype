class_name CutsceneResource
extends Resource


var cutscene_steps: Array[Dictionary]:
	set = set_cutscene_steps,
	get = get_cutscene_steps


func set_cutscene_steps(full_steps: Array[Dictionary]):
	cutscene_steps = full_steps


func get_cutscene_steps() -> Array[Dictionary]:
	return cutscene_steps
