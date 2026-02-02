class_name RockShotAttack
extends Area3D

@export var rock_data : AttackBuff
@export var speed = 10

@onready var base_stone = $rock_model/BaseStone
@onready var rock_kai = $rock_model/RockKai
@onready var rock_leaf = $rock_model/RockLeaf

func _ready():
	create_stone_calc()

func _process(delta):
	#var dir = get_tree().get_first_node_in_group("player").global_transform_basis.z.normalized()
	#global_position += dir * speed * delta
	pass

func create_stone_calc() -> void:
	if rock_data.attack_damage < 3:
		base_stone.show()
	elif rock_data.attack_damage < 7:
		rock_leaf.show()
	else:
		rock_kai.show()

func _on_body_entered(body):
	if body is PlayerController:
		print(body)
		queue_free()
