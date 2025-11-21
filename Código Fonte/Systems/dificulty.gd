extends Node

@export var mob_spawnner: MobSpawnner
@export var diff_inicial: float = 60.0
@export var mobs_increase_per_minute: float = 30.0
@export var wave_duration: float = 20.0
@export var break_intensity: float = 0.5

var time: float = 0.0


func _process(delta):
	if GameManager.is_game_over: return
	time += delta
	
	#Dificuldade Linear
	var spawn_rate = diff_inicial + mobs_increase_per_minute * (time / 60)
	
	# sin() Pi = 3.14    0 - 2Pi = TAU
	#Sistema de ondar  
	var sin_wave = sin((time * TAU) / wave_duration)
	var wave_factor = remap(sin_wave, -1.0, 1.0, break_intensity, 1)
	
	#Aplicar Dificuldade
	spawn_rate *= wave_factor
	
	mob_spawnner.mobs_per_minute = spawn_rate
