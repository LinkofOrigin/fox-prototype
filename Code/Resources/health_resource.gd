class_name HealthResource
extends Resource

const min_health: float = 0 # Export later if needed
const health_meta: String = "HEALTH_NODE"

@export_group("Health Resources")
@export_range(0, 1000, 0.5) var max_health: float = 0
@export_range(0, 1000, 0.5) var initial_health: float = 0
