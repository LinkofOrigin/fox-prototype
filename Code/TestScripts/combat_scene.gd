class_name CombatScene
extends Level


const Proto1Enemy: PackedScene = preload("res://Enemies/proto1_enemy.tscn")
const Proto1Boss: PackedScene = preload("res://Enemies/proto1_boss.tscn")

var _actively_fighting_enemies: bool = false
var _actively_fighting_boss: bool = false
const _player_portrait: Texture2D = preload("res://Assets/Sprites/FoxPortrait.png")
const _squid_portrait: Texture2D = preload("res://Assets/extraCreatures/shredSquid.png")
const _knight_portrait: Texture2D = preload("res://Assets/extraCreatures/armsKnight.png")


func _ready():
	initialize(SceneRegistry.Scenes.COMBAT) # TODO: Can this be moved to JSON file? Not if we want to reference it via code (unless @tool?)
	CutsceneManager.cutscene_ended.connect(_on_cutscene_ended)
	
	var player: Node2D = get_tree().get_first_node_in_group("Player")
	if SceneManager.get_last_scene() == SceneRegistry.Scenes.TOWN:
		player.global_position = $PlayerSpawns/PlayerSpawnLeft.global_position
	elif SceneManager.get_last_scene() == SceneRegistry.Scenes.END:
		player.global_position = $PlayerSpawns/PlayerSpawnRight.global_position
	
	if not sequence.get_state_value(sequence.States.ENEMIES_DEFEATED):
		_load_enemies()
		_actively_fighting_enemies = true
		if $LeftTransition.body_entered.is_connected(_on_left_transition_body_entered):
			$LeftTransition.body_entered.disconnect(_on_left_transition_body_entered)
		_run_opening_cutscene()
	elif sequence.get_state_value(sequence.States.ENEMIES_DEFEATED) and not sequence.get_state_value(sequence.States.BOSS_DEFEATED):
		if $LeftTransition.body_entered.is_connected(_on_left_transition_body_entered):
			$LeftTransition.body_entered.disconnect(_on_left_transition_body_entered)
		_load_boss()
		_actively_fighting_boss = true
		_run_boss_opening_cutscene()
	elif sequence.get_state_value(sequence.States.BOSS_DEFEATED):
		$RightTransition.body_entered.connect(_on_right_transition_body_entered)


func _run_opening_cutscene():
	var cutscene_resource = CutsceneResource.new()
	
	cutscene_resource.set_cutscene_steps([
			# Hold camera on player for X time
			{
				"camera_pos": "player_pos",
				"wait_time": .5,
			},
			# Pan camera to enemies
			{
				"camera_pan": %TopSquidSpawn.global_position,
				"camera_time": 3,
			},
			# Hold briefly
			{
				"wait_time": .5,
			},
			# Display dialogue for enemies
			{
				"display_dialogue": true,
				"portrait": 1,
				"dialogue_portrait_right": _squid_portrait,
				"text": "GrAahhahaFHfgha",
			},
			# Hide dialogue and pan camera back to player
			{
				"display_dialogue": false,
				"camera_pan": "player_pos",
				"camera_time": 2.5,
			},
			# Display player dialogue
			{
				"display_dialogue": true,
				"portrait": 0,
				"dialogue_portrait_left": _player_portrait,
				"text": "Gotta clean out these baddies to keep the town safe!",
			},
			# On dismissal, release; cutscene is over
			])
	CutsceneManager.play_cutscene(cutscene_resource)


func _load_enemies():
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
	var cutscene_resource := CutsceneResource.new()
	cutscene_resource.set_cutscene_steps([
			# Start camera on boss enemy
			{
				"camera_pos": %BossSpawn.global_position,
				"wait_time": 1,
			},
			# Display dialogue for boss
			{
				"display_dialogue": true,
				"portrait": 1,
				"dialogue_portrait_right": _knight_portrait,
				"text": "This town will be razed to nothing!",
			},
			# Pan camera to player and show player dialogue
			{
				"camera_pan": "player_pos",
				"camera_time": 2,
				"display_dialogue": true,
				"portrait": 0,
				"dialogue_portrait_left": _player_portrait,
				"text": "No! I'll finish you, and then I'll end this all for good!",
			},
			])
	CutsceneManager.play_cutscene(cutscene_resource)


func _load_boss():
	var boss_spawn = %BossSpawn
	var boss = Proto1Boss.instantiate()
	boss.global_position = boss_spawn.global_position
	$EnemyStorage.add_child(boss)
	boss.tree_exited.connect(_on_enemy_death)


func _run_boss_defeated_cutscene():
	pass


func _handle_enemies_defeated():
	sequence.update_state_value(sequence.States.ENEMIES_DEFEATED, true)
	_actively_fighting_enemies = false
	$LeftTransition.body_entered.connect(_on_left_transition_body_entered)
	_run_enemies_defeated_cutscene()


func _handle_boss_defeated():
	sequence.update_state_value(sequence.States.BOSS_DEFEATED, true)
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
	if not sequence.get_state_value(SequenceStateStorage.Combat.States.ENEMIES_DEFEATED):
		_show_then_hide_input_indicator()


func _show_then_hide_input_indicator():
	# Show input indicator for using the bow
		%InputIndicator.visible = true
		await get_tree().create_timer(5).timeout
		%InputIndicator.visible = false


func _on_left_transition_body_entered(_body: Node2D):
	SceneManager.switch_to_scene(SceneRegistry.Scenes.TOWN)


func _on_right_transition_body_entered(_body: Node2D):
	SceneManager.switch_to_scene(SceneRegistry.Scenes.END)
