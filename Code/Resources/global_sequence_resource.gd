class_name GlobalSequenceResource
extends Resource


var _global_sequences: Dictionary
var _local_sequences: Dictionary
# TODO: Figure out sequence storage


# TODO: Figure out what global sequences look like
func _register_new_global_sequence(local_sequence: LocalSequence):
	pass


func load_global_sequence(sequence_id: String):
	if _global_sequences.has(sequence_id):
		return _global_sequences[sequence_id]
	else:
		return {}
	pass


func save_global_sequence(local_sequence: LocalSequence):
	# TODO: Should we serialize the local_sequence object and save that?
	pass


func load_local_sequence(sequence_id: String) -> Dictionary:
	if _local_sequences.has(sequence_id):
		return _local_sequences[sequence_id].get_state()
	else:
		return {}


func save_local_sequence(local_sequence: LocalSequence):
	print("saving a local sequence! ", local_sequence)
	_local_sequences[local_sequence.sequence_id] = local_sequence


# TODO: Do I need this?
func _register_new_local_sequence(local_sequence: LocalSequence):
	save_local_sequence(local_sequence)
