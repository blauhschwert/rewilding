class_name UI
extends Control

signal add_score(amount)
signal remove_live(amount)
signal game_over

const LIVE_TEXTURE = preload("res://assets/etc/Health.png")

var bits : int = 0
var health = 0

@onready var live_force = %LiveForce

func _ready():
	add_score.connect(_add_bits)
	remove_live.connect(_remove_live_icon)

func _process(_delta):
	$Score.text = "bits : " + str(bits)

func _add_bits(amount) -> void:
	bits += amount

func create_live_ui(amount) -> void:
	for i in amount:
		var new_texture = TextureRect.new()
		new_texture.texture = LIVE_TEXTURE
		new_texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		%LiveForce.add_child(new_texture)

func _remove_live_icon(amount) -> void:
	for i in amount:
		var remove_last := live_force.get_child(i)
		%LiveForce.remove_child(remove_last)
