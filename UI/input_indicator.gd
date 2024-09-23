class_name InputIndicator
extends HBoxContainer

@onready var mnk_input_incidator: Texture2D = preload("res://addons/controller_icons/assets/mouse/left.png"):
	set = set_mouse_and_keyboard_icon
@onready var controller_input_indicator: Texture2D = preload("res://addons/controller_icons/assets/xboxseries/rt.png"):
	set = set_controller_icon

var input_text := "Bow":
	set = set_text

enum InputTypes {NOT_FOUND, MOUSE_AND_KEYBOARD, CONTROLLER}
var mouse_and_keyboard_inputs: Array = [
		InputEventKey,
		InputEventMouse,
		InputEventMouseButton,
		InputEventMouseMotion,
		]
var controller_inputs: Array = [
	InputEventJoypadButton,
	InputEventJoypadMotion,
]


func _ready():
	$InputText.text = input_text


func set_text(new_text: String):
	input_text = new_text


func set_new_textures(controller_texture: Texture2D, mnk_texture: Texture2D):
	set_controller_icon(controller_texture)
	set_mouse_and_keyboard_icon(mnk_texture)


func set_controller_icon(new_texture: Texture2D):
	controller_input_indicator = new_texture


func set_mouse_and_keyboard_icon(new_texture: Texture2D):
	mnk_input_incidator = new_texture


func check_input_type(event: InputEvent) -> InputTypes:
	if event is InputEventKey or event is InputEventMouse or event is InputEventMouseButton or event is InputEventMouseMotion:
		return InputTypes.MOUSE_AND_KEYBOARD
	
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		return InputTypes.CONTROLLER
	
	return InputTypes.NOT_FOUND


func _unhandled_input(event: InputEvent):
	var event_type := check_input_type(event)
	if event_type == InputTypes.MOUSE_AND_KEYBOARD:
		# Use spacebar image
		$InputIcon.texture = mnk_input_incidator
	elif event_type == InputTypes.CONTROLLER:
		# Use A image
		$InputIcon.texture = controller_input_indicator
