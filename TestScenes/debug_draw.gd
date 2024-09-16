class_name DebugNode
extends Node2D

var _debug_line_start: Vector2
var _debug_line_end: Vector2

func _draw():
	if _debug_line_start != null and _debug_line_end != null:
		draw_line(_debug_line_start, _debug_line_end, Color.MAGENTA, 3)


func set_debug_line(start: Vector2, end: Vector2):
	_debug_line_start = start
	_debug_line_end = end
	queue_redraw()
