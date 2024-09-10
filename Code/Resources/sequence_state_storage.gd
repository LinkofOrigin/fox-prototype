extends Node


var Town := TownSequence.new()
var Combat := CombatSequence.new()
var End := EndSequence.new()


func reset_all_sequences():
	Town.reset_to_initial_state()
	Combat.reset_to_initial_state()
	End.reset_to_initial_state()


class TownSequence extends SequenceState:
	enum States {AFTER_ENEMIES_DEFEATED}
	const _id = "Town"
	
	func _init():
		_state = {
			States.AFTER_ENEMIES_DEFEATED: false,
		}
		id = _id


class CombatSequence extends SequenceState:
	enum States {ENEMIES_DEFEATED, BOSS_DEFEATED}
	const _id = "Combat"
	
	func _init():
		_state = {
			States.ENEMIES_DEFEATED: false,
			States.BOSS_DEFEATED: false,
		}
		id = _id


class EndSequence extends SequenceState:
	enum States {CUTSCENE_WATCHED}
	const _id = "End"
	
	func _init():
		_state = {
			States.CUTSCENE_WATCHED: false,
		}
		id = _id
