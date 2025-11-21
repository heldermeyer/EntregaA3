extends Node

signal game_over

var player: Player
var player_position: Vector2
static var last_attacking_enemy: Enemy
var is_game_over: bool = false

var tempo: float = 0.0
var tempo_str: String
var quant_carne: int = 0
var quant_ouro: int = 0
var monsters_defeated: int = 0
var quant_cogumelo: int = 0

func _process(delta: float):
	tempo += delta
	var tempo_em_segundos: int = floori(tempo)
	var segundos: int = tempo_em_segundos % 60
	var minutos: int = tempo_em_segundos / 60
	tempo_str = "%02d:%02d" % [minutos, segundos]
	

func end_game():
	if is_game_over: return
	is_game_over = true
	game_over.emit()
	
func reset():
	player = null
	player_position = Vector2.ZERO
	last_attacking_enemy = null
	is_game_over = false
	tempo = 0.0
	tempo_str = "00:00"
	quant_carne = 0
	quant_ouro = 0
	monsters_defeated = 0
	quant_cogumelo = 0
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
