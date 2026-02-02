class_name MobSpawner3D
extends Node3D

signal mob_spawned(mob)

@export var mob_to_spawn: PackedScene = null

var wait_multiplier = 1.9

@onready var marker_3d = %Marker3D
@onready var timer = %Timer

func _on_timer_timeout():
	var new_mob = mob_to_spawn.instantiate()
	add_child(new_mob)
	new_mob.global_position = marker_3d.global_position
	mob_spawned.emit(new_mob)
	#TODO: Improve the Timer funcion
	if wait_multiplier >= 1.6:
		var wait_timer = randf_range(3.0,5.0) * wait_multiplier
		$%Timer.start(wait_timer)
		wait_multiplier -= 0.1
	else:
		print(wait_multiplier)
		wait_multiplier = 1.9
