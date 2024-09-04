class_name MovementComponent
extends Node

@export_group("Movement Settings")
@export var movement_resource: MovementResource

var moving_entity: Node2D
var current_direction: Vector2 :set = set_movement_direction
var current_speed: float = 0

func _ready():
	moving_entity = owner
	moving_entity.set_meta(movement_resource.movement_meta, self)


func _physics_process(_delta):
	moving_entity.velocity = current_direction * current_speed
	moving_entity.move_and_slide()


func move_towards(destination: Vector2):
	current_speed = movement_resource.speed
	current_direction = moving_entity.global_position.direction_to(destination)


func set_movement_direction(new_direction: Vector2):
	current_speed = movement_resource.speed
	current_direction = new_direction


func stop_moving():
	current_speed = 0
	current_direction = Vector2(0,0)
