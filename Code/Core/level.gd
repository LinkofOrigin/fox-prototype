class_name Level
extends Node

var id: SceneRegistry.Scenes
var sequence: SequenceState


func initialize(level_id: SceneRegistry.Scenes):
	id = level_id
	sequence = SceneRegistry.get_sequence_for_scene(id)
	
	tree_exiting.connect(_on_tree_exiting)
	tree_exited.connect(_on_tree_exited)
	GlobalSignals.level_ready.emit(self)


func _on_tree_exiting():
	GlobalSignals.level_exiting_tree.emit(self)


func _on_tree_exited():
	GlobalSignals.level_exited_tree.emit(self)
