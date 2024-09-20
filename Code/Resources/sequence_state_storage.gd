extends Node


var Town := TownSequence.new()
var Combat := CombatSequence.new()
var End := EndSequence.new()

var _all_sequences: Array = [
	Town,
	Combat,
	End,
]


func reset_all_sequences():
	for sequence: SequenceState in _all_sequences:
		sequence.reset_to_initial_state()


class TownSequence extends SequenceState:
	enum States {AFTER_ENEMIES_DEFEATED}
	
	func _init():
		_state = {
			States.AFTER_ENEMIES_DEFEATED: false,
		}


class CombatSequence extends SequenceState:
	enum States {ENEMIES_DEFEATED, BOSS_DEFEATED}
	
	func _init():
		_state = {
			States.ENEMIES_DEFEATED: false,
			States.BOSS_DEFEATED: false,
		}


class EndSequence extends SequenceState:
	enum States {CUTSCENE_WATCHED}
	
	func _init():
		_state = {
			States.CUTSCENE_WATCHED: false,
		}
