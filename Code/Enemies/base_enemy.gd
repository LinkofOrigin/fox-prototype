class_name BaseEnemy
extends CharacterBody2D

var target: Node2D = null
var _is_dying: bool = false # TODO: use state machine

@onready var anim_sprite: AnimatedSprite2D = $FoxyCharAnimSprite
@onready var hurtbox_collision: CollisionShape2D = $CollisionShape2D
@onready var attack_component: AttackC = $AttackC
@onready var attack_area: Area2D = $AttackArea


func _process(_delta: float):
	if target != null:
		attack_component.attempt_basic_attack_on_target(target)


func _handle_death():
	if not _is_dying:
		_is_dying = true
		anim_sprite.play("Death")
		hurtbox_collision.set_deferred("disabled", true)
		attack_area.monitoring = false
		#attack_area.get_node("CollisionShape2D").set_deferred("disabled", true)


func _on_health_c_health_reached_zero():
	_handle_death()


func _on_foxy_char_anim_sprite_animation_finished():
	if _is_dying:
		queue_free()


func _on_attack_area_body_entered(body: Node2D):
	print("found: ", body)
	target = body # TODO: Be smarter about this. This will just set any ol' target if it's in the collision layer


func _on_attack_area_body_exited(body: Node2D):
	if target == body:
		target = null
