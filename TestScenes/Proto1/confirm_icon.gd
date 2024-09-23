extends TextureRect


@onready var mouse_and_keyboard_confirm: Texture2D = preload("res://addons/controller_icons/assets/key/space.png")
@onready var controller_confirm: Texture2D = preload("res://addons/controller_icons/assets/xboxseries/a.png")

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
		texture = mouse_and_keyboard_confirm
	elif event_type == InputTypes.CONTROLLER:
		# Use A image
		texture = controller_confirm
