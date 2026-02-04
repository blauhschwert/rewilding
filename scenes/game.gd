class_name Game
extends Node3D

enum GameMode { MainMenuState, GameState, OptionsState}

@onready var player = %Player

func _input(event):
	if event.is_action_pressed("escape"):
		_show_main_menu()

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$UI.create_live_ui(player.health)
	$UI.game_over.connect(_on_ui_game_over)
	$BackgroundMusik.play()
	randomize()

func _process(_delta):
	pass

func _increase_bits() -> void:
	$UI.add_score.emit(randi() % 3 + 1)

func _on_mob_spawner_3d_mob_spawned(mob):
	mob.died.connect(_increase_bits)
	mob.emit_damage.connect(_on_ui_take_damage)

func _on_ui_take_damage(amount):
	$UI.remove_live.emit(amount)

func _on_ui_game_over():
	get_tree().paused = true

func _on_main_menu_game_started():
	$MainMenuLayer.hide()

func _show_main_menu() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$MainMenuLayer.show()
