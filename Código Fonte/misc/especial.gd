extends Node2D
@export var dano: int = 10
@onready var area2d: Area2D = $Area2D

func deal_demage():
	#area de efeito(Area2D)
	var bodies = area2d.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemy"):
			var enemy: Enemy = body
			enemy.damage(dano)
