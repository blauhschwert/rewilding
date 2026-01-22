extends PlayerState


func _on_airbone_state_processing(_delta):
	if player_controller.is_on_floor():
		player_controller.state_chart.send_event("onGrounded")
