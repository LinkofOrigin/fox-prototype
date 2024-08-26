class_name LocalSequence
extends Node

@export var sequences: Array[String] # TODO: Make this an object instead of strings?


func _ready():
	GlobalSignals.local_sequence_entered_tree.emit(self)


func _handle_sequence_update():
	pass
