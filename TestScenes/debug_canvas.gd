extends CanvasLayer

@onready var debug_node: DebugNode = $DebugNode


func set_debug_line(start: Vector2, end: Vector2):
	debug_node.set_debug_line(start, end)
