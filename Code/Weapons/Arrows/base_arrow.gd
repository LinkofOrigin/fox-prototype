class_name BaseArrow
extends Area2D

signal arrow_hit_body(body)

@export var movement_resource: MovementResource
@export var damage_resource: DamageResource
var trajectory: Vector2
var _currently_flying: bool = false


func _ready():
	name = "BaseArrow"
	set_process_mode(Node.PROCESS_MODE_DISABLED)


func _physics_process(delta: float):
	look_at(global_position + trajectory)
	global_translate(trajectory * movement_resource.speed * delta)


func enable_and_fly(targetDirection: Vector2, startPoint: Vector2):
	top_level = true
	global_position = startPoint
	trajectory = targetDirection
	_currently_flying = true
	set_process_mode(Node.PROCESS_MODE_INHERIT)


# Signal
func _on_body_entered(body: Node2D):
	if body.has_meta(HealthResource.health_meta):
		var bodyHealthComponent: HealthComponent = body.get_meta(HealthResource.health_meta)
		bodyHealthComponent.remove_health(damage_resource.damage_amount)
		arrow_hit_body.emit(body)
		queue_free() # TODO: Handle destroying the arrow more gracefully (eg. with FX or other logic)


# Signal - if the arrow leaves the screen, remove it
# TODO: Any logic needed for if an arrow hits something off screen? Maybe don't delete it?
func _on_visible_on_screen_notifier_2d_screen_exited():
	if _currently_flying:
		queue_free()
