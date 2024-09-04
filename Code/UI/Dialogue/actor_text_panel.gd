class_name ActorTextPanel
extends Control


signal player_progressed_dialogue

@onready var left_portrait: TextureRect = $LeftPortrait
@onready var right_portrait: TextureRect = $RightPortrait
@onready var left_portrait_panel: Panel = %LeftPortraitPanel
@onready var right_portrait_panel: Panel = %RightPortraitPanel
@onready var textbox: TextboxCont = $TextboxCont

var _current_lockout_counter: int = 0
var _input_lockout_frames: int = 5
var _is_input_locked: bool = false
var _in_text_mode: bool = false


func _ready():
	left_portrait.visible = false
	right_portrait.visible = false


func _process(delta: float):
	if _is_input_locked:
		_current_lockout_counter += 1
		if _current_lockout_counter >= _input_lockout_frames:
			_is_input_locked = false
			_current_lockout_counter = 0


func enable_text_mode():
	_in_text_mode = true
	_is_input_locked = true


func disable_text_mode():
	_in_text_mode = false


func use_left_portrait_with_text(new_text: String):
	right_portrait.visible = false
	left_portrait.visible = true
	set_text_content(new_text)


func use_right_portrait_with_text(new_text: String):
	left_portrait.visible = false
	right_portrait.visible = true
	set_text_content(new_text)


func set_left_portrait_sprite(new_left_portrait_texture: Texture2D):
	left_portrait_panel.get_theme_stylebox("panel").set_texture(new_left_portrait_texture)


func set_right_portrait_sprite(new_right_portrait_texture: Texture2D):
	right_portrait_panel.get_theme_stylebox("panel").set_texture(new_right_portrait_texture)


func set_text_content(new_text: String):
	textbox.set_text_content(new_text)


func _input(event: InputEvent):
	if _in_text_mode and not _is_input_locked and Input.is_action_just_released("ProgressDialogue"):
		_is_input_locked = true
		player_progressed_dialogue.emit()
