extends Node


func _ready():
	GlobalSignals.player_defeated.connect(_on_player_defeated)


func handle_player_death():
	pass


func reset_game():
	pass


func _on_player_defeated():
	if not CutsceneManager.cutscene_is_playing():
		var cutscene_resource = CutsceneResource.new()
		cutscene_resource.set_cutscene_steps([
				{
					"camera_zoom": 1.2,
					"camera_time": 4,
					"animation": "Death",
					"wait_time": 4,
				},
				{
					"scene_transition": SceneRegistry.Scenes.GAME_OVER,
				},
				])
		CutsceneManager.play_cutscene(cutscene_resource)
