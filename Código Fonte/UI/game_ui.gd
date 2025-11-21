extends CanvasLayer

@onready var tempo_label: Label = %Tempo
@onready var ouro_label: Label = %Ouro
@onready var carne_label: Label = %Carne
@onready var cogumelo_label: Label = %Cogumelo


func _process(delta: float):
	tempo_label.text = GameManager.tempo_str
	carne_label.text = str(GameManager.quant_carne)
	ouro_label.text = str(GameManager.quant_ouro)
	cogumelo_label.text = str(GameManager.quant_cogumelo)
