extends Node2D

@onready var flatwoods: Node2D = %Flatwoods
@onready var draco: Node2D = %Dracomachina
@onready var dialogue_base: DialogueBase = $DialogueBase
@onready var cutscene_resource: CutsceneResource = preload("res://Resources/Cutscenes/cutscene_resource.tres")

var sequence := SequenceStateStorage.Town
var _player_portrait: Texture2D = preload("res://Assets/Sprites/FoxPortrait.png")
var _flatwoods_portrait: Texture2D = preload("res://Assets/Sprites/FlatwoodsPortrait.png")
var _draco_portrait: Texture2D = preload("res://Assets/Sprites/DracoPortrait.png")
var _flatwoods_can_talk: bool = false
var _draco_can_talk: bool = false
var _cutscene_steps: Array
var _repeat_cutscene_lockout_counter: int = 0
var _repeat_cutscene_lockout_frames: int = 5
var _repeat_cutscene_lockout: bool = false


func _ready():
	# TODO: Handle loading different scenario state
	_resolve_current_state()
	dialogue_base.set_left_portrait(_player_portrait)
	cutscene_resource.set_dialogue_base(dialogue_base)
	CutsceneManager.cutscene_ended.connect(_on_cutscene_ended)


func _process(delta: float):
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
				"display_dialogue": true,
				"camera_pos": "player_pos",
				"portrait": 1,
				"text": "I hope the corruption doesn’t reach us here…"
			},
			{
				"display_dialogue": true,
				"camera_pos": "player_pos",
				"portrait": 0,
				"text": "I didn't realize it was getting so close. I need to act soon"
			}
		]
	else:
		return [
			{
				"display_dialogue": true,
				"camera_pos": "player_pos",
				"portrait": 1,
				"text": "It’s close, I can feel it…"
			}
		]


func _get_draco_cutscene_steps() -> Array[Dictionary]:
	if not sequence.get_state_value(sequence.States.AFTER_ENEMIES_DEFEATED):
		return [
			{
				"display_dialogue": true,
				"camera_pos": "player_pos",
				"portrait": 1,
				"text": "Help! Monsters invade from the East!"
			},
			{
				"display_dialogue": true,
				"camera_pos": "player_pos",
				"portrait": 0,
				"text": "East! I'll head there now!"
			}
		]
	else:
		return [
			{
				"display_dialogue": true,
				"camera_pos": "player_pos",
				"portrait": 1,
				"text": "Thank you for saving us!"
			}
		]


func _on_flatwoods_dialogue_detector_body_entered(body):
	_flatwoods_can_talk = true


func _on_flatwoods_dialogue_detector_body_exited(body):
	_flatwoods_can_talk = false


func _on_draco_dialogue_detector_body_entered(body):
	_draco_can_talk = true


func _on_draco_dialogue_detector_body_exited(body):
	_draco_can_talk = false


func _input(event: InputEvent):
	if Input.is_action_just_released("ProgressDialogue") and not CutsceneManager.cutscene_is_playing() and not _repeat_cutscene_lockout:
		if _flatwoods_can_talk:
			dialogue_base.set_right_portrait(_flatwoods_portrait)
			cutscene_resource.set_cutscene_steps(_get_flatwoods_cutscene_steps())
			CutsceneManager.set_cutscene_data(cutscene_resource)
			CutsceneManager.play_cutscene()
		elif _draco_can_talk:
			dialogue_base.set_right_portrait(_draco_portrait)
			cutscene_resource.set_cutscene_steps(_get_draco_cutscene_steps())
			CutsceneManager.set_cutscene_data(cutscene_resource)
			CutsceneManager.play_cutscene()


func _on_cutscene_ended():
	_repeat_cutscene_lockout = true


func _on_level_transition_body_entered(body):
	get_tree().change_scene_to_file.call_deferred("res://TestScenes/Proto1/combat_scene.tscn")
