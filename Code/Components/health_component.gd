class_name HealthComponent
extends Node

signal health_reduced
signal health_reached_zero

@export_group("Health Settings")
@export var health_resource: HealthResource

var curr_health: float = 0


func _ready():
	owner.set_meta(health_resource.health_meta, self)
	curr_health = health_resource.initial_health


func remove_health(health_to_remove: float):
	if curr_health > 0:
		curr_health = max(curr_health - health_to_remove, health_resource.min_health)
	
		if curr_health == 0:
			health_reached_zero.emit()
		else:
			health_reduced.emit()


func add_health(health_to_add: float):
	curr_health = min(curr_health + health_to_add, health_resource.max_health)
