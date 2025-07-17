extends Controller

enum SpaceState { IDLE, FIRST_PRESS, SECOND_PRESS }

#空格状态
@onready var space_state: SpaceState = SpaceState.IDLE
#双击间隔
@onready var space_timer: float = 0.0
# 首先定义一个自定义数据类型来存储输入记录

class InputRecord:
	var action: String
	var time: float
	
	func _init(action_name: String, press_time: float):
		self.action = action_name
		self.time = press_time
#输入缓冲
var input_buffer: Array[InputRecord] = []
const BUFFER_TIME: float = 0.3

#上次状态
var last_command: MessageSystem.PLAYER_COMMAND
var last_velocity: Vector2i

#命令
@onready var command: MessageSystem.PLAYER_COMMAND = MessageSystem.PLAYER_COMMAND.IDLE
#速度方向大小
@onready var velocity: Vector2i = Vector2i(0, 0)
#鼠标位置
@onready var global_mouse_position: Vector2

func _ready() -> void:
	return

func _physics_process(delta: float) -> void:
	command = MessageSystem.PLAYER_COMMAND.IDLE
	velocity = Vector2(0.0, 0.0)
	#输入
	if Input.is_action_just_pressed("space"):
		input_buffer.append(InputRecord.new("space", BUFFER_TIME))
	if Input.is_action_just_pressed("move_left"):
		input_buffer.append(InputRecord.new("move_left", BUFFER_TIME))
	if Input.is_action_just_pressed("move_right"):
		input_buffer.append(InputRecord.new("move_right", BUFFER_TIME))

	#更新缓冲区时间并移除过期输入
	for i in range(input_buffer.size() - 1, -1, -1):
		input_buffer[i].time -= delta
		if input_buffer[i].time <= 0:
			input_buffer.remove_at(i)
	#A、D输入，移动逻辑
	var direction_x = Input.get_axis("move_left", "move_right");
	var direction_y = Input.get_axis("move_up", "move_down")
	if direction_x || direction_y:
		command = MessageSystem.PLAYER_COMMAND.MOVE
		velocity.x = direction_x
		velocity.y = direction_y
	
	keyboard_command_type()
	
	#防止多次发送重复命令,发送键盘命令
	if(last_command != command or \
	 last_velocity != velocity):
		MessageSystem.send(MessageSystem.MessageType.PLAYER_COMMAND, {
			"command": command, 
			"velocity": velocity
		})
		last_command = command
		last_velocity = velocity
	#发送鼠标命令
	if Input.is_action_just_pressed("click_left"):
		getPosition()
		MessageSystem.send(MessageSystem.MessageType.MOUSE_EVENT, {
			"type": "L", 
			"position": global_mouse_position
		})

func getPosition():
	global_mouse_position = G_Environment.get_global_mouse_position()

func keyboard_command_type():
	# 检测单空格输入
	if input_buffer.filter(func(x): return x.action == "space").size() >= 1:
		command = MessageSystem.PLAYER_COMMAND.JUMP
		pass
		#dinput_buffer.clear()
	# 检测双空格输入
	if input_buffer.filter(func(x): return x.action == "space").size() >= 2:
		#command = "-DOUBLESPACE-"
		pass
		input_buffer.clear()
	#检测单独左键
	if input_buffer.filter(func(x): return x.action == "click_left").size() >= 1:
		#command = "-LEFTCLICK-"
		pass
