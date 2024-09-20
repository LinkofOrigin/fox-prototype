extends Level


func _ready():
	initialize(SceneRegistry.Scenes.TITLE)


func _on_play_button_pressed():
	SceneManager.switch_to_scene(SceneRegistry.Scenes.TOWN)
