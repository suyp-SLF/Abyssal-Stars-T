extends CanvasLayer
class_name ui_developer

func _close() -> void:
	MessageSystem.send(MessageSystem.MessageType.UI_EVENT, {
		"code": "developer",
		"data": false
	})

func _visual_sacle(value: float) -> void:
	G_Environment.set_visual_sacle(value)

func _wether_selected(index: int) -> void:
	G_Environment.set_wether(index)
