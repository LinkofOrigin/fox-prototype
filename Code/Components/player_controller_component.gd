@tool
class_name PlayerControllerC
extends Node

var bow: SimpleBow
var movement_component: MovementComponent
var is_in_cutscene: bool = false

var _is_defeated: bool = false
var _last_direction: Vector2 = Vector2(1,0) # Default to straight right
var _transitioning_scenes: bool = false


func _ready():
	if not Engine.is_editor_hint():
		CutsceneManager.cutscene_started.connect(_on_cutscene_started)
		CutsceneManager.cutscene_ended.connect(_on_cutscene_ended)
		SceneManager.loading_new_scene.connect(_on_loading_new_scene)
		movement_component = _find_movement_comp()
		bow = _find_bow_comp()


func _process(_delta: float):
	# EDITOR ONLY
	if Engine.is_editor_hint():
		update_configuration_warnings()
	
	# GAME ONLY LOGIC
	else:
		pass


func _physics_process(_delta: float):
	# GAME ONLY LOGIC
	if not Engine.is_editor_hint():
		_handle_movement()


func _handle_movement():
	if is_in_cutscene or _is_defeated:
		return
	
	if _transitioning_scenes:
		movement_component.set_movement_direction(_last_direction)
		return
	
	var movement_vector = _get_left_joystick_vector()
	var aiming_vector = _get_right_joystick_vector()
	
	# Basic movement
	if movement_component != null:
		#print("player moving normally")
		movement_component.set_movement_direction(movement_vector)
		if movement_vector != Vector2(0,0):
			_last_direction = movement_vector
		
		if not ["BowDrawn", "DrawBow", "FireBow", "Hurt"].has(%AnimationPlayer.assigned_animation):
			if movement_vector == Vector2(0,0):
				%AnimationPlayer.play("Idle")
			else:
				%AnimationPlayer.play("Walk")
	
	if aiming_vector != Vector2(0,0):
		_last_direction = aiming_vector
	
	if aiming_vector.x > 0:
		# Face Right
		%PlayerBody.scale = Vector2(1,1)
		%PlayerBody.rotation_degrees = 0
		%CollisionShape2D.position.x = 0
	elif aiming_vector.x < 0:
		# Face Left
		%PlayerBody.scale = Vector2(1,-1)
		%PlayerBody.rotation_degrees = 180
		%CollisionShape2D.position.x = 9
	elif movement_vector.x > 0:
		# Face Right
		%PlayerBody.scale = Vector2(1,1)
		%PlayerBody.rotation_degrees = 0
		%CollisionShape2D.position.x = 0
	elif movement_vector.x < 0:
		# Face Left
		%PlayerBody.scale = Vector2(1,-1)
		%PlayerBody.rotation_degrees = 180
		%CollisionShape2D.position.x = 9


func _unhandled_input(event: InputEvent):
	# GAME LOGIC
	if not Engine.is_editor_hint():
		if is_in_cutscene or _is_defeated:
			return
		
		var movement_vector = _get_left_joystick_vector()
		var aiming_vector = _get_right_joystick_vector()
		
		# Using the bow
		# TODO: Add state check for the bow being fully drawn
		if bow != null:
			if Input.is_action_just_released(InputActions.Bow.USEBOW):
				# TODO: This should point at the player's in-game "target" (eg. an enemy, or direction per analog stick?)
				#       EG. When a target/lock-on system is created
				var target_direction: Vector2
				if event is InputEventMouseButton and event.is_released():
					if is_instance_valid(bow.curr_arrow):
						var start_position = bow.curr_arrow.get_screen_transform().origin
						var target_position = event.global_position
						target_direction = start_position.direction_to(target_position)
						#DebugCanvas.set_debug_line(start_position, target_position)
				elif event is InputEventJoypadMotion:
					target_direction = aiming_vector
					if target_direction == Vector2(0,0):
						target_direction = movement_vector
						
						if target_direction == Vector2(0,0):
							target_direction = _last_direction
				
				# Fire bow
				if target_direction != Vector2(0,0):
					%AnimationPlayer.play("FireBow")
					%AnimationPlayer.queue("Idle")
					bow.fire_arrow(target_direction)
					bow.nock_new_arrow()
				else:
					%AnimationPlayer.play_backwards("DrawBow")
					%AnimationPlayer.queue("Idle")
					bow.release_draw()
			
			# TODO: Add state check for being able to draw bow
			if event.is_action_pressed(InputActions.Bow.USEBOW):
				# Draw bow
				%AnimationPlayer.play("DrawBow")
				%AnimationPlayer.queue("BowDrawn")
				bow.draw_bow()


func _get_left_joystick_vector() -> Vector2:
	return Input.get_vector(
				InputActions.MovementActions.LEFT,
				InputActions.MovementActions.RIGHT,
				InputActions.MovementActions.UP,
			 	InputActions.MovementActions.DOWN
				)


func _get_right_joystick_vector() -> Vector2:
	return Input.get_vector(
				InputActions.RightJoystick.LEFT,
				InputActions.RightJoystick.RIGHT,
				InputActions.RightJoystick.UP, 
				InputActions.RightJoystick.DOWN
				)


func _find_movement_comp() -> MovementComponent:
	for child in get_children():
		if child is MovementComponent:
			return child as MovementComponent
	return null


func _find_bow_comp() -> SimpleBow:
	if is_instance_valid(%SimpleBow):
		return %SimpleBow as SimpleBow
	return null


func _get_configuration_warnings() -> PackedStringArray:
	var test_movement_component = _find_movement_comp()
	if test_movement_component == null:
		return ["This node requires a MovementComponent node!"]
	return []


func _on_health_c_health_reached_zero():
	_is_defeated = true
	GlobalSignals.player_defeated.emit()


func _on_health_c_health_reduced():
	%AnimationPlayer.play("Hurt")
	%AnimationPlayer.queue("Idle")


func _on_cutscene_started():
	is_in_cutscene = true
	movement_component.stop_moving()
	if not _is_defeated:
		if %AnimationPlayer.assigned_animation == "BowDrawn":
			%AnimationPlayer.play_backwards("DrawBow")
			bow.release_draw()
			%AnimationPlayer.queue("Idle")
		else:
			%AnimationPlayer.play("Idle")
	else:
		bow.visible = false


func _on_cutscene_ended():
	set_deferred("is_in_cutscene", false)


func _on_loading_new_scene(_new_scene: SceneRegistry.Scenes):
	_transitioning_scenes = true
	if not is_in_cutscene and not _is_defeated:
		%CollisionShape2D.set_deferred("disabled", true)
		%AnimationPlayer.play("Walk")
