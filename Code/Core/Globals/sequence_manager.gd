extends Node
## A large global class for managing "Sequences"
## A Sequence represents an indivudal and overall state of the game. Beating a key boss,
## visiting a town for the first time, and acquiring an important item could all trigger
## an update of the current Sequence.

var current_local_sequence: LocalSequence
var _current_sequence: int = 0:
	get = get_current_sequence

func _ready():
	GlobalSignals.test_signal.connect(_handle_test_signal)
	GlobalSignals.local_sequence_entered_tree.connect(_on_local_sequence_entered_tree)


func get_current_sequence():
	return _current_sequence


func update_sequence():
	pass


func _handle_test_signal():
	print("test signal!")

func _on_local_sequence_entered_tree(local_sequence: LocalSequence):
	current_local_sequence = local_sequence
