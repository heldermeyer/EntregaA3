class_name Cogumelo
extends Node2D

@export var cura: int = 10

func _ready():
	$Area2D.body_entered.connect(on_body_entered)
	
func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player: Player = body
		player.cogumelo_coletado.emit(1)
		queue_free()
