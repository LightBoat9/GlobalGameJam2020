extends Button


func _on_Button_button_down():
	EventHandler.delete_save()
	get_tree().quit()
