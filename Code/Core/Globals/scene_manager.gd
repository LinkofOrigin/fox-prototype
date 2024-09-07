extends Node

enum Scenes {DEBUG, TOWN, COMBAT, END}

var _current_scene
var _last_scene


func _ready():
	GlobalSignals.scene_loading.connect(_on_scene_loading)
	GlobalSignals.scene_unloading.connect(_on_scene_unloading)


func get_last_scene() -> SceneManager.Scenes:
	return _last_scene


func _on_scene_loading(scene: SceneManager.Scenes):
	print("new scene loading! New Current Scene ID: ", scene)
	_current_scene = scene


func _on_scene_unloading(scene: SceneManager.Scenes):
	print("new scene unloading! New Last Scene ID: ", scene)
	_last_scene = scene
