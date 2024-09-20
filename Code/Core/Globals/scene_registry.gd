extends Node

enum Scenes {DEBUG, TITLE, TOWN, COMBAT, END, GAME_OVER}


var _scenes: Dictionary = {
	Scenes.TITLE: SceneData.new(Scenes.TITLE)
			.with_path("res://UI/Screens/title_screen.tscn"),
	Scenes.TOWN: SceneData.new(Scenes.TOWN)
			.with_sequence(SequenceStateStorage.Town)
			.with_path("res://TestScenes/Proto1/town_scene.tscn"),
	Scenes.COMBAT: SceneData.new(Scenes.COMBAT)
			.with_sequence(SequenceStateStorage.Combat)
			.with_path("res://TestScenes/Proto1/combat_scene.tscn"),
	Scenes.END: SceneData.new(Scenes.END)
			.with_sequence(SequenceStateStorage.End)
			.with_path("res://TestScenes/Proto1/end_scene.tscn"),
	Scenes.GAME_OVER: SceneData.new(Scenes.GAME_OVER)
			.with_path("res://UI/Screens/game_over_screen.tscn")
}


func get_path_for_scene(scene: Scenes) -> String:
	return (_scenes[scene] as SceneData).path


func get_sequence_for_scene(scene: Scenes) -> SequenceState:
	return (_scenes[scene] as SceneData).sequence


class SceneData:
	var id: int:
		set = with_id
	var sequence: SequenceState:
		set = with_sequence
	var path: NodePath:
		set = with_path
	
	
	func _init(level_id: int):
		id = level_id
	
	
	func with_id(level_id: int) -> SceneData:
		id = level_id
		return self
	
	
	func with_sequence(level_sequence: SequenceState) -> SceneData:
		sequence = level_sequence
		return self
	
	
	func with_path(level_path: String) -> SceneData:
		path = level_path
		return self
