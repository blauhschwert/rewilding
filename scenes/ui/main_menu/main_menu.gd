class_name MainMenu
extends Control

@onready var title_screen = %TitleScreen

func _ready():
	title_screen.text = ProjectSettings.get_setting("application/config/name")


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Game.tscn")


func _on_options_button_pressed():
	print("options")


func _on_exit_button_pressed():
	get_tree().quit()
