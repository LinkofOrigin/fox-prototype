class_name AttackC
extends Node

@export var attack_resource: AttackResource

var last_attack_timestamp: float = -1 # -1 suggests an attack has not happened yet


func _ready():
	owner.set_meta(attack_resource.attack_meta, self)


func can_attack() -> bool:
	var currTimestamp = Time.get_unix_time_from_system()
	if last_attack_timestamp + attack_resource.attack_speed < currTimestamp:
		return true
	else:
		return false


func attempt_basic_attack_on_target(target: Node2D):
	if can_attack():
		_attack_target(target, attack_resource.damage_resource.damage_amount)


func attempt_modified_attack_on_target(target: Node2D, modifier: float):
	if can_attack():
		attack_target_with_modifier(target, modifier)


 # TODO: Create DamageOverride object(?)
#func attemptOverrideAttackOnTarget(target: Node2D, override):
	#if can_attack():
		#attackTargetWithOverride(target, override)


func attack_target_with_modifier(target: Node2D, modifier: float):
	_attack_target(target, attack_resource.damage_resource.damage_amount * modifier)


func _attack_target(target: Node2D, damage: float):
	if target.has_meta(HealthResource.health_meta):
		target.get_meta(HealthResource.health_meta).remove_health(damage)
		last_attack_timestamp = Time.get_unix_time_from_system()


# TODO: Create DamageOverride object(?)
#func attackTargetWithOverride(target: Node2D, override):
	#pass
