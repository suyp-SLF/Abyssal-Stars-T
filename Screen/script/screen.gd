@tool
extends MeshInstance2D

var size:Vector2
var skew_top:Vector2 = Vector2(0, 0)
var is_mouse_inside := false
var subviewport : SubViewport
var using_screen = 0
var screens:Array

@onready var console = $Control/VBoxContainer
@onready var control = $Control
@onready var option_button = $Control/OptionButton
@onready var rich_text_label = $Control/VBoxContainer/RichTextLabel
@onready var line_edit = $Control/VBoxContainer/LineEdit

signal Screen(old, new)
signal Action(cmd)

var context = "RichTextLabel is a flexible way of adding text to your project, with support for [i]italics[/i], [b]bold[/b] and [i][b]both[/b][/i].
[u]Underline[/u] and [s]strikethrough[/s] work too, including with [u][i]italics[/i][/u], [u][b]bold[/b][/u] and [u][i][b]both[/b][/i][/u].

Text [color=#4cf]color[/color], [fgcolor=#49c9]foreground [color=#4cf]color[/color][/fgcolor]  and  [bgcolor=#49c9]background [color=#4cf]color[/color][/bgcolor]  can be adjusted.

It's also possible to include [img]res://unicorn_icon.png[/img] [font_size=24]custom images[/font_size], as well as [color=aqua][url=https://godotengine.org]custom URLs[/url][/color]. [hint=This displays a hint.]Hover this to display a tooltip![/hint]
Left alignment is default,[center]but center alignment is supported,[/center][right]as well as right alignment.[/right]

[fill][dropcap font_size=48 color=yellow margins=0,-10,0,-12]F[/dropcap]ill alignment is also supported, and allows writing very long text that will end up fitting the horizontal space entirely with words of joy. Drop caps are also supported. When using a drop cap, the first character of a paragraph is made larger, taking up several lines of text and optionally using a specific font or color.[/fill]

Several effects are also available:    [pulse]Pulse[/pulse]    [wave]Wave[/wave]    [tornado]Tornado[/tornado]    [shake]Shake[/shake]    [fade start=75 length=7]Fade[/fade]    [rainbow]Rainbow[/rainbow]

[table=2]
[cell border=#fff3 bg=#fff1]
[ul]
Tables
are supported.
[/ul]
[/cell]
[cell border=#fc13 bg=#fc11]
[ol]
Ordered
list example.
[/ol]
[/cell]

[/table]

You can also create custom tags/effects, or customize behavior of [lb]url[rb] tags on click. For full reference, [color=aqua][url=https://docs.godotengine.org/en/latest/tutorials/gui/bbcode_in_richtextlabel.html]check the documentation.[/url][/color]

"
func _screen_transmit(old, new):
	print("end", old, new)
	pass
# Called when the node enters the scene tree for the first time.

func _mouse_transmit(nodes, touchNode, nodePosition, touchPoint) -> void:
	if is_mouse_inside:
		nodes.push_back(self)
		var msg: PackedStringArray = PackedStringArray()
		msg.append("-------------------------------------------------")
		msg.append("- SIGINEFFECT --- _mouse_effect -")
		for index in range(nodes.size()):
			msg.append("transmit---" + str(index) + "---" + str(nodes[index]))
		msg.append("touchnode -- %s")
		msg.append("touchpoint -- %s")
		msg.append("-------------------------------------------------")
		print("\r".join(msg) % [touchNode, nodePosition, touchPoint])
	pass

func _mouse_entered() -> void:
	#print("_mouse_entered")
	is_mouse_inside = true
	pass

func _mouse_exited() -> void:
	#print("_mouse_exited")
	is_mouse_inside = false
	pass

func _item_selected(index) -> void:
	Screen.emit(using_screen,index)
	using_screen = index
	if "camera" == screens[index]["type"]:
		setsubviewport(screens[index]["node"])
	elif "console" == screens[index]["type"]:
		setConsole()
	pass

func _ready():
	updateOption()
	meshDraw()
	
	var area_2d = Area2D.new()
	var collision_shape_2d = CollisionShape2D.new()
	area_2d.input_event.connect(_input_event)
	area_2d.mouse_entered.connect(_mouse_entered)
	area_2d.mouse_exited.connect(_mouse_exited)
	option_button.item_selected.connect(_item_selected)
	
	var rectshape = RectangleShape2D.new()
	rectshape.size = size;
	collision_shape_2d.shape = rectshape
	collision_shape_2d.position = size/2
	area_2d.add_child(collision_shape_2d)
	add_child(area_2d)
	
	rich_text_label.text = context
	line_edit.text_submitted.connect(_submitted)
	pass
	
func _submitted(new_text: String):
	print("_submitted----",new_text)
	rich_text_label.add_text(new_text + "\n")
	line_edit.text = ""
	#var zz = rich_text_label.get_selected_text()
	#var cmd = new_text.dedent().split(" ")
	#if cmd[0] == "move":
		#var node = subviewport.main_body
		#node.position += Vector3(10,0,0)
	#print(zz)
	Action.emit(new_text)
	pass


func setConsole():
	texture = null
	console.visible = true
	console.size = size
	console.global_position = global_position
	

func setsubviewport(sub:SubViewport):
	console.visible = false
	subviewport = sub
	texture = sub.get_texture()
	sub.size = size
	
func updateOptionDisable():
	for index in screens.size():
		if false == screens[index]["enable"]:
			if using_screen != index:
				option_button.set_item_disabled(index, true)
		else:
			option_button.set_item_disabled(index, false)
	pass

func updateOption():
	option_button.clear()
	for index in screens.size():
		if "camera" == screens[index]["type"]:
			option_button.add_item(screens[index]["name"])
		elif "console" == screens[index]["type"]:
			option_button.add_item(screens[index]["name"])
		else:
			print("screen is not using ...")

func meshDraw():
	var vertices:PackedVector2Array;
	vertices.push_back(Vector2(0, size.y + skew_top.x)) #bottom—left
	vertices.push_back(Vector2(size.x, skew_top.y)) #top-right
	vertices.push_back(Vector2(0, skew_top.x)) #top-left
	vertices.push_back(Vector2(0, size.y + skew_top.x))#bottom—left
	vertices.push_back(Vector2(size.x, skew_top.y))#top-right
	vertices.push_back(Vector2(size.x, size.y + skew_top.y))#bottom-right
	#vertices.push_back(Vector2(0, 300))
	#vertices.push_back(Vector2(200 , 0))
	#vertices.push_back(Vector2(0, 100))
	#vertices.push_back(Vector2(0, 300))
	#vertices.push_back(Vector2(200, 0))
	#vertices.push_back(Vector2(200, 200))
	var colors:PackedColorArray;
	colors.push_back(Color(1.0, 1.0, 1.0, 1.0))
	colors.push_back(Color(1.0, 1.0, 1.0, 1.0))
	colors.push_back(Color(1.0, 1.0, 1.0, 1.0))
	colors.push_back(Color(1.0, 1.0, 1.0, 1.0))
	colors.push_back(Color(1.0, 1.0, 1.0, 1.0))
	colors.push_back(Color(1.0, 1.0, 1.0, 1.0))
	var uvs:PackedVector2Array;
	uvs.push_back(Vector2(0,1))
	uvs.push_back(Vector2(1,0))
	uvs.push_back(Vector2(0,0))
	uvs.push_back(Vector2(0,1))
	uvs.push_back(Vector2(1,0))
	uvs.push_back(Vector2(1,1))
	
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_COLOR] = colors
	arrays[ArrayMesh.ARRAY_TEX_UV] = uvs
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh = arr_mesh
	pass # Replace with function body.

func _input_event(viewport: Node, event: InputEvent, shape_idx: int):
	print("_input_event")
	#if subviewport != null && is_mouse_inside:
		#event.position = (event.global_position - sub_position)
		#subviewport.push_input(event)
	#pass

func _unhandled_input(event: InputEvent) -> void:
	# Check if the event is a non-mouse/non-touch event
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
		if is_instance_of(event, mouse_event) && subviewport != null && is_mouse_inside:
			var canvaspos = self.global_position;
			event.position = (event.global_position - canvaspos)
			subviewport.push_input(event)
			pass
