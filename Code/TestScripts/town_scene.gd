class_name TownScene
extends Level


@onready var flatwoods: Node2D = %Flatwoods
@onready var draco: Node2D = %Dracomachina
@onready var cutscene_resource: CutsceneResource = preload("res://Resources/Cutscenes/cutscene_resource.tres")

var _player_portrait: Texture2D = preload("res://Assets/Sprites/FoxPortrait.png")
var _flatwoods_portrait: Texture2D = preload("res://Assets/Sprites/FlatwoodsPortrait.png")
var _draco_portrait: Texture2D = preload("res://Assets/Sprites/DracoPortrait.png")
var _flatwoods_can_talk: bool = false
var _draco_can_talk: bool = false
var _repeat_cutscene_lockout_counter: int = 0
var _repeat_cutscene_lockout_frames: int = 5
var _repeat_cutscene_lockout: bool = false


func _ready():
	initialize(SceneRegistry.Scenes.TOWN)
	_resolve_current_state()
	CutsceneManager.cutscene_ended.connect(_on_cutscene_ended)


func _process(_delta: float):
	if _repeat_cutscene_lockout:
		_repeat_cutscene_lockout_counter += 1
		if _repeat_cutscene_lockout_counter >= _repeat_cutscene_lockout_frames:
			_repeat_cutscene_lockout = false
			_repeat_cutscene_lockout_counter = 0


func _resolve_current_state():
	var combat_sequence = SequenceStateStorage.Combat
	if combat_sequence.get_state_value(combat_sequence.States.ENEMIES_DEFEATED):
		sequence.update_state_value(sequence.States.AFTER_ENEMIES_DEFEATED, true)


func _get_flatwoods_cutscene_steps() -> Array[Dictionary]:
	if not sequence.get_state_value(sequence.States.AFTER_ENEMIES_DEFEATED):
		return [
				{
					"camera_pos": "player_pos",
					"display_dialogue": true,
					"portrait": 1,
					"dialogue_portrait_right": _flatwoods_portrait,
					"text": "I hope the corruption doesn’t reach us here…"
				},
				{
					"camera_pos": "player_pos",
					"display_dialogue": true,
					"portrait": 0,
					"dialogue_portrait_left": _player_portrait,
					"text": "I didn't realize it was getting so close. I need to act soon"
				}
				]
	else:
		return [
				{
					"camera_pos": "player_pos",
					"display_dialogue": true,
					"portrait": 1,
					"dialogue_portrait_right": _flatwoods_portrait,
					"text": "It’s close, I can feel it…"
				}
				]


func _get_draco_cutscene_steps() -> Array[Dictionary]:
	if not sequence.get_state_value(sequence.States.AFTER_ENEMIES_DEFEATED):
		return [
				{
					"camera_pos": "player_pos",
					"display_dialogue": true,
					"portrait": 1,
					"dialogue_portrait_right": _draco_portrait,
					"text": "Help! Monsters invade from the East!"
				},
				{
					"camera_pos": "player_pos",
					"display_dialogue": true,
					"portrait": 0,
					"dialogue_portrait_left": _player_portrait,
					"text": "East! I'll head there now!"
				}
				]
	else:
		return [
				{
					"camera_pos": "player_pos",
					"display_dialogue": true,
					"portrait": 1,
					"dialogue_portrait_right": _draco_portrait,
					"text": "Thank you for saving us!"
				}
				]


func _on_flatwoods_dialogue_detector_body_entered(_body: Node2D):
	_flatwoods_can_talk = true


func _on_flatwoods_dialogue_detector_body_exited(_body: Node2D):
	_flatwoods_can_talk = false


func _on_draco_dialogue_detector_body_entered(_body: Node2D):
	_draco_can_talk = true


func _on_draco_dialogue_detector_body_exited(_body: Node2D):
	_draco_can_talk = false


func _input(_event: InputEvent):
	if Input.is_action_just_released(InputActions.MenuActions.MENU_CONFIRM) and not CutsceneManager.cutscene_is_playing() and not _repeat_cutscene_lockout:
		if _flatwoods_can_talk:
			cutscene_resource.set_cutscene_steps(_get_flatwoods_cutscene_steps())
			CutsceneManager.set_cutscene_data(cutscene_resource)
			CutsceneManager.play_cutscene()
		elif _draco_can_talk:
			cutscene_resource.set_cutscene_steps(_get_draco_cutscene_steps())
			CutsceneManager.set_cutscene_data(cutscene_resource)
			CutsceneManager.play_cutscene()


func _on_cutscene_ended():
	_repeat_cutscene_lockout = true


func _on_level_transition_body_entered(_body: Node2D):
	print("transitioning to COMBAT")
	SceneManager.switch_to_scene(SceneRegistry.Scenes.COMBAT)
