extends CanvasLayer
class_name ui_game


# Called when the node enters the scene tree for the first time.
@onready var rain: ColorRect = $rain
const SINGLE_SCREEN = preload("res://Screen/single_screen.tscn")

var screens:Array
var camera_total : Array
var json

var screen_btns:Array = [{"name": "console", "type": "console", "node": null, "enable": true}]


func _init():
	print("_init: ", "SCREEN")
	var file = FileAccess.open("res://Screen/script/screens.json", FileAccess.READ)
	var jsonstr = file.get_as_text()
	json = JSON.parse_string(jsonstr)
	
	for index in range(json.size()):
		var screen_ins : MeshInstance2D = SINGLE_SCREEN.instantiate()
		add_child(screen_ins)
		screens.append(screen_ins)
		
	screen_config()

func screen_config():
	print("_enter_tree: ", self.name)
	var win_size = Vector2(1200,1000)
	var position_x = 0
	for index in range(json.size()):
		var name = json[index].get("name")
		var width = json[index].get("width")
		var height = json[index].get("height")
		var margin_t = json[index].get("margin_top")
		var margin_l = json[index].get("margin_left")
		var margin_r = json[index].get("margin_right")
		var skew_top = json[index].get("skew_top",0)
		
		screens[index].size = Vector2(win_size.x * width, win_size.y * height)
		screens[index].skew_top = Vector2(0, skew_top)
		screens[index].position = Vector2(position_x, margin_t)
		screens[index].screens = screen_btns
		position_x += win_size.x * width
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

func updateCameraButtons():
	#reinit item data
	screen_btns.clear()
	screen_btns.append({"name": "console", "type": "console", "node": null, "enable": true})
	for camera in camera_total:
		screen_btns.append({"name": camera.name, "type": "camera", "node": camera, "enable": true})
	
	for index in range(json.size()):
		screens[index].updateOption()

func add_cameras(cameras):
	print("CAMERA--",cameras)
	camera_total.append_array(cameras)
	updateCameraButtons()
	pass

func sub_cameras(cameras):
	for camera in cameras:
		camera_total.erase(camera)
	updateCameraButtons()

func change_Screen(old, new):
	screen_btns[old]["enable"] = true
	screen_btns[new]["enable"] = false
	
	for screen in screens:
		screen.updateOptionDisable()
	pass
