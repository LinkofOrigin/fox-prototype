extends Node
## A large global class for managing "Sequences"
## A Sequence represents an indivudal and overall state of the game. Beating a key boss,
## visiting a town for the first time, and acquiring an important item could all trigger
## an update of the current Sequence.

var global_sequence_resource: GlobalSequenceResource = preload("res://Resources/Sequences/global_sequence_resource.tres")
var current_local_sequence: LocalSequence
var _current_sequence: int = 0:
	get = get_current_sequence


func _ready():
	GlobalSignals.local_sequence_loaded.connect(_on_local_sequence_loaded)
	GlobalSignals.local_sequence_updated.connect(_on_local_sequence_updated)


func load_local_sequence(sequence_id: String):
	return global_sequence_resource.load_local_sequence(sequence_id)
	


func get_current_sequence():
	return _current_sequence


func update_current_sequence(local_sequence):
	current_local_sequence = local_sequence
	#global_sequence_resource.save_local_sequence(local_sequence)


func _handle_test_signal():
	print("test signal!")


func _on_local_sequence_updated(local_sequence: LocalSequence):
	print("Manager- A local sequence updated! ", local_sequence)
	update_current_sequence(local_sequence)


func _on_local_sequence_loaded(local_sequence: LocalSequence):
	global_sequence_resource.save_local_sequence(current_local_sequence)
	current_local_sequence = local_sequence
