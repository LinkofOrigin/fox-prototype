class_name LevelSceneWithSequence
extends Node2D


func _enter_tree():
	tree_entered.connect(_on_tree_entered)
	tree_exiting.connect(_on_tree_exiting)


func get_scene_id() -> SceneManager.Scenes:
	return SceneManager.Scenes.DEBUG


func _on_tree_entered():
	GlobalSignals.scene_loading.emit(get_scene_id())


func _on_tree_exiting():
	GlobalSignals.scene_unloading.emit(get_scene_id())
