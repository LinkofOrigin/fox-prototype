extends Node

@warning_ignore("unused_signal")
signal test_signal
@warning_ignore("unused_signal")
signal local_sequence_loaded(local_sequence: LocalSequence)
@warning_ignore("unused_signal")
signal local_sequence_unloading(local_sequence: LocalSequence)
@warning_ignore("unused_signal")
signal local_sequence_updated(new_sequence: LocalSequence)
@warning_ignore("unused_signal")
signal combat_started # TODO: Update this to an "Encounter" object/system
@warning_ignore("unused_signal")
signal combat_ended # TODO: Update this to an "Encounter" object/system
