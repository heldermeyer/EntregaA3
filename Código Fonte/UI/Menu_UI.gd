class_name Menu
extends CanvasLayer

@onready var atq_Button: Button = %AtqButton
@onready var vida_Button: Button = %VidaButton
@onready var especial_Button: Button = %EspecialButton
@onready var close_button: Button = %CloseButton
@onready var player: Player

signal menu_closed  # Sinal para informar que o menu foi fechado

func _ready():
	player = GameManager.player
	atq_Button.pressed.connect(atqUP)
	vida_Button.pressed.connect(vidaUP)
	especial_Button.pressed.connect(especialUP)
	close_button.pressed.connect(closeMenu)
	
func atqUP():
	if GameManager.quant_ouro < 5:
		return
	GameManager.quant_ouro -= 5
	print("Aumentando ataque")
	player.emit_signal("ataque_melhorado", 2)  # Emitir com valor 2

func vidaUP():
	if GameManager.quant_ouro < 5:
		return
	GameManager.quant_ouro -= 5
	print("Aumentando vida")
	player.emit_signal("vida_melhorado", 4)  # Emitir com valor 4

func especialUP():
	if GameManager.quant_ouro < 10:
		return
	GameManager.quant_ouro -= 10
	print("Aumentando especial")
	player.emit_signal("especial_melhorado", 1)  # Emitir com valor 1

func closeMenu():
	emit_signal("menu_closed")
	queue_free()
	
