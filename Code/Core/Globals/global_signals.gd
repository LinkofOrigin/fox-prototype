extends Node

@warning_ignore("unused_signal")
signal sequence_state_updated(new_sequence: SequenceState)
@warning_ignore("unused_signal")
signal combat_started # TODO: Update this to an "Encounter" object/system
@warning_ignore("unused_signal")
signal combat_ended # TODO: Update this to an "Encounter" object/system
@warning_ignore("unused_signal")
signal player_defeated
@warning_ignore("unused_signal")
signal level_ready(level: Level)
@warning_ignore("unused_signal")
signal level_exiting_tree(level: Level)
@warning_ignore("unused_signal")
signal level_exited_tree(level: Level)
