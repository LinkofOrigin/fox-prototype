extends Node


@onready var FadeTransition: PackedScene = preload("res://UI/fade_transition.tscn")

enum Scenes {DEBUG, TITLE, TOWN, COMBAT, END, GAME_OVER}
const scene_paths: Dictionary = {
	Scenes.TITLE: "res://UI/Screens/TitleScreen.tscn",
	Scenes.TOWN: "res://TestScenes/Proto1/town_scene.tscn",
	Scenes.COMBAT: "res://TestScenes/Proto1/combat_scene.tscn",
	Scenes.END: "res://TestScenes/Proto1/end_scene.tscn",
	Scenes.GAME_OVER: "res://UI/Screens/GameOverScreen.tscn",
}

var _current_scene: int = -1
var _last_scene: int = -1
var _fade_screen: ColorRect

var _currently_loading_scene: bool = false
var _current_loading_scene_path: String
var _screen_is_faded: bool = false


func _ready():
	_fade_screen = FadeTransition.instantiate()
	add_child(_fade_screen)


func _process(_delta: float):
	if _currently_loading_scene:
		check_for_loaded_scene()


func check_for_loaded_scene():
	if _screen_is_faded: # Wait until the screen has fully faded
		var progress = ResourceLoader.load_threaded_get_status(_current_loading_scene_path)
		if progress == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			var new_packed_scene = ResourceLoader.load_threaded_get(_current_loading_scene_path)
			get_tree().change_scene_to_packed(new_packed_scene)
			fade_screen_in()
			_currently_loading_scene = false


func switch_to_scene(scene: Scenes):
	_current_loading_scene_path = scene_paths[scene]
	ResourceLoader.load_threaded_request(_current_loading_scene_path)
	fade_screen_out()
	# TODO: Block player control
	_currently_loading_scene = true
	_last_scene = _current_scene
	_current_scene = scene


func switch_to_last_scene() -> bool:
	# TODO: Possibly make this smarter, but need a valid scenario to care enough
	if _last_scene != -1:
		switch_to_scene(_last_scene)
		return true
	else:
		return false


func get_last_scene() -> Scenes:
	return _last_scene as Scenes


func fade_screen_out():
	var fade_tween = fade_screen_to_alpha(1)
	fade_tween.finished.connect(_handle_screen_finished_fading)


func fade_screen_in():
	_screen_is_faded = false
	var fade_tween = fade_screen_to_alpha(0)
	fade_tween.finished.connect(_handle_screen_finished_unfading)


func fade_screen_to_alpha(alpha_value: float) -> Tween:
	var new_color = _fade_screen.color
	new_color.a = alpha_value
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(_fade_screen, "color", new_color, 1)
	return fade_tween


func _new_scene_ready():
	print("a new scene is ready!")


func _handle_screen_finished_fading():
	_screen_is_faded = true


func _handle_screen_finished_unfading():
	# TODO: Return control to player
	_screen_is_faded = false
