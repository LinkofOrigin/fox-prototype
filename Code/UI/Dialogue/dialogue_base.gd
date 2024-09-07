class_name DialogueBase
extends CanvasLayer

@onready var actor_text_panel: ActorTextPanel = %ActorTextPanel


func _ready():
	visible = false


func get_player_progressed_dialogue_signal() -> Signal:
	return actor_text_panel.player_progressed_dialogue


func display_dialogue():
	set_process_input(true)
	actor_text_panel.enable_text_mode()
	visible = true


func hide_dialogue():
	set_process_input(false)
	actor_text_panel.disable_text_mode()
	visible = false


func show_no_portrait_with_text(new_text: String):
	actor_text_panel.use_no_portrait_with_text(new_text)


func show_left_portrait_with_text(new_text: String):
	actor_text_panel.use_left_portrait_with_text(new_text)


func show_right_portrait_with_text(new_text: String):
	actor_text_panel.use_right_portrait_with_text(new_text)


func set_left_portrait(new_portrait: Texture2D):
	actor_text_panel.set_left_portrait_sprite(new_portrait)


func set_right_portrait(new_portrait: Texture2D):
	actor_text_panel.set_right_portrait_sprite(new_portrait)


func set_portraits(left_portrait: Texture2D, right_portrait: Texture2D):
	set_left_portrait(left_portrait)
	set_right_portrait(right_portrait)
