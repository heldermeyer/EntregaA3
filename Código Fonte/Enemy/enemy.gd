class_name Enemy
extends Node2D

@export_category("Vida e Morte")
@export var health: int = 10
@export var dead_prefab: PackedScene

@export_category("Nockback")
@export var recuo_distancia: float = 50.0  # Distância de recuo
@export var recuo_duracao: float = 0.2     # Duração do recuo

@export_category("Ataque")
@export var attack_distance = 50.0
@export var attack = 2

@export_category("Drops")
@export var drop_chance: float = 0.3 #Chance de dropar algo
@export var drop_items: Array[PackedScene]
@export var drop_chances: Array[float]

@onready var attack_area: Area2D = $EnemyAtqArea
@onready var damage_digit_position = $DamageMarker
var damage_digit_prefab: PackedScene

func _ready() -> void:
	damage_digit_prefab = preload("res://misc/damage_digit.tscn")

func damage(quantidade: int) -> void:
	health -= quantidade
	print("Inimigo recebeu dano de ", quantidade, "... A vida total é:", health)
	
	# Piscar Vermelho
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	# Recuar
	recuar()
	
	#Criar DamageDigit
	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = quantidade
	if damage_digit_position:
		damage_digit.global_position = damage_digit_position.global_position
	else:
		damage_digit.global_position = global_position

	get_parent().add_child(damage_digit)
	# Processar morte
	if health <= 0:
		die()

func recuar() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	
	# Calcular direção de recuo (oposto à frente do inimigo)
	var recuo_direcao: Vector2
	var player_position = GameManager.player_position
	if not player_position:
		print("Player position not found!")
		return
	var difference = player_position - position
	var direcao = difference.normalized()
	if direcao.x > 0:
		recuo_direcao = -transform.x.normalized()
	elif direcao.x < 0:
		recuo_direcao = transform.x.normalized()
	var nova_posicao = global_position + recuo_direcao * recuo_distancia
	
	tween.tween_property(self, "global_position", nova_posicao, recuo_duracao)

func die() -> void:
	#dado
	var dado = randf()
	#drop
	if dado <= drop_chance:
		drop_item()
	elif dado > drop_chance:
		var dead_object = dead_prefab.instantiate()
		dead_object.position = position
		get_parent().add_child(dead_object)
	
	GameManager.monsters_defeated += 1

	queue_free()

@warning_ignore("unused_parameter")
func deal_damage_to_player(dano: int) -> void:
	var bodies_in_range = attack_area.get_overlapping_bodies()
	for body in bodies_in_range:
		if body.is_in_group("player"):
			var player: Player = body
			player.damage(attack)
			# Atualiza a referência ao último inimigo que atacou o jogador
			GameManager.last_attacking_enemy = self
	
	pass

func drop_item() ->void:
	var drop = get_random_drop().instantiate()
	drop.position = position
	get_parent().add_child(drop)

func get_random_drop() -> PackedScene:
	if drop_items.size() == 1:
		return drop_items[0]
	#calcular chance maxima
	var max_chance: float = 0
	@warning_ignore("shadowed_variable")
	for drop_chance in drop_chances:
		max_chance += drop_chance
	
	#jogar dado
	var random_value = randf() * max_chance
	
	#Girar Roleta
	var seta: float = 0.0
	for i in drop_items.size():
		@warning_ignore("shadowed_variable")
		var drop_item = drop_items[i]
		@warning_ignore("incompatible_ternary", "shadowed_variable")
		var drop_chance = drop_chances[i] if i < drop_chances.size() else 1
		if random_value <= drop_chance + seta:
			return drop_item
		seta += drop_chance
		
	return drop_items[0]
