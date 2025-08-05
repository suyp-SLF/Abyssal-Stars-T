extends CanvasLayer
class_name ui_game


# Called when the node enters the scene tree for the first time.
@onready var rain: ColorRect = $rain
const SINGLE_SCREEN = preload("res://Screen/single_screen.tscn")

var screens:Array

func _init():
	print("_init: ", "SCREEN")
	var file = FileAccess.open("res://Screen/script/screens.json", FileAccess.READ)
	var jsonstr = file.get_as_text()
	var json = JSON.parse_string(jsonstr)
	
	for index in range(json.size()):
		var screen_ins : MeshInstance2D = SINGLE_SCREEN.instantiate()
		add_child(screen_ins)
		screens.append(screen_ins)
	pass

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
