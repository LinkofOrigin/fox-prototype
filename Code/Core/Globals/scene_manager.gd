extends Node

enum Scenes {DEBUG, TITLE, TOWN, COMBAT, END, GAME_OVER}
const scene_paths: Dictionary = {
	Scenes.TITLE: "res://UI/Screens/TitleScreen.tscn",
	Scenes.TOWN: "res://TestScenes/Proto1/town_scene.tscn",
	Scenes.COMBAT: "res://TestScenes/Proto1/combat_scene.tscn",
	Scenes.END: "res://TestScenes/Proto1/end_scene.tscn",
	Scenes.GAME_OVER: "res://UI/Screens/GameOverScreen.tscn",
}

var _current_scene
var _last_scene


func switch_to_scene(scene: Scenes):
	GlobalSignals.scene_unloading.emit(_current_scene)
	get_tree().change_scene_to_file.call_deferred(scene_paths[scene])
	GlobalSignals.scene_loading.emit(scene)
	
	_last_scene = _current_scene
	_current_scene = scene


func get_last_scene() -> Scenes:
	return _last_scene
