extends Level


func _ready():
	initialize(SceneRegistry.Scenes.GAME_OVER)
	
	%TryAgainButton.grab_focus.call_deferred()


func _on_try_again_button_pressed():
	var switch_successful = SceneManager.switch_to_last_scene()
	if not switch_successful:
		SceneManager.switch_to_scene(SceneRegistry.Scenes.TITLE)


func _on_restart_button_pressed():
	SequenceStateStorage.reset_all_sequences()
	SceneManager.switch_to_scene(SceneRegistry.Scenes.TOWN)


func _on_title_screen_button_pressed():
	SceneManager.switch_to_scene(SceneRegistry.Scenes.TITLE)
