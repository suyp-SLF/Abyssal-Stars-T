extends Button

var _command = MessageSystem.PLAYER_COMMAND.UP

func setup(command: MessageSystem.PLAYER_COMMAND):
	_command = command

func _ready() -> void:
	_ready_after()

func _ready_after() -> void:
	pass

func _pressed() -> void:
	MessageSystem.send(MessageSystem.MessageType.PLAYER_COMMAND, {
		"command": _command, 
	})
	pass
