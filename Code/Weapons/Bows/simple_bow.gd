class_name SimpleBow
extends AnimatedSprite2D

enum States {IDLE, DRAW, DRAWN, FIRE, IDLEFIDGET}
const ANIMATIONS: Dictionary = { IDLE = "Idle", IDLEFIDGET = "IdleFidget", DRAW = "Draw", DRAWN = "Drawn", FIRE = "Fire"}

var curr_state: States = States.IDLE
var curr_arrow: BaseArrow

@onready var _arrow_marker: Marker2D = $ArrowRoot
const BaseArrowPackedScene: PackedScene = preload("res://Weapons/Arrows/base_arrow.tscn")


func _ready():
	nock_new_arrow()


func draw_bow():
	play(ANIMATIONS.DRAW)
	curr_state = States.DRAW


func fire_arrow(target_direction: Vector2):
	# TODO: Implement variable arrow logic to change arrow properties based on draw time (eg. trajectory, damage/crit modifier?)
	play(ANIMATIONS.FIRE)
	curr_state = States.FIRE
	if curr_arrow != null:
		curr_arrow.enable_and_fly(target_direction, _arrow_marker.global_position)
		curr_arrow = null # release the ref


func play_fidget():
	play(ANIMATIONS.IDLEFIDGET)
	curr_state = States.IDLEFIDGET


func nock_new_arrow():
	var new_arrow: BaseArrow = BaseArrowPackedScene.instantiate()
	_arrow_marker.add_child(new_arrow)
	curr_arrow = new_arrow


func set_arrow_type(): # TODO: Implement arrow types?
	pass


func _on_animation_finished():
	if curr_state == States.DRAW:
		play(ANIMATIONS.DRAWN)
		curr_state = States.DRAWN
	elif curr_state == States.FIRE or curr_state == States.IDLEFIDGET:
		play(ANIMATIONS.IDLE)
		curr_state = States.IDLE
