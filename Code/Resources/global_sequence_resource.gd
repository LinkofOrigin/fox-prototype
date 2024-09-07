class_name GlobalSequenceResource
extends Resource


# TODO: Figure out sequence storage
var _local_sequences: Dictionary


func load_sequence_state(sequence_id: String) -> Dictionary:
	if _local_sequences.has(sequence_id):
		return _local_sequences[sequence_id].get_state()
	else:
		return {}


func save_local_sequence(sequence_state: SequenceState):
	print("saving a local sequence! ", sequence_state)
	_local_sequences[sequence_state.id] = sequence_state
