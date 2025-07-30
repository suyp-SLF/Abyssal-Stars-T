extends CanvasLayer
class_name ui_game


# Called when the node enters the scene tree for the first time.
@onready var rain: ColorRect = $rain


func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_wethers(index: int) -> void:
	var wethers = $wether.get_children(false)
	var i: int = 0;
	for wether in wethers:
		++i
		if i == index:
			wether.show()
		else:
			wether.hide()
		
	
func developer_mode() -> void:
	MessageSystem.send(MessageSystem.MessageType.UI_EVENT, {
		"code": "developer",
		"data": true
	})

func _movment_action_selected(index: int) -> void:
	G_Environment.set_movment_action(index)
	pass
