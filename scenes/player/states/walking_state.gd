extends PlayerState

func _on_walking_state_processing(_delta):
	if Input.is_action_pressed("sprint"):
		player_controller.state_chart.send_event("onSprinting")

func _on_walking_state_entered():
	player_controller.walk()
