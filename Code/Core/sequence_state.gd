class_name SequenceState
extends Node


var _triggers: Array[SequenceTriggerResource]
var _state: Dictionary:
	get = _get_state,
	set = _update_state


func get_state_value(key: Variant) -> Variant:
	if not _state.has(key):
		printerr("This Sequence does not have that State key! Object=%s Key=%s", self, key)
		return null
	
	return _state[key]


func update_state_value(key: Variant, value: Variant):
	if not _state.has(key):
		printerr("This Sequence does not have that State key! Object=%s Key=%s", self, key)
		return
	
	_update_state({key: value})


func add_sequence_trigger(trigger_signal: Signal, trigger_callback: Callable):
	var new_sequence_trigger = SequenceTriggerFactory.create_new_trigger(trigger_signal, trigger_callback)
	_triggers.push_back(new_sequence_trigger)


func reset_to_initial_state():
	_init()


func _set_state(state: Dictionary):
	_state = state
	_handle_sequence_update()


func _get_state() -> Dictionary:
	return _state


func _update_state(state_update: Dictionary):
	_state.merge(state_update, true)
	_handle_sequence_update()


func _handle_sequence_update():
	GlobalSignals.sequence_state_updated.emit(self)
