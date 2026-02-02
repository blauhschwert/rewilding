class_name RoboData
extends Resource

@export_enum("Fire","Ice", "Earth") var robo_type: int

@export var level = 1
@export var hp_base = 50
@export var attack = 5
@export_range(3.0,5.0,0.5) var speed

var max_hp = 0
var cur_attack = 0

func create_hp_stat() -> int:
	max_hp = hp_base + (level - 1) * 6
	return max_hp

func create_attack_stat() -> int:
	cur_attack = attack + (level - 1) * 3
	return cur_attack
