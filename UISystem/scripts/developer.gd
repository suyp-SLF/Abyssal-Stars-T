extends CanvasLayer
class_name ui_developer

func _close() -> void:
	MessageSystem.send(MessageSystem.MessageType.UI_EVENT, {
		"code": "developer",
		"data": false
	})
