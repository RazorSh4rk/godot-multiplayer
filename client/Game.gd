extends Node2D

var ws = WebSocketPeer.new()
var URL = "ws://localhost:9001/"
var enemy = preload("res://Enemy.tscn")

var data = {
	"x": 0,
	"y": 0,
	"id": 0
}

var enemies = []

func _ready():
	data["id"] = str(rand_from_seed(100))
	
	ws.add_user_signal("connection_closed")
	ws.add_user_signal("connection_error")
	ws.add_user_signal("connection_established")
	ws.add_user_signal("data_received")
	ws.add_user_signal("disconnected")
	
	ws.connect('connection_closed', _closed)
	ws.connect('connection_error', _closed)
	ws.connect('connection_established', _connected)
	ws.connect('data_received', _on_data)
	
	var err = ws.connect_to_url(URL)
	if err != OK:
		print('connection refused')

func _closed():
	print("connection closed")
	
func _connected():
	print("connected to host")
	
func _on_data():
	var test_json_conv = JSON.new()
	
	test_json_conv.parse(ws.get_packet().get_string_from_utf8())
	var payload = test_json_conv.get_data()
	for enemy in enemies:
		enemy.queue_free()
	enemies = []
	for player in payload:
		if player.id != data["id"]:
			var e = enemy.instantiate()
			e.position = Vector2(player["x"], player["y"])
			enemies.append(e)
			add_child(e)

func _process(delta):
	data["x"] = $Player.position.x
	data["y"] = $Player.position.y
	if(ws.get_ready_state() == ws.STATE_OPEN):
		ws.put_packet(JSON.stringify(data).to_utf8_buffer())
	else:
		print("not ready to send data yet")
	ws.poll()

func _on_Button_pressed():
	ws.close()
	get_tree().quit()
