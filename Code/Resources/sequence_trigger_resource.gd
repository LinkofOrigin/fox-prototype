class_name SequenceTriggerResource
extends Resource


var trigger: Signal
var callback: Callable


func set_new_sequence_trigger(new_trigger: Signal, new_callback: Callable):
	if is_instance_valid(trigger) and is_instance_valid(callback) and trigger.is_connected(callback):
		trigger.disconnect(callback)
	
	trigger = new_trigger
	callback = new_callback
	trigger.connect(new_callback)
	
