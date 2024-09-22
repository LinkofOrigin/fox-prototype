extends Level


func _ready():
	initialize(SceneRegistry.Scenes.TITLE)
	
	%PlayButton.grab_focus.call_deferred()


func _on_play_button_pressed():
	SceneManager.switch_to_scene(SceneRegistry.Scenes.TOWN)
