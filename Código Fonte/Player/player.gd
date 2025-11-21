class_name Player
extends CharacterBody2D

@export_category("Status")
var health: int = 30
@export var max_health: int = 30
@export var speed: float = 3
var sword_damage: int = 4
@export_category("Morte")
@export var dead_prefab: PackedScene
@export_category("Especial")
var especial_dano: int = 10
@export var especial_intervalo: float = 5.0
@export var especial_cena: PackedScene

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $SpritePlayer
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $Hitbox
@onready var health_bar: ProgressBar = $HealthBar

var direcao: Vector2 = Vector2(0, 0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cd: float = 0.0
var hitbox_cd: float = 0.0
var especial_cd: float = 0.0

signal carne_coletada(value: int)
signal ouro_coletado(value: int)
signal cogumelo_coletado(value: int)
signal ataque_melhorado(value:int)
signal vida_melhorado(value:int)
signal especial_melhorado(value:int)


func _ready():
	GameManager.player = self
	carne_coletada.connect(func(value:int): GameManager.quant_carne += 1)
	ouro_coletado.connect(func(value:int): GameManager.quant_ouro += value)
	cogumelo_coletado.connect(func(value:int): GameManager.quant_cogumelo += 1)
	ataque_melhorado.connect(func(value:int): self.sword_damage += 2)
	vida_melhorado.connect(func(value:int): self.health += 4)
	especial_melhorado.connect(func(value:int): self.especial_dano += 1)

func _process(delta: float) -> void:
	GameManager.player_position = position
	
	# Ler direção do movimento
	read_input()
	
	# Adicionar CD aos ataques
	attack_cooldown(delta)
	
	# Tocar animação
	play_idle_run()

	# Girar sprite com teclas e mouse
	if not is_attacking:
		rotate_sprite()

	# Ataque
	attack()
	
	#Especial CD
	especial_cooldown(delta)
	
	#Atualizar health bar
	health_bar.max_value = max_health
	health_bar.value = health

func _physics_process(delta: float) -> void:
	# Modificar a velocidade
	var target_velocity = direcao * speed * 100
	if is_attacking:
		target_velocity *= 0.0
	velocity = lerp(velocity, target_velocity, 0.85)
	move_and_slide()

func read_input() -> void:
	# Obter o input vector
	direcao = Input.get_vector("esquerda", "direita", "cima", "baixo")
	
	# Atualizar condição do is_running
	was_running = is_running
	is_running = not direcao.is_zero_approx()
	
	# Apagar deadzone do input vector
	var deadzone = 0.15
	if abs(direcao.x) < deadzone:
		direcao.x = 0.0
	if abs(direcao.y) < deadzone:
		direcao.y = 0.0

func play_idle_run() -> void:
	# Tocar animação
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("Run")
			else:
				animation_player.play("idle")

func rotate_sprite() -> void:
	# Girar Sprite com base na direção do movimento
	if direcao.x != 0:
		# Atualizar flip_h com base na direção do movimento
		sprite.flip_h = direcao.x < 0
	else:
		# Obter a posição do mouse e a posição global do personagem
		var mouse_pos = get_global_mouse_position()
		var character_pos = global_position

		# Verificar se o mouse está à esquerda ou à direita do personagem
		if mouse_pos.x < character_pos.x:
			sprite.flip_h = true
		else:
			sprite.flip_h = false

func attack() -> void:
	if is_attacking:
		return
	
	if Input.is_action_just_pressed("Click"):  # Verifica se o botão do mouse foi pressionado
		var mouse_pos = get_global_mouse_position()
		var player_position = global_position
		
		var attack_animation = "attack_side_1"  # Padrão é ataque lateral
		
		# Verifica se o jogador está parado ou em movimento
		if not is_running:  # Se o jogador estiver parado, a direção de ataque é baseada na posição do mouse
			var mouse_diff = mouse_pos - player_position
			if abs(mouse_diff.x) > abs(mouse_diff.y):
				if mouse_diff.x < 0:
					attack_animation = "attack_side_1"  # Ataque à esquerda
				else:
					attack_animation = "attack_side_2"  # Ataque à direita
			else:
				if mouse_diff.y < 0:
					attack_animation = "attack_up_1"     # Ataque para cima
				else:
					attack_animation = "attack_down_1"   # Ataque para baixo
		#else:  # Se o jogador estiver em movimento, a direção de ataque é baseada na direção de movimento
			#if velocity.x > 0:
				#attack_animation = "attack_side_2"  # Ataque à direita
			#else:
				#attack_animation = "attack_side_1"  # Ataque à esquerda
		
		# Tocar a animação de ataque correspondente
		animation_player.play(attack_animation)
		
		# Configurar o cooldown de ataque
		attack_cd = 0.6
		is_attacking = true

func deal_damage_to_enemies() -> void:
	# Buscar todos os inimigos
	var bodies_in_range = sword_area.get_overlapping_bodies()
	for body in bodies_in_range:
		if body.is_in_group("enemy"):
			var enemy: Enemy = body
			var attack_direction: Vector2
			var direction_to_enemy = (enemy.position - position).normalized()
		
			
			# Determinar a direção do ataque
			if animation_player.current_animation == "attack_up_1":
				attack_direction = Vector2.UP
			elif animation_player.current_animation == "attack_down_1":
				attack_direction = Vector2.DOWN
			elif sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT

			# Verificar se o inimigo está na direção do ataque
			var dot_product = direction_to_enemy.dot(attack_direction)
			print("Dot:", dot_product)
			if dot_product >= 0.4:
				enemy.damage(sword_damage)

func attack_cooldown(delta: float) -> void:
	# Atualizar temporizador do ataque
	if is_attacking:
		attack_cd -= delta
		if attack_cd <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")

func damage(quantidade: int) -> void:
	if health <= 0:
		return

	health -= quantidade
	print("Você recebeu dano de ", quantidade, "... A vida total é:", health)
	
	# Piscar Vermelho
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	# Recuar
	##recuar()
	
	# Processar morte
	if health <= 0:
		die()

func die() -> void:
	GameManager.end_game()
	
	var parent = get_parent()
	if dead_prefab:
		var dead_object = dead_prefab.instantiate()
		dead_object.position = position
		parent.add_child(dead_object)

	queue_free()

func heal(amount: int) -> int:
	health += amount
	if health > max_health:
		health = max_health
	print("Player foi curado, vida atual:", health)
	return health

func especial_cooldown(delta: float) -> void:
	#Atualizar CD
	especial_cd -= delta
	if especial_cd > 0:
		return
	# Verificar se a tecla "F" foi pressionada
	if Input.is_action_just_pressed("Especial"):
		if GameManager.quant_cogumelo >= 1:
			especial()
			GameManager.quant_cogumelo -= 1

		# Reiniciar o tempo de recarga
		especial_cd = especial_intervalo

func especial() -> void:
		#Gerar o Especial
	
	var especial = especial_cena.instantiate()
	especial.dano = especial_dano
	add_child(especial)
