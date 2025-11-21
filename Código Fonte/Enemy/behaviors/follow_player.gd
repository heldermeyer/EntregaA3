extends Node
# Velocidade do goblin
@export var speed: float = 100.0
# Distância de perseguição do goblin (com esse valor, ele consegue enxergar bem)
@export var chase_distance: float = 600.0
# Distância de atque
@export var attack_distance: float = 60.0
# Tempo de atualizção para atualizar o caminho
@export var path_update_time: float = 0.25

var enemy: CharacterBody2D
var sprite: Sprite2D
var animations: AnimationPlayer

# Referência ao AStarGrid (Deve estar no grupo de cena "astar"). Orientado a componentes.
@onready var grid: Node = get_tree().get_first_node_in_group("astar")

var current_path: Array = []
var current_index := 0
var timer := 0.0
# Primeira função a ser carregada quando o jogo é iniciado
func _ready():
	enemy = get_parent() as CharacterBody2D
	sprite = enemy.get_node("SpriteEnemy")
	animations = enemy.get_node("AnimationPlayer")
# Essa função faz o goblin decidir se vai se manter em estado de descanso,
# se vai atacar ou se vai perseguir o nosso herói
func _physics_process(delta: float):
	if GameManager.is_game_over or GameManager.player_position == Vector2.ZERO:
		enemy.velocity = Vector2.ZERO
		return

	var player_pos = GameManager.player_position
	var distance = enemy.global_position.distance_to(player_pos)

	# 1. Inoperante
	if distance > chase_distance:
		enemy.velocity = Vector2.ZERO
		_play_anim("idle_enemy")
		return

	# 2. Atacar
	if distance <= attack_distance:
		enemy.velocity = Vector2.ZERO
		_play_anim("attack_enemy")
		return

	# 3. Perseguir
	timer -= delta
	if timer <= 0.0 or enemy.is_on_wall():
		_update_path(player_pos)
		timer = path_update_time

	_follow_path()
	
	enemy.move_and_slide()
	_flip_sprite(player_pos)



# Atualizar a rota
# Essa função, que vem do AStarGrid, atualiza o caminho até o herói. Funciona como um GPS
# para o nosso Goblin saber qual é a melhor rota até o seu objetivo, onde ele irá cansar menos.
func _update_path(target: Vector2):
	if grid == null:
		return

	var new_path_tiles = grid.get_astar_path(enemy.global_position, target)

	if new_path_tiles.is_empty():
		return

	current_path = []
	for tile in new_path_tiles:
		current_path.append(grid.navigation_tilemap.map_to_local(tile))
	
	# Inicia do 0 (Estável)
	current_index = 0


# Mover
# Nessa função, ele segue a direção do GPS
func _follow_path():
	if current_path.is_empty():
		return

	if current_index >= current_path.size():
		enemy.velocity = Vector2.ZERO
		return

	var target_pos: Vector2 = current_path[current_index]
	var dist_to_node = enemy.global_position.distance_to(target_pos)

	# Tolerância de 10px: Não exige precisão absoluta para evitar que o Goblin 
	# fique "vibrando" tentando acertar o pixel exato do centro.
	if dist_to_node < 10.0: 
		current_index += 1
		return

	var dir = (target_pos - enemy.global_position).normalized()
	enemy.velocity = dir * speed
	_play_anim("run_enemy")

# Visão
# Vai fazer o goblin olhar na direção do herói
func _flip_sprite(player_pos: Vector2):
	if player_pos.x < enemy.global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
# Animação
func _play_anim(anim_name: String):
	if animations.current_animation != anim_name:
		animations.play(anim_name)
