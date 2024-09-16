class_name SimpleBow
extends Node2D

enum States {IDLE, DRAW, DRAWN, FIRE, RELEASING, IDLEFIDGET}
const ANIMATIONS: Dictionary = {IDLE = "Idle", IDLE_FIDGET = "IdleFidget", DRAW = "Draw", DRAWN = "Drawn", FIRE = "Fire"}
const BaseArrow := preload("res://Weapons/Arrows/base_arrow.tscn")

var curr_state: States = States.IDLE
var curr_arrow: BaseArrow


func _ready():
	nock_new_arrow()


func draw_bow():
	play_animation(ANIMATIONS.DRAW)
	

func release_draw():
	$BowAnimatedSprite.play_backwards(ANIMATIONS.DRAW)
	curr_state = States.RELEASING


func fire_arrow(target_direction: Vector2):
	# TODO: Implement variable arrow logic to change arrow properties based on draw time (eg. trajectory, damage/crit modifier?)
	play_animation(ANIMATIONS.FIRE)
	if curr_arrow != null:
		curr_arrow.enable_and_fly(target_direction, $ArrowRoot.global_position)
		curr_arrow = null # release the ref


func play_animation(animation_name: StringName):
	print("bow playing: ", animation_name)
	print("bow has anim: ", ANIMATIONS.find_key(animation_name as String))
	if ANIMATIONS.find_key(animation_name as String) != null:
		$BowAnimatedSprite.play(animation_name)
		match animation_name:
			ANIMATIONS.IDLE:
				curr_state = States.IDLE
			ANIMATIONS.IDLE_FIDGET:
				curr_state = States.IDLEFIDGET
			ANIMATIONS.DRAW:
				curr_state = States.DRAW
			ANIMATIONS.DRAWN:
				curr_state = States.DRAWN
			ANIMATIONS.FIRE:
				curr_state = States.FIRE
		
		print("new bow state: ", curr_state)


func nock_new_arrow():
	var new_arrow = BaseArrow.instantiate()
	$ArrowRoot.add_child(new_arrow)
	curr_arrow = new_arrow


func set_arrow_type(): # TODO: Implement arrow types?
	pass


func _on_animation_finished():
	if curr_state == States.DRAW:
		play_animation(ANIMATIONS.DRAWN)
	elif curr_state == States.FIRE or curr_state == States.IDLEFIDGET:
		play_animation(ANIMATIONS.IDLE)
	elif curr_state == States.RELEASING:
		play_animation(ANIMATIONS.IDLE)
