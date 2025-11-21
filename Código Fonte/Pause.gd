extends Node

@export var menu_UI: PackedScene

var menu_instance: Menu = null# Variável para rastrear a instância do menu

func _process(delta):
	menu()
	
func menu():
	if Input.is_action_just_pressed("Menu"):
		if menu_instance:
			close_menu()  # Fecha o menu se estiver aberto
		else:
			open_menu()  # Abre o menu se não estiver aberto

func open_menu():
	menu_instance = menu_UI.instantiate()
	get_parent().add_child(menu_instance)
	menu_instance.menu_closed.connect(self._on_menu_closed)  # Conectar ao sinal menu_closed
	get_tree().paused = true  # Pausa o jogo

func close_menu():
	if menu_instance:
		menu_instance.closeMenu()  # Fechar o menu
		menu_instance = null
	get_tree().paused = false  # Despausa o jogo

func _on_menu_closed():
	menu_instance = null  # Limpa a referência ao menu quando ele é fechado
	get_tree().paused = false  # Despausa o jogo
