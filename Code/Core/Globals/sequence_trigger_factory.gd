extends Node

var sequence_trigger_resource: SequenceTriggerResource = preload("res://Resources/Sequences/sequence_trigger_resource.tres")


func create_new_trigger(trigger_signal: Signal, trigger_callback: Callable):
	var new_trigger = sequence_trigger_resource.duplicate()
	new_trigger.set_new_sequence_trigger(trigger_signal, trigger_callback)
