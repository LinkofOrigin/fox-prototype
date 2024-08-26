class_name LocalSequence
extends Node

signal local_sequence_updated()

@export var local_sequence_name: String

var local_sequence_triggers: Array[SequenceTriggerResource]


func _ready():
	GlobalSignals.local_sequence_entered_tree.emit(self)


func add_sequence_trigger(trigger_signal: Signal, trigger_callback: Callable):
	var new_sequence_trigger = SequenceTriggerFactory.create_new_trigger(trigger_signal, trigger_callback)
	local_sequence_triggers.push_back(new_sequence_trigger)


func _handle_sequence_update():
	pass
