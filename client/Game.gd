extends Node2D

var ws = WebSocketClient.new()
var URL = "ws://localhost:9001/"
var enemy = preload("res://Enemy.tscn")

var data = {
	"x": 0,
	"y": 0,
	"id": 0
}

var enemies = []

func _ready():
	data["id"] = $Player.id
	ws.connect('connection_closed', self, '_closed')
	ws.connect('connection_error', self, '_closed')
	ws.connect('connection_established', self, '_connected')
	ws.connect('data_received', self, '_on_data')
	
	var err = ws.connect_to_url(URL)
	if err != OK:
		print('connection refused')

func _closed():
	print("connection closed")
	
func _connected():
	print("connected to host")
	
func _on_data():
	var payload = JSON.parse(ws.get_peer(1).get_packet().get_string_from_utf8()).result
	for enemy in enemies:
		enemy.queue_free()
	enemies = []
	for player in payload:
		if player.id != data["id"]:
			var e = enemy.instance()
			e.position = Vector2(player["x"], player["y"])
			enemies.append(e)
			add_child(e)

func _process(delta):
	data["x"] = $Player.position.x
	data["y"] = $Player.position.y
	ws.get_peer(1).put_packet(JSON.print(data).to_utf8())
	ws.poll()

func _on_Button_pressed():
	ws.disconnect_from_host(1000, str(data["id"]))
	get_tree().quit()
