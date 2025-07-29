extends CanvasLayer
class_name ui_game


# Called when the node enters the scene tree for the first time.
@onready var rain: ColorRect = $rain


func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_wether() -> void:
	rain.show()

func update_wethers() -> void:
	var wethers = get_children(false)
	
func developer_mode() -> void:
	MessageSystem.send(MessageSystem.MessageType.UI_EVENT, {
		"code": "developer",
		"data": true
	})
