class_name LocalSequence
extends Node

signal local_sequence_updated()

var sequence_id: String

var _triggers: Array[SequenceTriggerResource]
var _state: Dictionary:
	get = get_state,
	set = update_state


func _init(new_sequence_id: String, base_state: Dictionary = {}):
	load_sequence(new_sequence_id, base_state)


func load_sequence(new_sequence_id: String, base_state: Dictionary = {}):
	sequence_id = new_sequence_id
	var loaded_state = SequenceManager.load_local_sequence(sequence_id)
	base_state.merge(loaded_state, true)
	set_state(base_state)
	GlobalSignals.local_sequence_loaded.emit(self)


func set_state(state: Dictionary):
	_state = state


func get_state():
	return _state


func update_state(state_update: Dictionary):
	_state.merge(state_update, true)
	_handle_sequence_update()


func get_state_value(state_key: Variant) -> Variant:
	if _state.has(state_key):
		return _state[state_key]
	else:
		return null


func update_state_value(key: Variant, value: Variant):
	if _state.has(key):
		update_state({key: value})


func add_sequence_trigger(trigger_signal: Signal, trigger_callback: Callable):
	var new_sequence_trigger = SequenceTriggerFactory.create_new_trigger(trigger_signal, trigger_callback)
	_triggers.push_back(new_sequence_trigger)


func _handle_sequence_update():
	GlobalSignals.local_sequence_updated.emit(self)
