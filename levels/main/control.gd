extends Control

func _on_server_button_pressed() -> void:
	MainNetwork.create_server()

func _on_client_button_pressed() -> void:
	MainNetwork.create_client()


func _on_just_give_me_a_level_to_play_pressed() -> void:
	MainNetwork.do_not_invoke_this_function()
	hide()
