# Esse código funciona como um GPS para o nosso inimigo (O Goblin). 
# A estratégia foi desenvolvermos um algoritmo de busca A estrela e implementar no jogo
# para ajudar o goblin a encontrar o melhor caminho, com menor custo, até o nosso herói.

extends Node2D

# Nome da camada de dados no tileset, responsável pelo custo dos caminhos
const COST_LAYER_NAME = "cost"
# Nosso mapa
@export var navigation_tilemap: TileMapLayer
# Se for 'true', vai desenhar o mapa no debug
@export var debug_draw: bool = true
# Vetor 2D que futuramente irá encontrar a posição central de cada célula (bloco)
var auto_offset: Vector2 = Vector2.ZERO
# Nosso dicionário de células, que salvará todo o mapa
var cells: Dictionary = {}
# O dicionário de células vizinhas
var neighbors: Dictionary = {}
# A constante para armazenar as direções (Direita, Esquerda, Baixo, Cima)
const DIRS = [
	Vector2i(1, 0),
	Vector2i(-1, 0),
	Vector2i(0, 1),
	Vector2i(0, -1)
]
# Primeira função a ser carregada quando o jogo é iniciado
func _ready():
	# Carrega o grupo de cena 'astar'
	add_to_group("astar")
	# Executa a função para carregar a posição central da célula
	_calculate_auto_offset()
	# Vai gerar o nosso grid e salvar em cells
	_generate_grid()
	# Redesenha o grid
	queue_redraw()
	print("AStarGrid: Grid gerado com ", cells.size(), " nós.")

func _process(_delta):
	if debug_draw:
		queue_redraw()

# OFFSET AUTOMÁTICO
# Essa função carrega todo o mapa (os quadrados), 
# para garantir que o Goblin ande pelo centro dos tiles, e não pelas bordas (o que causaria colisão)
func _calculate_auto_offset():
	if navigation_tilemap == null:
		push_error("AStarGrid: navigation_tilemap é nulo!")
		return

	auto_offset = navigation_tilemap.global_position
	
	if navigation_tilemap.has_method("tile_origin"):
		auto_offset += Vector2(navigation_tilemap.tile_origin)

	if navigation_tilemap.tile_set:
		var ts_tile_size = Vector2(navigation_tilemap.tile_set.tile_size)
		auto_offset -= ts_tile_size * 0.5

	auto_offset = Vector2(auto_offset.x, auto_offset.y)

# GERAÇÃO DO GRID
# Nessa função, o script registra todo o cenário, identificando
# o que é obstáculo e onde é área 'andável'
func _generate_grid():
	cells.clear()
	neighbors.clear()

	if navigation_tilemap == null:
		return

	var used_cells = navigation_tilemap.get_used_cells()

	for cell in used_cells:
		var tile_data = navigation_tilemap.get_cell_tile_data(cell)
		var walkable := true
		var move_cost := 1.0 

		if tile_data != null:
			if tile_data.get_collision_polygons_count(0) > 0:
				walkable = false
			
			var custom_cost = tile_data.get_custom_data(COST_LAYER_NAME)
			if typeof(custom_cost) == TYPE_INT or typeof(custom_cost) == TYPE_FLOAT:
				if float(custom_cost) > 0.0:
					move_cost = float(custom_cost)

		cells[cell] = {
			"walkable": walkable,
			"pos": cell,
			"cost": move_cost
		}

	# Build neighbors
	for cell in cells.keys():
		if not cells[cell].walkable:
			continue

		neighbors[cell] = []

		for d in DIRS:
			var n = cell + d
			if cells.has(n) and cells[n].walkable:
				neighbors[cell].append(n)



# AlGORITMO DE BUSCA
# Essa função pega a posição do goblin no mapa e o localização do herói e depois executa a função _find_path
func get_astar_path(start_world: Vector2, goal_world: Vector2) -> Array:
	if navigation_tilemap == null:
		return []

	var s = start_world - auto_offset
	var g = goal_world - auto_offset

	var start_tile = navigation_tilemap.local_to_map(s)
	var goal_tile = navigation_tilemap.local_to_map(g)

	return _find_path(start_tile, goal_tile)

# FUNÇÃO PARA ENCONTRAR O CAMINHO
# Nessa função, o nosso goblin acessa para poder encontrar o caminho de melhor custo, utilizando
# f(x) = g(x) + h(x), onde g é o custo acumulado e h (heurística, utilizando o método de manhattan)
# é o valor estimado até o objetivo. A lista aberta é ordenada para sempre expandirmos o nó com 
# menor custo total f(x) primeiro, garantindo eficiência
func _find_path(start: Vector2i, goal: Vector2i) -> Array:
	if not cells.has(start) or not cells.has(goal):
		return []

	if not cells[start].walkable or not cells[goal].walkable:
		return []

	var open_set: Array = [start]
	var came_from = {}
	
	var g_score = {}
	var f_score = {}

	for c in cells.keys():
		g_score[c] = INF
		f_score[c] = INF

	g_score[start] = 0
	f_score[start] = _heuristic(start, goal)

	while open_set.size() > 0:
		open_set.sort_custom(func(a, b): return f_score[a] < f_score[b])
		var current = open_set[0]

		if current == goal:
			return _reconstruct_path(came_from, current)

		open_set.remove_at(0)

		for n in neighbors.get(current, []):
			var move_cost = cells[n]["cost"]
			var tentative_g = g_score[current] + move_cost

			if tentative_g < g_score[n]:
				came_from[n] = current
				g_score[n] = tentative_g
				f_score[n] = tentative_g + _heuristic(n, goal)

				if n not in open_set:
					open_set.append(n)

	return []

# Função heurística utilizando o método de manhattan
func _heuristic(a: Vector2i, b: Vector2i) -> float:
	return abs(a.x - b.x) + abs(a.y - b.y)

# Essa função retorna o caminho de menor custo par ao Goblin
func _reconstruct_path(came_from, current):
	var path: Array = [current]
	while came_from.has(current):
		current = came_from[current]
		path.append(current)
	path.reverse()
	return path

# ÁRES DESENHADS PELO DEBUG (VERMELHO (Obstáculos)/AMARELO (Areia)/VERDE (Grama))
func _draw():
	if not debug_draw or navigation_tilemap == null:
		return

	var tile_size = Vector2(navigation_tilemap.tile_set.tile_size)

	for cell in cells.keys():
		var wp = navigation_tilemap.map_to_local(cell) + auto_offset
		var rect = Rect2(wp, tile_size)
		
		if cells[cell].walkable:
			# Areia amarela (custo = 5)
			if cells[cell]["cost"] > 1.5:
				draw_rect(rect, Color(0.9, 0.8, 0.1, 0.4), true)
			# Grama verde (custo = 1)
			else:
				draw_rect(rect, Color(0, 1, 0, 0.1), true)
		else:
			# Paredes vermelhas
			draw_rect(rect, Color(1, 0, 0, 0.4), true)
