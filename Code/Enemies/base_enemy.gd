class_name BaseEnemy
extends CharacterBody2D

var target: Node2D = null
var _is_dying: bool = false # TODO: use state machine
var _can_move: bool = true

@onready var animation_player: AnimationPlayer = $EnemyAnimationPlayer
@onready var hurtbox_collision: CollisionShape2D = $CollisionShape2D
@onready var attack_component: AttackC = $AttackC
@onready var movement_component: MovementComponent = $MovementC
@onready var attack_area: Area2D = $AttackArea

var player: PlayerCharacter


func _ready():
	CutsceneManager.cutscene_started.connect(_on_cutscene_started)
	CutsceneManager.cutscene_ended.connect(_on_cutscene_ended)
	attack_component.attacking_target.connect(_on_attacking_target)
	
	player = get_tree().get_first_node_in_group("Player")


func _process(_delta: float):
	if target != null:
		attack_component.attempt_basic_attack_on_target(target)


func _physics_process(_delta: float):
	if _can_move:
		# Find player node
		var target_location: Vector2
		if is_instance_valid(player) and is_instance_of(player, PlayerCharacter):
			target_location = player.global_position
		
			if target_location != null:
				var target_direction = global_position.direction_to(target_location)
				if target_direction.x < 0:
					# Face Left
					scale = Vector2(1,-1)
					rotation_degrees = 180
				elif target_direction.x > 0:
					# Face right
					scale = Vector2(1,1)
					rotation_degrees = 0
				
				movement_component.set_movement_direction(target_direction)


func _handle_death():
	if not _is_dying:
		_is_dying = true
		_can_move = false
		movement_component.stop_moving()
		animation_player.play("Death")
		hurtbox_collision.set_deferred("disabled", true)
		attack_area.monitoring = false


func _on_health_c_health_reached_zero():
	_handle_death()


func _on_enemy_animation_player_animation_finished(_animation_name: StringName):
	if _is_dying:
		queue_free()


func _on_attacking_target(_target_being_attacked: Node2D, _damage_being_dealt: float):
	$EnemyAnimationPlayer.play("Attack")
	$EnemyAnimationPlayer.queue("Idle")


func _on_attack_area_body_entered(body: Node2D):
	target = body # TODO: Be smarter about this. This will just set any ol' target if it's in the collision layer


func _on_attack_area_body_exited(body: Node2D):
	if target == body:
		target = null


func _on_cutscene_started():
	_can_move = false


func _on_cutscene_ended():
	_can_move = true
