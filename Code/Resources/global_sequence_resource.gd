class_name GlobalSequenceResource
extends Resource

var _global_sequences: Dictionary
var _local_sequences: Dictionary


# TODO: Figure out what global sequences look like
func _register_new_global_sequence(local_sequence: LocalSequence):
	pass


func save_global_sequence(local_sequence: LocalSequence):
	pass


func load_global_sequence(sequence_name: String):
	pass


func _register_new_local_sequence(local_sequence: LocalSequence):
	pass


func save_local_sequence(local_sequence: LocalSequence):
	print("saving a local sequence! ", local_sequence)
	pass


func load_local_sequence(sequence_name: String):
	pass
