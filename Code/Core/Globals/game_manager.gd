extends Node


var _player_defeated: bool = false


func _ready():
	GlobalSignals.player_defeated.connect(_on_player_defeated)
	CutsceneManager.cutscene_ended.connect(_on_cutscene_ended)


func handle_player_death():
	pass


func reset_game():
	pass


func _on_player_defeated():
	_player_defeated = true
	var cutscene_resource = CutsceneResource.new()
	cutscene_resource.set_cutscene_steps([
			
			{
				"camera_zoom": 1.2,
				"camera_time": 4,
				"animation": "Death",
				"wait_time": 4,
			},
			])
	CutsceneManager.play_cutscene(cutscene_resource)


func _on_cutscene_ended():
	if _player_defeated:
		SceneManager.switch_to_scene(SceneRegistry.Scenes.GAME_OVER)
