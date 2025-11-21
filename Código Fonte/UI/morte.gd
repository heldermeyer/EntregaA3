class_name GameOverUI
extends CanvasLayer

@onready var time_label: Label = %TimeLabel
@onready var deads_label: Label = %DeadsLabel
@onready var ouro_label: Label = %OuroLabel
@onready var restart_button: Button = %RestartButton

@export var restart_delay: float = 5.0

var monsters_deads: int
var killer: String


func _ready():
	# Inicializando as variáveis
	time_label.text = GameManager.tempo_str
	deads_label.text = str(GameManager.monsters_defeated)
	ouro_label.text = str(GameManager.quant_ouro)
	restart_button.pressed.connect(_on_RestartButton_pressed)

func _on_RestartButton_pressed():
	restart_game()

func restart_game() -> void:
	GameManager.reset()
	get_tree().reload_current_scene()
