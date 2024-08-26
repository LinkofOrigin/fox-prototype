extends LocalSequence

@onready var test_sprite: Node2D = %TestSprite


func _ready():
	await test_sprite.ready
	set_up_triggers()


func set_up_triggers():
	add_sequence_trigger(test_sprite.player_entered_shape, Callable.create(self, "_handle_player_entered_sprite_sequence"))


func _handle_player_entered_sprite_sequence():
	print("sequence trigger fired!")
	GlobalSignals.local_sequence_updated.emit(self)
