class_name TextboxCont
extends VBoxContainer

@onready var text_content_label: Label = %Label

func set_text_content(new_text: String):
	text_content_label.text = new_text
