class_name Game
extends Node3D

func _ready():
	$BackgroundMusik.play()
	randomize()

func _process(_delta):
	pass

func _increase_bits() -> void:
	$UI.add_score.emit(randi() % 3 + 1)


func _on_mob_spawner_3d_mob_spawned(mob):
	mob.died.connect(_increase_bits)
