extends LevelSceneWithSequence

const _player_portrait: Texture2D = preload("res://Assets/Sprites/FoxPortrait.png")
const _entity_portrait: Texture2D = preload("res://Assets/Sprites/HellhandsPortrait.png")


func get_scene_id() -> SceneManager.Scenes:
	return SceneManager.Scenes.END


func _play_end_cutscene():
	var cutscene_resource = CutsceneResource.new()
	
	cutscene_resource.set_cutscene_steps([
			{
				"wait_time": 2,
			},
			{
				"camera_zoom": 1.3,
				"camera_time": 0.7,
			},
			{
				"display_dialogue": true,
				"portrait": 0,
				"dialogue_portrait_left": _player_portrait,
				"text": "...",
			},
			{
				"display_dialogue": true,
				"portrait": 0,
				"dialogue_portrait_left": _player_portrait,
				"text": "This energy… it’s… not right…",
			},
			{
				"camera_zoom": 1.1,
				"camera_time": 0.4,
				"display_dialogue": true,
				"portrait": 1,
				"dialogue_portrait_right": _entity_portrait,
				"text": "You seek righteousness, but you will find only truth.",
			},
			{
				"camera_zoom": 1.1,
				"camera_time": 0.5,
				"display_dialogue": true,
				"portrait": 1,
				"dialogue_portrait_right": _entity_portrait,
				"text": "What you sense now is TRUTH. If you are not ready for it, it will swallow you.",
			},
			{
				"display_dialogue": true,
				"text": "The hero is at an impasse.",
			},
			{
				"display_dialogue": true,
				"text": "What decisions remain available?",
			},
			{
				"display_dialogue": true,
				"text": "Is victory all but lost?",
			},
			{
				"camera_zoom": 1.2,
				"camera_time": 2,
				"animation": "player_death",
				"wait_time": 3,
			},
			{
				"display_dialogue": true,
				"text": "GAME OVER",
			},
			])
	CutsceneManager.play_cutscene(cutscene_resource)


func _on_left_transition_body_entered(_body: Node2D):
	get_tree().change_scene_to_file.call_deferred("res://TestScenes/Proto1/combat_scene.tscn")


func _on_cutscene_trigger_body_entered(_body: Node2D):
	_play_end_cutscene()
