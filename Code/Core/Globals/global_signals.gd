extends Node

@warning_ignore("unused_signal")
@warning_ignore("unused_signal")
signal scene_loading(loading_scene: SceneManager.Scenes)
@warning_ignore("unused_signal")
signal scene_unloading(unloading_scene: SceneManager.Scenes)
@warning_ignore("unused_signal")
signal sequence_state_updated(new_sequence: SequenceState)
@warning_ignore("unused_signal")
signal combat_started # TODO: Update this to an "Encounter" object/system
@warning_ignore("unused_signal")
signal combat_ended # TODO: Update this to an "Encounter" object/system
