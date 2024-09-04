extends Node2D

@onready var dialogue_base: DialogueBase = $DialogueBase
@onready var cutscene_resource: CutsceneResource = preload("res://Resources/Cutscenes/cutscene_resource.tres")

var _first_texture: Texture2D = preload("res://Assets/Sprites/FoxPortrait.png")
var _second_texture: Texture2D = preload("res://Assets/Sprites/HellhandsPortrait.png")
var _test_dialogue_dict: Array


func _ready():
	dialogue_base.set_left_portrait(_first_texture)
	dialogue_base.set_right_portrait(_second_texture)
	
	_initialize_dialogue_dict()
	cutscene_resource.set_dialogue_text(_test_dialogue_dict)
	cutscene_resource.set_dialogue_base(dialogue_base)
	CutsceneManager.cutscene_started.connect(_on_cutscene_started)
	CutsceneManager.cutscene_step_progressed.connect(_on_cutscene_step_progressed)
	CutsceneManager.cutscene_ended.connect(_on_cutscene_ended)


func start_dialogue():
	print("attempting to start cutscene")
	CutsceneManager.set_cutscene_data(cutscene_resource)
	CutsceneManager.play_cutscene()
	dialogue_base.display_dialogue()


func _on_area_2d_body_entered(body):
	print("detecting...")
	if body.is_in_group("Player"):
		start_dialogue()


func _initialize_dialogue_dict():
	_test_dialogue_dict = [
		{"portrait": 0, "text": "This is the first line of dialogue."},
		{"portrait": 1, "text": "I'm a monster! (line 2)"}
	]


func _on_cutscene_started():
	print("signal - the cutscene started!")


func _on_cutscene_step_progressed(cutscene_step: int):
	print("signal - cutscene was progressed to step ", cutscene_step)


func _on_cutscene_ended():
	print("signal - the cutscene ended!")
	dialogue_base.hide_dialogue()
