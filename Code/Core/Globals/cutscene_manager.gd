extends Node


signal cutscene_started
signal cutscene_step_progressed(current_step: int)
signal cutscene_ended

var _current_resource: CutsceneResource
var _step_counter: int = 0
var _cutscene_is_playing: bool = false
var _camera: Camera2D
var _timer: Timer


func _ready():
	_reset_cutscene_data()
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)


func set_cutscene_data(cutscene_resource: CutsceneResource):
	_current_resource = cutscene_resource


func play_cutscene(cutscene_resource: CutsceneResource = null):
	if cutscene_resource != null:
		set_cutscene_data(cutscene_resource)
	
	_cutscene_is_playing = true
	cutscene_started.emit()
	
	_current_resource.dialogue_base.display_dialogue()
	var original_camera: Camera2D = get_viewport().get_camera_2d()
	_camera = original_camera.duplicate()
	add_child(_camera)
	_camera.make_current()
	var player: Node2D = get_tree().get_first_node_in_group("Player")
	
	for cutscene_step: Dictionary in _current_resource.get_cutscene_steps():
		print("Attempting cutscene step: ", cutscene_step)
		
		# Dialogue stuff
		if cutscene_step.has("display_dialogue") and cutscene_step["display_dialogue"]:
			_current_resource.dialogue_base.display_dialogue()
			if cutscene_step["portrait"] == 0:
				_current_resource.dialogue_base.show_left_portrait_with_text(cutscene_step["text"])
			elif cutscene_step["portrait"] == 1:
				_current_resource.dialogue_base.show_right_portrait_with_text(cutscene_step["text"])
			else:
				printerr("Invalid portrait side!")
			
			await _current_resource.dialogue_base.get_player_progressed_dialogue_signal()
		else:
			_current_resource.dialogue_base.hide_dialogue()
		
		# Camera stuff
		if cutscene_step.has("camera_pos"):
			if cutscene_step["camera_pos"] == "player_pos":
				_camera.position = player.global_position
		if cutscene_step.has("camera_pan") and cutscene_step.has("camera_time"):
			var target_position = cutscene_step["camera_pan"]
			if typeof(target_position) == TYPE_STRING and target_position == "player_pos":
				target_position = player.global_position
			var camera_tween = get_tree().create_tween()
			camera_tween.tween_property(_camera, "position", target_position, cutscene_step["camera_time"]).set_trans(Tween.TRANS_QUAD)
			await camera_tween.finished
		
		# Timer stuff
		if cutscene_step.has("wait_time"):
			_timer.start(cutscene_step["wait_time"])
			await _timer.timeout
		
		_step_counter += 1
		cutscene_step_progressed.emit(_step_counter)
	
	_current_resource.dialogue_base.hide_dialogue()
	original_camera.make_current()
	_camera.queue_free()
	
	cutscene_ended.emit()
	_cutscene_is_playing = false
	_reset_cutscene_data()


func cutscene_is_playing() -> bool:
	return _cutscene_is_playing


func _reset_cutscene_data():
	_current_resource = null
	_step_counter = 0
	_cutscene_is_playing = false
