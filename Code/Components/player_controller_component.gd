@tool
class_name PlayerControllerC
extends Node

var bow: SimpleBow
var movement_component: MovementComponent
var is_in_cutscene: bool = false


func _ready():
	if not Engine.is_editor_hint():
		CutsceneManager.cutscene_started.connect(_on_cutscene_started)
		CutsceneManager.cutscene_ended.connect(_on_cutscene_ended)
		movement_component = _find_movement_comp()
		bow = _find_bow_comp()


func _process(_delta):
	# EDITOR ONLY
	if Engine.is_editor_hint():
		update_configuration_warnings()
	
	# GAME LOGIC
	else:
		pass


func _unhandled_input(event: InputEvent):
	# GAME LOGIC
	if not Engine.is_editor_hint():
		if is_in_cutscene:
			return
		
		# Basic movement
		if movement_component != null:
			var current_direction = Input.get_vector(
				InputActions.MovementActions.LEFT,
				InputActions.MovementActions.RIGHT,
				InputActions.MovementActions.UP,
			 	InputActions.MovementActions.DOWN
			)
			movement_component.set_movement_direction(current_direction)
		
		# Using the bow
		# TODO: Add state check for the bow being fully drawn
		if bow != null:
			if Input.is_action_just_released(InputActions.Bow.USEBOW):
				# TODO: This should point at the player's in-game "target" (eg. an enemy, or direction per analog stick?)
				#       EG. When a target/lock-on system is created
				var target_direction: Vector2
				if event is InputEventMouseButton and event.is_released():
					target_direction = bow.curr_arrow.global_position.direction_to(event.position)
				elif event is InputEventJoypadMotion:
					target_direction = Input.get_vector(
							InputActions.RightJoystick.LEFT,
							InputActions.RightJoystick.RIGHT,
							InputActions.RightJoystick.UP, 
							InputActions.RightJoystick.DOWN
							).normalized()
					# TODO: If both sticks are neutral, shoot in the direction the player is facing?
					if target_direction == Vector2(0,0):
						target_direction = Input.get_vector(
								InputActions.MovementActions.LEFT,
								InputActions.MovementActions.RIGHT,
								InputActions.MovementActions.UP,
							 	InputActions.MovementActions.DOWN
								).normalized()
				
				# Fire bow
				if target_direction != Vector2(0,0):
					bow.fire_arrow(target_direction)
					bow.nock_new_arrow()
			# TODO: Add state check for being able to draw bow
			elif event.is_action_pressed(InputActions.Bow.USEBOW):
				# Draw bow
				bow.draw_bow()


func _find_movement_comp() -> MovementComponent:
	for child in get_children():
		if child is MovementComponent:
			return child as MovementComponent
	return null


func _find_bow_comp() -> SimpleBow:
	if owner != null:
		for child in owner.get_children():
			if child is SimpleBow:
				return child as SimpleBow
	return null


func _get_configuration_warnings() -> PackedStringArray:
	var test_movement_component = _find_movement_comp()
	if test_movement_component == null:
		return ["This node requires a MovementComponent node!"]
	return []


func _on_health_c_health_reached_zero():
	# TODO: Trigger game over or something
	print("Player died!")


func _on_cutscene_started():
	is_in_cutscene = true
	movement_component.stop_moving()


func _on_cutscene_ended():
	set_deferred("is_in_cutscene", false)
