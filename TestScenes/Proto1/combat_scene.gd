extends Node2D


const SEQUENCE_ID: String = "TOWN_SCENE" # TODO: Can this be moved to JSON file?
enum CombatSequenceStates {ENEMIES_DEFEATED, BOSS_DEFEATED}
var Proto1Enemy: PackedScene = preload("res://Enemies/proto1_enemy.tscn")
var Proto1Boss: PackedScene = preload("res://Enemies/proto1_boss.tscn")
var DialogueBase = preload("res://UI/Dialogue/dialogue_base.tscn")
var local_sequence: LocalSequence

var _base_sequence_state: Dictionary = { # TODO: Move this to JSON file? Nice to have in code...
	CombatSequenceStates.ENEMIES_DEFEATED: false,
	CombatSequenceStates.BOSS_DEFEATED: false,
}
var _actively_fighting_enemies: bool = false
var _actively_fighting_boss: bool = false
var _player_portrait: Texture2D = preload("res://Assets/Sprites/FoxPortrait.png")
var _squid_portrait: Texture2D = preload("res://Assets/extraCreatures/shredSquid.png")
var _knight_portrait: Texture2D = preload("res://Assets/extraCreatures/armsKnight.png")


func _ready():
	CutsceneManager.cutscene_ended.connect(_on_cutscene_ended)
	_initialize_local_sequence()
	
	# TODO: Set player location based on previous location (global state/sequence? probly)
	
	if not local_sequence.get_state_value(CombatSequenceStates.ENEMIES_DEFEATED):
		_load_enemies()
		_actively_fighting_enemies = true
		if $LeftTransition.body_entered.is_connected(_on_left_transition_body_entered):
			$LeftTransition.body_entered.disconnect(_on_left_transition_body_entered)
		_run_opening_cutscene()
	elif local_sequence.get_state_value(CombatSequenceStates.ENEMIES_DEFEATED) and not local_sequence.get_state_value(CombatSequenceStates.BOSS_DEFEATED):
		if $LeftTransition.body_entered.is_connected(_on_left_transition_body_entered):
			$LeftTransition.body_entered.disconnect(_on_left_transition_body_entered)
		_load_boss()
		_actively_fighting_boss = true
		_run_boss_opening_cutscene()
	elif local_sequence.get_state_value(CombatSequenceStates.BOSS_DEFEATED):
		$RightTransition.body_entered.connect(_on_right_transition_body_entered)
	
	


func _initialize_local_sequence():
	local_sequence = LocalSequence.new(SEQUENCE_ID, _base_sequence_state)
	# TODO: Figure out how to handle handing around sequence state, initializing, changing, etc.


func _run_opening_cutscene():
	var dialogue_base = DialogueBase.instantiate()
	add_child(dialogue_base)
	dialogue_base.set_left_portrait(_player_portrait)
	dialogue_base.set_right_portrait(_squid_portrait)
	
	var cutscene_resource = CutsceneResource.new()
	cutscene_resource.set_dialogue_base(dialogue_base)
	
	cutscene_resource.set_cutscene_steps([
				# Hold camera on player for X time
				{
					"camera_ref": %Camera2D,
					"camera_pos": "player_pos",
					"wait_time": 1.5,
				},
				# Pan camera to enemies
				{
					"camera_pan": %TopSquidSpawn.global_position,
					"camera_time": 3,
					"camera_speed": 4,
				},
				# Hold briefly
				{
					"wait_time": .5,
				},
				# Display dialogue for enemies
				{
					"display_dialogue": true,
					"portrait": 1,
					"text": "GrAahhahaFHfgha",
				},
				# Hide dialogue and pan camera back to player
				{
					"display_dialogue": false,
					"camera_pan": "player_pos",
					"camera_time": 2.5,
					"camera_speed": 4,
				},
				# Display player dialogue
				{
					"display_dialogue": true,
					"portrait": 0,
					"text": "Gotta clean out these baddies to keep the town safe!",
				},
			# On dismissal, release; cutscene is over
			])
	CutsceneManager.play_cutscene(cutscene_resource)


func _load_enemies():
	print("loading enemies!")
	var enemy_spawns = _get_enemy_spawns()
	for spawn_location: Marker2D in enemy_spawns:
		var new_squid = Proto1Enemy.instantiate()
		new_squid.global_position = spawn_location.global_position
		$EnemyStorage.add_child(new_squid)
		new_squid.tree_exited.connect(_on_enemy_death)


func _get_enemy_spawns() -> Array[Marker2D]:
	return [
		%TopSquidSpawn,
		%BotLeftSquidSpawn,
		%BotRightSquidSpawn
	]


func _run_enemies_defeated_cutscene():
	pass


func _run_boss_opening_cutscene():
	pass


func _load_boss():
	var boss_spawn = _get_boss_spawn()
	var boss = Proto1Boss.instantiate()
	boss.global_position = boss_spawn.global_position
	$EnemyStorage.add_child(boss)
	boss.tree_exited.connect(_on_enemy_death)


func _get_boss_spawn() -> Marker2D:
	return %BossSpawn


func _run_boss_defeated_cutscene():
	pass


func _handle_enemies_defeated():
	print("all enemies defeated!")
	local_sequence.update_state_value(CombatSequenceStates.ENEMIES_DEFEATED, true)
	_actively_fighting_enemies = false
	$LeftTransition.body_entered.connect(_on_left_transition_body_entered)
	_run_enemies_defeated_cutscene()


func _handle_boss_defeated():
	print("boss defeated")
	local_sequence.update_state_value(CombatSequenceStates.BOSS_DEFEATED, true)
	_actively_fighting_boss = false
	$LeftTransition.body_entered.connect(_on_left_transition_body_entered)
	$RightTransition.body_entered.connect(_on_right_transition_body_entered)
	_run_boss_defeated_cutscene()


func _on_enemy_death():
	if $EnemyStorage.get_child_count() == 0:
		if _actively_fighting_enemies:
			_handle_enemies_defeated()
		elif _actively_fighting_boss:
			_handle_boss_defeated()


func _on_cutscene_ended():
	# TODO: huh?
	pass

func _on_left_transition_body_entered(_body):
	get_tree().change_scene_to_file.call_deferred("res://TestScenes/Proto1/town_scene.tscn")


func _on_right_transition_body_entered(_body):
	get_tree().change_scene_to_file.call_deferred("res://TestScenes/Proto1/end_scene.tscn")
