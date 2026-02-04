class_name MainMenu
extends Control

signal game_started

@onready var title_screen = %TitleScreen

func _ready():
	title_screen.text = ProjectSettings.get_setting("application/config/name")

func _on_button_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	game_started.emit()

func _on_options_button_pressed():
	$TitleScreenMain.hide()
	$Options.show()

func _on_exit_button_pressed():
	get_tree().quit()

func _on_back_pressed():
	$Options.hide()
	$TitleScreenMain.show()
