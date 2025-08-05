extends Node

@onready var character = $"../Character"

var textures:Array = []
var characters:Array[Node] = []

var camera_total : Array
@onready var area_2d = $"../screen/MeshInstance2D/Area2D"
@onready var sigin_center = $"../SiginCenter"


const SINGLE_SCREEN = preload("res://scences/screen/single_screen.tscn")

var screen_btns:Array = [{"name": "console", "type": "console", "node": null, "enable": true}]
var screens:Array
var json

signal Action(cmd)

func _init():
	print("_init: ", "SCREEN")
	var file = FileAccess.open("res://scences/screen/script/screens.json", FileAccess.READ)
	var jsonstr = file.get_as_text()
	json = JSON.parse_string(jsonstr)
	
	for index in range(json.size()):
		var screen_ins : MeshInstance2D = SINGLE_SCREEN.instantiate()
		add_child(screen_ins)
		screens.append(screen_ins)
	pass

func _enter_tree():
	print("_enter_tree: ", self.name)
	var win_size = get_viewport().get_window().size;
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

func _ready():
	print("_ready: ", self.name)
	sigin_center.connect("Camera", Callable(self, "_camera_transmit"))
	for index in range(json.size()):
		screens[index].connect("Screen", Callable(sigin_center, "_screen_receive"))
		screens[index].connect("Action", Callable(sigin_center, "_action_receive"))
		
		sigin_center.connect("Screen", Callable(screens[index], "_screen_transmit"))
		sigin_center.connect("Mouse", Callable(screens[index], "_mouse_transmit"))
	pass


func _process(delta):
	pass
	
#get CAMERAS from SIGNLCENTER
func _camera_transmit(nodes: Array, type, cameras):
	nodes.push_back(self)
	var msg: PackedStringArray = PackedStringArray()
	msg.append("-------------------------------------------------")
	msg.append("- SIGINEFFECT --- _camera_effect -")
	for index in range(nodes.size()):
		msg.append("receive---" + str(index) + "---" + str(nodes[index]))
	msg.append("%s")
	msg.append("-------------------------------------------------")
	var msgs = "\r".join(msg)
	print(msgs % ["\r".join(cameras)])
	
	if "add" == type:
		add_cameras(cameras)
	elif "sub" == type:
		sub_cameras(cameras)
	pass
#get ACTIONS from SIGNLCENTER
func actions_station(cmd):
	print("ACTION--",cmd)
	Action.emit(cmd)
	pass

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

func updateCameraButtons():
	#reinit item data
	screen_btns.clear()
	screen_btns.append({"name": "console", "type": "console", "node": null, "enable": true})
	for camera in camera_total:
		screen_btns.append({"name": camera.name, "type": "camera", "node": camera, "enable": true})
	
	for index in range(json.size()):
		screens[index].updateOption()


func _mouse_input_event(_camera: Camera3D, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	pass

func _input(event):
	pass

func _unhandled_input(event: InputEvent) -> void:
	print(123)
