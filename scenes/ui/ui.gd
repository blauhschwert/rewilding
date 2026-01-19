class_name UI
extends Control

signal add_score(amount)

var bits : int = 0

func _ready():
	add_score.connect(_add_bits)

func _process(_delta):
	$Score.text = "bits : " + str(bits)

func _add_bits(amount) -> void:
	bits += amount
