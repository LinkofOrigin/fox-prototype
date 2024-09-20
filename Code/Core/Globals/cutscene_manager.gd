extends Node


signal cutscene_started
signal cutscene_step_progressed(current_step: int)
signal cutscene_ended
signal _cutscene_step_resolved

enum CutsceneStepTypes {DIALOGUE_STEP, CAMERA_STEP, TIMER_STEP}
var _current_resource: CutsceneResource
var _step_counter: int = 0
var _cutscene_is_playing: bool = false
var _timer: Timer
var _dialogue_base: DialogueBase = preload("res://UI/Dialogue/dialogue_base.tscn").instantiate()
var _cutscene_step_actions_to_resolve: Array = []


func _ready():
	_reset_cutscene_data()
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)
	_timer.timeout.connect(_on_timer_timeout)
	
	add_child(_dialogue_base)
	_dialogue_base.get_player_progressed_dialogue_signal().connect(_on_player_progressed_dialogue)


func set_cutscene_data(cutscene_resource: CutsceneResource):
	_current_resource = cutscene_resource


func play_cutscene(cutscene_resource: CutsceneResource = null):
	if _cutscene_is_playing:
		return false
	
	if cutscene_resource != null:
		set_cutscene_data(cutscene_resource)
	
	cutscene_started.emit()
	_cutscene_is_playing = true
	
	var original_camera: Camera2D = get_viewport().get_camera_2d()
	var original_camera_zoom = original_camera.zoom
	var player: PlayerCharacter = get_tree().get_first_node_in_group("Player")
	
	for cutscene_step: Dictionary in _current_resource.get_cutscene_steps():
		print("Attempting cutscene step: ", cutscene_step)
		
		# Dialogue stuff
		if cutscene_step.has("display_dialogue") and cutscene_step["display_dialogue"]:
			_dialogue_base.display_dialogue()
				
			if cutscene_step.has("dialogue_portrait_left"):
				_dialogue_base.set_left_portrait(cutscene_step["dialogue_portrait_left"])
			if cutscene_step.has("dialogue_portrait_right"):
				_dialogue_base.set_right_portrait(cutscene_step["dialogue_portrait_right"])
			
			if not cutscene_step.has("portrait"):
				_dialogue_base.show_no_portrait_with_text(cutscene_step["text"])
			elif cutscene_step["portrait"] == 0:
				_dialogue_base.show_left_portrait_with_text(cutscene_step["text"])
			elif cutscene_step["portrait"] == 1:
				_dialogue_base.show_right_portrait_with_text(cutscene_step["text"])
			else:
				printerr("Invalid portrait side!")
			
			_cutscene_step_actions_to_resolve.push_back(CutsceneStepTypes.DIALOGUE_STEP)
		else:
			_dialogue_base.hide_dialogue()
		
		# Camera stuff
		if cutscene_step.has("camera_pos"):
			if typeof(cutscene_step["camera_pos"]) == TYPE_STRING and cutscene_step["camera_pos"] == "player_pos":
				original_camera.global_position = player.global_position
			elif typeof(cutscene_step["camera_pos"]) == TYPE_VECTOR2:
				original_camera.global_position = cutscene_step["camera_pos"]
		if cutscene_step.has("camera_zoom"):
			var time_to_zoom = 1
			if cutscene_step.has("camera_time"):
				time_to_zoom = cutscene_step["camera_time"]
			var camera_tween = get_tree().create_tween()
			_cutscene_step_actions_to_resolve.push_back(CutsceneStepTypes.CAMERA_STEP)
			camera_tween.finished.connect(_on_camera_tween_finished)
			camera_tween.tween_property(original_camera, "zoom", original_camera.zoom * cutscene_step["camera_zoom"], time_to_zoom).set_trans(Tween.TRANS_QUAD)
		if cutscene_step.has("camera_pan") and cutscene_step.has("camera_time"):
			var target_position = cutscene_step["camera_pan"]
			if typeof(target_position) == TYPE_STRING and target_position == "player_pos":
				target_position = player.global_position
			var camera_tween = get_tree().create_tween()
			_cutscene_step_actions_to_resolve.push_back(CutsceneStepTypes.CAMERA_STEP)
			camera_tween.finished.connect(_on_camera_tween_finished)
			camera_tween.tween_property(original_camera, "global_position", target_position, cutscene_step["camera_time"]).set_trans(Tween.TRANS_QUAD)
		
		# Animation stuff
		if cutscene_step.has("animation"):
			player.play_animation(cutscene_step["animation"])
		
		# Timer stuff
		if cutscene_step.has("wait_time"):
			_cutscene_step_actions_to_resolve.push_back(CutsceneStepTypes.TIMER_STEP)
			_timer.start(cutscene_step["wait_time"])
		
		await _cutscene_step_resolved
		_step_counter += 1
		cutscene_step_progressed.emit(_step_counter)
	
	_dialogue_base.hide_dialogue()
	original_camera.zoom = original_camera_zoom
	
	_cutscene_is_playing = false
	cutscene_ended.emit()
	_reset_cutscene_data()


func cutscene_is_playing() -> bool:
	return _cutscene_is_playing


func _reset_cutscene_data():
	_current_resource = null
	_step_counter = 0
	_cutscene_is_playing = false


func _check_cutscene_step_resolution():
	if _cutscene_step_actions_to_resolve.is_empty():
		print("all step actions resolved!")
		_cutscene_step_resolved.emit()


func _on_player_progressed_dialogue():
	_cutscene_step_actions_to_resolve.erase(CutsceneStepTypes.DIALOGUE_STEP)
	_dialogue_base.hide_dialogue()
	_check_cutscene_step_resolution()


func _on_camera_tween_finished():
	_cutscene_step_actions_to_resolve.erase(CutsceneStepTypes.CAMERA_STEP)
	_check_cutscene_step_resolution()


func _on_timer_timeout():
	_cutscene_step_actions_to_resolve.erase(CutsceneStepTypes.TIMER_STEP)
	_check_cutscene_step_resolution()
