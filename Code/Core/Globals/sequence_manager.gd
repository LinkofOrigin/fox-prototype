extends Node
## A large global class for managing "Sequences"
## A Sequence represents an individual and overall state of the game. Beating a key boss,
## visiting a town for the first time, and acquiring an important item could all trigger
## an update of a Sequence.

# TODO: Eventually all sequence logic could be separated from level scenes and run off of signals
# - Downside: level code and logic isn't clearly tied to sequence updates and requires multiple files open just to work in
# - Although... Might be finding a way to mitigate that... or not...
var GlobalSequenceResource = preload("res://Resources/Sequences/global_sequence_resource.tres")


func _ready():
	#GlobalSignals.sequence_state_loaded.connect(_on_sequence_state_loaded)
	GlobalSignals.sequence_state_updated.connect(_on_sequence_state_updated)
	GlobalSignals.sequence_state_unloading.connect(_on_sequence_state_unloading)


func load_sequence_state(sequence_id: String) -> Dictionary:
	return GlobalSequenceResource.load_sequence_state(sequence_id)


func _handle_test_signal():
	print("test signal!")


func _on_sequence_state_updated(sequence_state: SequenceState):
	print("Sequence Manager - A local sequence updated! ", sequence_state)
	GlobalSequenceResource.save_local_sequence(sequence_state)


func _on_sequence_state_loaded(sequence_state: SequenceState):
	print("sequence loaded! ", sequence_state)


func _on_sequence_state_unloading(sequence_state: SequenceState):
	GlobalSequenceResource.save_local_sequence(sequence_state)
