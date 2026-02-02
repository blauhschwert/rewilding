class_name Game
extends Node3D

@onready var player = %Player

func _ready():
	$UI.create_live_ui(player.health)
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
