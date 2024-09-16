extends Control


func _on_try_again_button_pressed():
	# TODO: Get the current scene and reload the starting state
	var switch_successful = SceneManager.switch_to_last_scene()
	if not switch_successful:
		SceneManager.switch_to_scene(SceneManager.Scenes.TITLE)


func _on_restart_button_pressed():
	# TODO: Reset game state
	SequenceStateStorage.reset_all_sequences()
	SceneManager.switch_to_scene(SceneManager.Scenes.TOWN)


func _on_title_screen_button_pressed():
	SceneManager.switch_to_scene(SceneManager.Scenes.TITLE)
