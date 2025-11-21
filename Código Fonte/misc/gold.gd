class_name Gold
extends Node2D

@export var valor: int = 10

func _ready():
	$Area2D.body_entered.connect(on_body_entered)
	
func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player: Player = body
		player.ouro_coletado.emit(valor)
		queue_free()
