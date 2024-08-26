class_name AttackResource
extends Resource

const attack_meta: String = "ATTACK_NODE"

## The resource defining the damage this attack can deal
@export var damage_resource: DamageResource
## The attack speed of this unit, in seconds
@export_range(0, 5, 0.1) var attack_speed: float

#@export var damage_type: DamageType
